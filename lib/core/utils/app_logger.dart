import 'package:flutter/foundation.dart';

/// Debug logging utility with kDebugMode guard
/// Only prints in debug mode, completely stripped in release builds
class AppLogger {
  static const String _tag = '🔷 Lumica';

  /// Log a debug message (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [DEBUG] $message');
    }
  }

  /// Log an info message
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [INFO] ℹ️ $message');
    }
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [WARN] ⚠️ $message');
    }
  }

  /// Log an error message with optional stack trace
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [ERROR] ❌ $message');
      if (error != null) {
        debugPrint('${tag ?? _tag} [ERROR] Exception: $error');
      }
      if (stackTrace != null) {
        debugPrint('${tag ?? _tag} [ERROR] Stack trace:\n$stackTrace');
      }
    }
  }

  /// Log a success message
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [SUCCESS] ✅ $message');
    }
  }

  /// Log network request/response
  static void network(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [NETWORK] 📡 $message');
    }
  }

  /// Log navigation events
  static void navigation(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [NAV] 🧭 $message');
    }
  }

  /// Log user actions
  static void action(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('${tag ?? _tag} [ACTION] 👆 $message');
    }
  }

  /// Log performance metrics
  static void performance(String message, {Duration? duration, String? tag}) {
    if (kDebugMode) {
      final durationStr = duration != null
          ? ' (${duration.inMilliseconds}ms)'
          : '';
      debugPrint('${tag ?? _tag} [PERF] ⏱️ $message$durationStr');
    }
  }
}
