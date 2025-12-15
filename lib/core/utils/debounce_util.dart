import 'dart:async';

/// Debounce utility for rate-limiting function calls
///
/// Use for search input, button presses, and other rapid-fire events.
///
/// Example:
/// ```dart
/// final _searchDebounce = Debouncer(delay: Duration(milliseconds: 300));
///
/// void onSearchChanged(String query) {
///   _searchDebounce.run(() {
///     // This only runs 300ms after the last call
///     performSearch(query);
///   });
/// }
/// ```
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Run action after delay, cancelling any pending action
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Run async action after delay
  void runAsync(Future<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, () => action());
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Throttle utility for limiting function calls to max once per interval
///
/// Unlike debounce, throttle ensures the first call executes immediately,
/// then ignores subsequent calls until the interval passes.
///
/// Example:
/// ```dart
/// final _buttonThrottle = Throttler(interval: Duration(seconds: 1));
///
/// void onButtonPressed() {
///   _buttonThrottle.run(() {
///     // Runs immediately, then ignored for 1 second
///     submitForm();
///   });
/// }
/// ```
class Throttler {
  final Duration interval;
  DateTime? _lastExecuted;

  Throttler({this.interval = const Duration(seconds: 1)});

  /// Run action if interval has passed since last execution
  void run(void Function() action) {
    final now = DateTime.now();
    if (_lastExecuted == null || now.difference(_lastExecuted!) >= interval) {
      _lastExecuted = now;
      action();
    }
  }

  /// Run async action if interval has passed
  Future<void> runAsync(Future<void> Function() action) async {
    final now = DateTime.now();
    if (_lastExecuted == null || now.difference(_lastExecuted!) >= interval) {
      _lastExecuted = now;
      await action();
    }
  }

  /// Reset throttle state
  void reset() {
    _lastExecuted = null;
  }
}
