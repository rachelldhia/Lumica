import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/services/speech_service.dart';
import 'package:lumica_app/data/services/gemini_service.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:lumica_app/domain/repositories/chat_repository.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:lumica_app/data/repositories/chat_repository_impl.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';
import 'package:lumica_app/features/ai_chat/services/chat_history_manager.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// AI Chat Controller - Refactored with Service Integration
/// Now uses SpeechService and ChatHistoryManager for better separation
class AiChatController extends GetxController {
  final _profileController = Get.find<ProfileController>();
  final GeminiService _geminiService;
  final ChatRepositoryInterface _repository;
  final SpeechService _speechService;
  final ChatHistoryManager _historyManager;

  AiChatController({
    GeminiService? geminiService,
    ChatRepositoryInterface? repository,
    SpeechService? speechService,
    ChatHistoryManager? historyManager,
  }) : _geminiService =
           geminiService ??
           GeminiService(
             userName: Get.find<ProfileController>().userName.value,
           ),
       _repository = repository ?? ChatRepositoryImpl(),
       _speechService = speechService ?? SpeechService(),
       _historyManager = historyManager ?? ChatHistoryManager();

  RxString get userAvatarUrl => _profileController.userAvatarUrl;

  // Use history manager's scroll controller
  ScrollController get scrollController => _historyManager.scrollController;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isAiTyping = false.obs;
  final RxBool isFetchingHistory = true.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Suggestion Chips
  final RxList<String> suggestedReplies = <String>[].obs;

  // Voice Mode State - delegated to SpeechService
  RxBool get isListening => _speechService.isListening;
  bool get isSpeechAvailable => _speechService.isAvailable;

  // Rate limiting
  DateTime? _lastMessageTime;
  final Duration _minMessageInterval = const Duration(seconds: 2);

  // Animation key for forcing animation replay on navigation
  final RxInt animationKey = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Reinitialize Gemini with user name once profile loads
    final currentName = _profileController.userName.value;
    if (currentName.isNotEmpty) {
      _geminiService.reinitializeWithUserName(currentName);
    }

    // Listen to changes in user name for personalization (e.g. after profile edit)
    ever(_profileController.userName, (name) {
      _geminiService.reinitializeWithUserName(name);
    });

    _loadChatHistory();
    _initializeSpeech();
  }

  @override
  void onClose() {
    messageController.dispose();
    _historyManager.dispose();
    super.onClose();
  }

  /// Initialize speech recognition
  Future<void> _initializeSpeech() async {
    await _speechService.initializeSpeech();
  }

  /// Load chat history from repository
  Future<void> _loadChatHistory() async {
    try {
      isFetchingHistory.value = true;
      final storedMessages = await _repository.getMessages();

      messages.value = storedMessages;

      debugPrint('✅ Loaded ${messages.length} messages');

      // Restore Gemini chat context if messages exist
      if (messages.isNotEmpty) {
        _restoreGeminiContext();
        // Wait a bit for layout then scroll
        Future.delayed(
          const Duration(milliseconds: 300),
          _historyManager.scrollToBottom,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load chat history: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      isFetchingHistory.value = false;
    }
  }

  /// Save single message to repository
  Future<void> _persistMessage(ChatMessage message) async {
    try {
      await _repository.saveMessage(message);
      debugPrint('💾 Saved message');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to save message: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty || isAiTyping.value) return;

    // Rate limiting check
    final now = DateTime.now();
    if (_lastMessageTime != null) {
      final elapsed = now.difference(_lastMessageTime!);
      if (elapsed < _minMessageInterval) {
        final remaining = (_minMessageInterval - elapsed).inSeconds;
        debugPrint('⚠️ Rate limit: wait ${remaining}s');
        final tempMsg = ChatMessage.ai(
          'Please wait $remaining second${remaining > 1 ? 's' : ''} before sending another message.',
        );
        messages.add(tempMsg);
        _historyManager.scrollToBottom();

        Future.delayed(_minMessageInterval - elapsed, () {
          messages.remove(tempMsg);
        });
        return;
      }
    }

    _lastMessageTime = now;

    // Add user message
    final userMsg = ChatMessage.user(text);
    messages.add(userMsg);
    _persistMessage(userMsg);
    messageController.clear();
    HapticFeedback.selectionClick();

    _historyManager.scrollToBottom();
    _getAiResponse(text);
  }

  /// Start conversation with a quick prompt
  void startWithPrompt(String prompt) {
    messageController.text = prompt;
    sendMessage();
  }

  void _getAiResponse(String userMessage) async {
    isAiTyping.value = true;
    Future.delayed(
      const Duration(milliseconds: 100),
      _historyManager.scrollToBottom,
    );

    try {
      final aiResponse = await _geminiService.sendMessage(userMessage);
      final detectedEmotion = _extractEmotionFromResponse(aiResponse);
      final suggestions = _extractSuggestionsFromResponse(aiResponse);

      if (suggestions.isNotEmpty) {
        suggestedReplies.value = suggestions;
      } else {
        suggestedReplies.clear();
      }

      final cleanResponse = aiResponse
          .replaceAll(RegExp(r'<EMOTION:[^>]+>'), '')
          .replaceAll(RegExp(r'<SUGGEST:[^>]+>'), '')
          .trim();

      if (detectedEmotion != null) {
        await _saveDetectedMoodToTracker(detectedEmotion);
      }

      if (detectedEmotion != null) {
        final emotionMsg = ChatMessage.emotionUpdate(detectedEmotion);
        messages.add(emotionMsg);
        _persistMessage(emotionMsg);
        Future.delayed(
          const Duration(milliseconds: 100),
          _historyManager.scrollToBottom,
        );
      }

      Future.delayed(
        Duration(milliseconds: detectedEmotion != null ? 300 : 0),
        () {
          final aiMsg = ChatMessage.ai(cleanResponse, emotion: detectedEmotion);
          messages.add(aiMsg);
          _persistMessage(aiMsg);
          _historyManager.scrollToBottom();

          if (messages.length % 5 == 0) {
            Future.delayed(const Duration(milliseconds: 500), () {
              final progressMsg = ChatMessage.progressUpdate(
                'Mood ${detectedEmotion?.name ?? 'neutral'} tracked from conversation',
              );
              messages.add(progressMsg);
              _persistMessage(progressMsg);
              _historyManager.scrollToBottom();
            });
          }

          isAiTyping.value = false;
        },
      );
    } catch (e) {
      debugPrint('Error getting AI response: $e');
      final errorMsg = ChatMessage.ai(
        'I apologize, I\'m having trouble connecting right now. Please check your internet connection and try again.',
      );
      messages.add(errorMsg);
      isAiTyping.value = false;
      suggestedReplies.clear();
    }
  }

  /// Restore Gemini conversation context
  void _restoreGeminiContext() {
    try {
      final conversationMessages = messages
          .where(
            (msg) => msg.type == MessageType.user || msg.type == MessageType.ai,
          )
          .toList();

      if (conversationMessages.isEmpty) return;

      // Limit context to last 20 messages to prevent API quota issues
      final contextLimit = 20;
      final contextMessages = conversationMessages.length > contextLimit
          ? conversationMessages.sublist(
              conversationMessages.length - contextLimit,
            )
          : conversationMessages;

      final historyParams = contextMessages
          .map(
            (msg) => (isUser: msg.type == MessageType.user, text: msg.content),
          )
          .toList();

      _geminiService.restoreChatHistory(historyParams);
      debugPrint(
        '🧠 Restored ${contextMessages.length} messages to context (limited from ${conversationMessages.length})',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to restore context: $e');
    }
  }

  /// Emotion extraction
  EmotionType? _extractEmotionFromResponse(String response) {
    final emotionRegex = RegExp(r'<EMOTION:(\w+)>');
    final match = emotionRegex.firstMatch(response);

    if (match != null && match.groupCount > 0) {
      final emotionStr = match.group(1)?.toLowerCase();

      switch (emotionStr) {
        case 'happy':
          return EmotionType.happy;
        case 'sad':
          return EmotionType.sad;
        case 'angry':
          return EmotionType.angry;
        case 'calm':
          return EmotionType.calm;
        case 'excited':
          return EmotionType.excited;
        case 'stress':
          return EmotionType.stress;
        case 'despair':
          return EmotionType.despair;
        default:
          debugPrint('⚠️ Unknown emotion: $emotionStr');
          return null;
      }
    }
    return null;
  }

  /// Save detected emotion to mood tracker
  Future<void> _saveDetectedMoodToTracker(EmotionType emotion) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      if (!Get.isRegistered<MoodRepository>()) return;

      final moodRepository = Get.find<MoodRepository>();
      final moodString = _emotionToMoodString(emotion);

      final entry = MoodEntry(
        id: const Uuid().v4(),
        userId: userId,
        mood: moodString,
        timestamp: DateTime.now(),
      );

      await moodRepository.saveMoodEntry(entry);
      debugPrint('✅ Auto-tracked mood: $moodString');
    } catch (e) {
      debugPrint('❌ Failed to auto-track mood: $e');
    }
  }

  String _emotionToMoodString(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'happy';
      case EmotionType.sad:
        return 'sad';
      case EmotionType.angry:
        return 'angry';
      case EmotionType.calm:
        return 'calm';
      case EmotionType.stress:
        return 'stress';
      case EmotionType.excited:
        return 'excited';
      case EmotionType.despair:
        return 'sad';
    }
  }

  void clearChat() {
    messages.clear();
    suggestedReplies.clear();
    _geminiService.resetChat();
    _repository.clearChat();
    debugPrint('🗑️ Chat history cleared');
  }

  /// Voice Mode - Delegated to SpeechService
  Future<void> toggleListening() async {
    HapticFeedback.mediumImpact();

    if (_speechService.isListening.value) {
      await _speechService.stopListening();
      return;
    }

    await _speechService.startListening((recognizedText) {
      messageController.text = recognizedText;
      // Auto-send after recognition (optional)
      // sendMessage();
    });
  }

  /// Extract suggested replies from AI response
  List<String> _extractSuggestionsFromResponse(String response) {
    final suggestRegex = RegExp(r'<SUGGEST:([^>]+)>');
    final match = suggestRegex.firstMatch(response);

    if (match != null && match.groupCount > 0) {
      final suggestionsStr = match.group(1);
      final suggestions = suggestionsStr?.split('|') ?? [];
      return suggestions.map((s) => s.trim()).take(3).toList();
    }
    return [];
  }

  /// History Manager Delegation Methods
  void scrollToDate(DateTime date) =>
      _historyManager.scrollToDate(messages, date);
  List<DateTime> getAvailableDates() =>
      _historyManager.getAvailableDates(messages);
  String formatDateDivider(DateTime date) =>
      _historyManager.formatDateDivider(date);
  bool shouldShowDateDivider(int index) =>
      _historyManager.shouldShowDateDivider(messages, index);

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    if (date != null) {
      scrollToDate(date);
    }
  }
}
