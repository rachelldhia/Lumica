import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/domain/repositories/chat_repository.dart';
import 'package:lumica_app/features/ai_chat/data/chat_repository.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';
import 'package:lumica_app/data/services/gemini_service.dart';
import 'package:lumica_app/domain/entities/mood_entry.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AiChatController extends GetxController {
  final _profileController = Get.find<ProfileController>();
  final GeminiService _geminiService;
  final ChatRepositoryInterface _repository;

  AiChatController({
    GeminiService? geminiService,
    ChatRepositoryInterface? repository,
  }) : _geminiService = geminiService ?? GeminiService(),
       _repository = repository ?? ChatRepositoryImpl();

  RxString get userAvatarUrl => _profileController.userAvatarUrl;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool isAiTyping = false.obs;
  final RxBool isFetchingHistory = true.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Rate limiting
  DateTime? _lastMessageTime;
  final Duration _minMessageInterval = const Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// Load chat history from Supabase
  Future<void> _loadChatHistory() async {
    try {
      isFetchingHistory.value = true;
      final storedMessages = await _repository.getMessages();

      messages.value = storedMessages;
      debugPrint('✅ Loaded ${messages.length} messages from Supabase');

      // Restore Gemini chat context if messages exist
      if (messages.isNotEmpty) {
        _restoreGeminiContext();
        // Wait a bit for layout then scroll
        Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load chat history: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      isFetchingHistory.value = false;
    }
  }

  /// Save single message to Supabase
  Future<void> _persistMessage(ChatMessage message) async {
    try {
      await _repository.saveMessage(message);
      debugPrint('💾 Saved message to Supabase');
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
        // Show temporary message in UI
        final tempMsg = ChatMessage.ai(
          'Please wait $remaining second${remaining > 1 ? 's' : ''} before sending another message.',
        );
        messages.add(tempMsg);
        _scrollToBottom();

        // Remove temp message after delay
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
    _persistMessage(userMsg); // Save after user message
    messageController.clear();

    // Scroll to bottom after user message
    _scrollToBottom();

    // Get AI response from Gemini
    _getAiResponse(text);
  }

  void _getAiResponse(String userMessage) async {
    isAiTyping.value = true;

    // Scroll to show typing indicator
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    try {
      // Get response from Gemini
      final aiResponse = await _geminiService.sendMessage(userMessage);

      // Extract emotion from AI's analysis (hidden tag in response)
      final detectedEmotion = _extractEmotionFromResponse(aiResponse);

      // Clean response by removing emotion tag
      final cleanResponse = aiResponse
          .replaceAll(RegExp(r'<EMOTION:[^>]+>'), '')
          .trim();

      // Auto-track detected emotion to mood statistics
      if (detectedEmotion != null) {
        await _saveDetectedMoodToTracker(detectedEmotion);
      }

      // Add emotion update if emotion detected
      if (detectedEmotion != null) {
        final emotionMsg = ChatMessage.emotionUpdate(detectedEmotion);
        messages.add(emotionMsg);
        _persistMessage(emotionMsg);
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }

      // Add AI response (cleaned)
      Future.delayed(
        Duration(milliseconds: detectedEmotion != null ? 300 : 0),
        () {
          final aiMsg = ChatMessage.ai(cleanResponse, emotion: detectedEmotion);
          messages.add(aiMsg);
          _persistMessage(aiMsg);
          _scrollToBottom();

          // Occasionally add progress update
          if (messages.length % 5 == 0) {
            Future.delayed(const Duration(milliseconds: 500), () {
              final progressMsg = ChatMessage.progressUpdate(
                'Mood ${detectedEmotion?.name ?? 'neutral'} tracked from conversation',
              );
              messages.add(progressMsg);
              _persistMessage(progressMsg);
              _scrollToBottom();
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
      // Optional: persist error message? Maybe not.
      isAiTyping.value = false;
    }
  }

  /// Restore Gemini conversation context from loaded messages
  /// This ensures AI remembers previous conversations
  void _restoreGeminiContext() {
    try {
      // Extract only user and AI messages (skip emotion/progress updates)
      final conversationMessages = messages
          .where(
            (msg) => msg.type == MessageType.user || msg.type == MessageType.ai,
          )
          .toList();

      if (conversationMessages.isEmpty) {
        debugPrint('🔄 No conversation messages to restore');
        return;
      }

      // Restore context in Gemini service (Efficiently)
      final historyParams = conversationMessages
          .map(
            (msg) => (isUser: msg.type == MessageType.user, text: msg.content),
          )
          .toList();

      _geminiService.restoreChatHistory(historyParams);
      debugPrint(
        '🧠 Restored ${conversationMessages.length} messages to Gemini context',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to restore Gemini context: $e');
      // Non-critical error - chat will still work, just without full context
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void scrollToDate(DateTime date) {
    final targetIndex = messages.indexWhere(
      (msg) =>
          msg.timestamp.year == date.year &&
          msg.timestamp.month == date.month &&
          msg.timestamp.day == date.day,
    );

    if (targetIndex != -1 && scrollController.hasClients) {
      // Approximate scroll position (assuming average item height of 80)
      final position = targetIndex * 80.0;
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  List<DateTime> getAvailableDates() {
    final dates = <DateTime>{};
    for (var message in messages) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      dates.add(date);
    }
    return dates.toList()..sort((a, b) => b.compareTo(a));
  }

  String formatDateDivider(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }

  bool shouldShowDateDivider(int index) {
    if (index == 0) return true;

    final currentMessage = messages[index];
    final previousMessage = messages[index - 1];

    final currentDate = DateTime(
      currentMessage.timestamp.year,
      currentMessage.timestamp.month,
      currentMessage.timestamp.day,
    );

    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );

    return currentDate != previousDate;
  }

  /// Extract emotion from AI's response tag
  /// AI adds <EMOTION:emotion_name> tag based on conversation analysis
  EmotionType? _extractEmotionFromResponse(String response) {
    final emotionRegex = RegExp(r'<EMOTION:(\w+)>');
    final match = emotionRegex.firstMatch(response);

    if (match != null && match.groupCount > 0) {
      final emotionStr = match.group(1)?.toLowerCase();

      // Map string to EmotionType
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
          debugPrint('⚠️ Unknown emotion from AI: $emotionStr');
          return null;
      }
    }

    debugPrint('😐 No emotion tag in AI response');
    return null;
  }

  /// Save detected emotion to mood tracker automatically
  Future<void> _saveDetectedMoodToTracker(EmotionType emotion) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ Cannot save mood: User not auth enticated');
        return;
      }

      // Check if MoodRepository is available
      if (!Get.isRegistered<MoodRepository>()) {
        debugPrint('⚠️ MoodRepository not available for auto-tracking');
        return;
      }

      final moodRepository = Get.find<MoodRepository>();

      // Map EmotionType to mood string
      final moodString = _emotionToMoodString(emotion);

      final entry = MoodEntry(
        id: const Uuid().v4(),
        userId: userId,
        mood: moodString,
        timestamp: DateTime.now(),
      );

      await moodRepository.saveMoodEntry(entry);
      debugPrint('✅ Auto-tracked mood from AI chat: $moodString');
    } catch (e) {
      debugPrint('❌ Failed to auto-track mood: $e');
      // Silent fail - don't interrupt chat flow
    }
  }

  /// Map EmotionType to mood string for MoodRepository
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
        return 'excited'; // Map to 'excited' mood
      case EmotionType.despair:
        return 'sad'; // Map despair to sad category
    }
  }

  void clearChat() {
    messages.clear();
    _geminiService.resetChat();
    _repository.clearChat();
    debugPrint('🗑️ Chat history cleared');
  }

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    if (date != null) {
      scrollToDate(date);
    }
  }
}
