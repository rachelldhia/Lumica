/// Performance optimization utilities and best practices
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance utilities for Flutter apps
class PerformanceUtils {
  /// Check if running in release mode
  static bool get isRelease => kReleaseMode;

  /// Check if running in debug mode
  static bool get isDebug => kDebugMode;

  /// Debounce function calls to prevent excessive operations
  /// Useful for search inputs, API calls, etc.
  static void debounce(Duration duration, VoidCallback action, {String? tag}) {
    final key = tag ?? 'default_debounce';

    // Cancel previous debounce timer with same tag
    _debounceTimers[key]?.cancel();

    // Create new debounce timer
    _debounceTimers[key] = Timer(duration, () {
      action();
      _debounceTimers.remove(key);
    });
  }

  static final Map<String, Timer> _debounceTimers = {};

  /// Throttle function calls to limit execution rate
  /// Executes immediately, then blocks for duration
  static void throttle(Duration duration, VoidCallback action, {String? tag}) {
    final key = tag ?? 'default_throttle';
    final now = DateTime.now();

    // Check if we're still in throttle period
    if (_throttleTimestamps.containsKey(key)) {
      final lastExecution = _throttleTimestamps[key]!;
      if (now.difference(lastExecution) < duration) {
        return; // Still throttled
      }
    }

    // Execute and update timestamp
    action();
    _throttleTimestamps[key] = now;

    // Clean up old timestamps after duration
    Timer(duration, () {
      _throttleTimestamps.remove(key);
    });
  }

  static final Map<String, DateTime> _throttleTimestamps = {};

  /// Log performance metrics in debug mode only
  static void logPerformance(String message) {
    if (kDebugMode) {
      debugPrint('⚡ Performance: $message');
    }
  }
}

/// Best practices constants
class BestPractices {
  // Prevent instantiation
  BestPractices._();

  /// Recommended debounce duration for search inputs
  static const searchDebounce = Duration(milliseconds: 500);

  /// Recommended throttle duration for scroll events
  static const scrollThrottle = Duration(milliseconds: 100);

  /// Recommended throttle duration for API calls
  static const apiThrottle = Duration(seconds: 1);

  /// Max items to render in a list before using pagination
  static const maxListItems = 50;

  /// Recommended image cache size
  static const imageCacheSize = 100;
}

/// Performance tips and guidelines (for documentation)
abstract class PerformanceTips {
  /// Widget optimization tips
  static const widgetTips = '''
  1. Use 'const' constructors wherever possible
  2. Avoid rebuilding large widget trees - use Obx() on specific widgets
  3. Use ListView.builder() for long lists
  4. Implement AutomaticKeepAliveClientMixin for expensive widgets in PageView
  5. Use RepaintBoundary for complex animations
  ''';

  /// State management tips
  static const stateTips = '''
  1. Use Get.lazyPut() instead of Get.put() for better memory management
  2. Dispose controllers properly with Get.delete() when done
  3. Use .obs only for data that actually changes
  4. Avoid nested Obx() widgets
  5. Use Worker for reactive programming sparingly
  ''';

  /// Network optimization tips
  static const networkTips = '''
  1. Implement caching for frequently accessed data
  2. Use pagination for large datasets
  3. Debounce search queries to reduce API calls
  4. Implement retry logic with exponential backoff
  5. Cache images with CachedNetworkImage
  ''';
}
