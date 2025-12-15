import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Service to manage chat history operations
/// Simplified to only handle scroll and date operations
/// Messages are managed by the controller
class ChatHistoryManager {
  final ScrollController scrollController = ScrollController();

  /// Scroll to bottom of chat - optimized to prevent bounce
  void scrollToBottom({bool animate = true}) {
    if (!scrollController.hasClients) return;

    // Use post-frame callback to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final maxExtent = scrollController.position.maxScrollExtent;

      if (animate) {
        scrollController.animateTo(
          maxExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(maxExtent);
      }
    });
  }

  /// Scroll to specific position
  void scrollToDate(List messages, DateTime date) {
    final index = messages.indexWhere((msg) {
      final msgDate = msg.timestamp as DateTime;
      return msgDate.year == date.year &&
          msgDate.month == date.month &&
          msgDate.day == date.day;
    });

    if (index != -1 && scrollController.hasClients) {
      final itemHeight = 120.0;
      scrollController.animateTo(
        index * itemHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Get list of unique dates
  List<DateTime> getAvailableDates(List messages) {
    final dates = <DateTime>{};
    for (var msg in messages) {
      final timestamp = msg.timestamp as DateTime;
      dates.add(DateTime(timestamp.year, timestamp.month, timestamp.day));
    }
    return dates.toList()..sort((a, b) => b.compareTo(a));
  }

  /// Format date for display
  String formatDateDivider(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  /// Check if date divider should be shown
  bool shouldShowDateDivider(List messages, int index) {
    if (index == 0) return true;

    final current = messages[index].timestamp as DateTime;
    final previous = messages[index - 1].timestamp as DateTime;

    return current.year != previous.year ||
        current.month != previous.month ||
        current.day != previous.day;
  }

  void dispose() {
    scrollController.dispose();
  }
}
