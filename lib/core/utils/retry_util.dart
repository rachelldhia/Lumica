import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Utility class for retrying operations with exponential backoff
class RetryUtil {
  /// Check if network is available
  static Future<bool> get isNetworkAvailable async {
    try {
      return await InternetConnection().hasInternetAccess;
    } catch (e) {
      debugPrint('⚠️ Network check failed: $e');
      return false;
    }
  }

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

  /// Retry specifically for network operations with connectivity check
  static Future<T> retryNetwork<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    bool checkConnectivity = true,
  }) async {
    // Check network connectivity first if enabled
    if (checkConnectivity) {
      final hasNetwork = await isNetworkAvailable;
      if (!hasNetwork) {
        throw NetworkException('No internet connection');
      }
    }

    return retry<T>(
      operation,
      maxRetries: maxRetries,
      retryIf: (error) => _isRetryableError(error),
    );
  }

  /// Determine if an error is retryable
  static bool _isRetryableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    // Network errors - always retry
    if (errorStr.contains('socket') ||
        errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout')) {
      return true;
    }

    // Server errors (5xx) - retry
    if (errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503') ||
        errorStr.contains('504')) {
      return true;
    }

    // Rate limit - retry with longer delay
    if (errorStr.contains('429') || errorStr.contains('rate limit')) {
      return true;
    }

    // Client errors (4xx except rate limit) - don't retry
    if (errorStr.contains('400') ||
        errorStr.contains('401') ||
        errorStr.contains('403') ||
        errorStr.contains('404')) {
      return false;
    }

    return false;
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

/// Exception for network-related errors
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
