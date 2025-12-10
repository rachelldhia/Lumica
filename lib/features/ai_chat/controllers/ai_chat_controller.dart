import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';
import 'package:intl/intl.dart';

class AiChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxBool isLoading = false.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty || isLoading.value) return;

    // Add user message
    messages.add(ChatMessage.user(text));
    messageController.clear();

    // Scroll to bottom after user message
    _scrollToBottom();

    // Simulate AI response with emotion detection
    _simulateAiResponse(text);
  }

  void _simulateAiResponse(String userMessage) {
    isLoading.value = true;

    // Scroll to show typing indicator
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    // Simulate network delay with more realistic timing
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Detect emotion based on keywords (mock implementation)
      final detectedEmotion = _detectEmotion(userMessage);

      // Add emotion update if emotion detected
      if (detectedEmotion != null) {
        messages.add(ChatMessage.emotionUpdate(detectedEmotion));
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }

      // Add AI response with slight delay for more natural feel
      Future.delayed(
        Duration(milliseconds: detectedEmotion != null ? 300 : 0),
        () {
          final response = _generateResponse(userMessage, detectedEmotion);
          messages.add(ChatMessage.ai(response, emotion: detectedEmotion));
          _scrollToBottom();

          // Occasionally add progress update
          if (messages.length % 5 == 0) {
            Future.delayed(const Duration(milliseconds: 500), () {
              messages.add(
                ChatMessage.progressUpdate(
                  'Emotion Anger Despair, Data Updated',
                ),
              );
              _scrollToBottom();
            });
          }

          isLoading.value = false;
        },
      );
    });
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

  EmotionType? _detectEmotion(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains('happy') ||
        lowerText.contains('joy') ||
        lowerText.contains('great') ||
        lowerText.contains('excited')) {
      return EmotionType.happy;
    } else if (lowerText.contains('sad') ||
        lowerText.contains('depressed') ||
        lowerText.contains('down')) {
      return EmotionType.sad;
    } else if (lowerText.contains('angry') ||
        lowerText.contains('mad') ||
        lowerText.contains('frustrated')) {
      return EmotionType.angry;
    } else if (lowerText.contains('calm') ||
        lowerText.contains('peaceful') ||
        lowerText.contains('relaxed')) {
      return EmotionType.calm;
    } else if (lowerText.contains('stress') ||
        lowerText.contains('anxious') ||
        lowerText.contains('worried') ||
        lowerText.contains('overwhelmed')) {
      return EmotionType.stress;
    }

    return null;
  }

  String _generateResponse(String userMessage, EmotionType? emotion) {
    if (emotion == EmotionType.happy) {
      return "That's wonderful to hear! I'm glad you're feeling positive. Let me help you maintain this great energy.";
    } else if (emotion == EmotionType.sad) {
      return "I understand you're going through a difficult time. Remember, it's okay to feel this way. Let's work through this together.";
    } else if (emotion == EmotionType.angry) {
      return "I hear your frustration. Let's take a moment to process these feelings and find healthy ways to cope with them.";
    } else if (emotion == EmotionType.stress) {
      return "No worries. Showing I'm here to support you. We'll work on coping strategies. You're not alone in this journey together!";
    } else {
      return "Thank you for sharing that with me. Your presence really made my therapy. How can I support you further?";
    }
  }

  void clearChat() {
    messages.clear();
  }

  void filterByDate(DateTime? date) {
    selectedDate.value = date;
    if (date != null) {
      scrollToDate(date);
    }
  }
}
