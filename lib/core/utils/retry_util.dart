import 'package:flutter/foundation.dart';

/// Utility class for retrying operations with exponential backoff
class RetryUtil {
  /// Retry an operation with exponential backoff
  ///
  /// [operation] - The async operation to retry
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// [initialDelay] - Initial delay between retries (default: 500ms)
  /// [maxDelay] - Maximum delay between retries (default: 10s)
  /// [retryIf] - Optional condition to determine if retry should occur
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
    Duration maxDelay = const Duration(seconds: 10),
    bool Function(dynamic error)? retryIf,
  }) async {
    var currentDelay = initialDelay;

    for (var attempt = 0; attempt < maxRetries; attempt++) {
      try {
        debugPrint('🔄 Attempt ${attempt + 1}/$maxRetries');
        return await operation();
      } catch (e) {
        // Check if we should retry
        if (retryIf != null && !retryIf(e)) {
          debugPrint('❌ Error not retryable: $e');
          rethrow;
        }

        // Last attempt, don't retry
        if (attempt == maxRetries - 1) {
          debugPrint('❌ Max retries ($maxRetries) exceeded');
          rethrow;
        }

        // Calculate next delay with exponential backoff
        final nextDelay = Duration(
          milliseconds: (currentDelay.inMilliseconds * 2).clamp(
            initialDelay.inMilliseconds,
            maxDelay.inMilliseconds,
          ),
        );

        debugPrint(
          '⏳ Retry ${attempt + 1} failed: $e. Waiting ${currentDelay.inMilliseconds}ms before retry...',
        );

        await Future.delayed(currentDelay);
        currentDelay = nextDelay;
      }
    }

    throw Exception('Retry failed after $maxRetries attempts');
  }

  /// Retry specifically for network operations
  static Future<T> retryNetwork<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
  }) {
    return retry<T>(
      operation,
      maxRetries: maxRetries,
      retryIf: (error) {
        // Retry on common network errors
        final errorStr = error.toString().toLowerCase();
        return errorStr.contains('socket') ||
            errorStr.contains('network') ||
            errorStr.contains('connection') ||
            errorStr.contains('timeout');
      },
    );
  }

  /// Retry with custom backoff strategy
  static Future<T> retryWithBackoff<T>(
    Future<T> Function() operation, {
    required List<Duration> delays,
    bool Function(dynamic error)? retryIf,
  }) async {
    for (var i = 0; i < delays.length; i++) {
      try {
        debugPrint('🔄 Attempt ${i + 1}/${delays.length}');
        return await operation();
      } catch (e) {
        if (retryIf != null && !retryIf(e)) {
          debugPrint('❌ Error not retryable: $e');
          rethrow;
        }

        if (i == delays.length - 1) {
          debugPrint('❌ Max retries (${delays.length}) exceeded');
          rethrow;
        }

        debugPrint(
          '⏳ Retry ${i + 1} failed: $e. Waiting ${delays[i].inMilliseconds}ms...',
        );
        await Future.delayed(delays[i]);
      }
    }

    throw Exception('Retry failed after ${delays.length} attempts');
  }
}
