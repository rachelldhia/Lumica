/// Cancellation token for async operations
///
/// Use to cancel long-running operations when user navigates away
/// or when the operation is no longer needed.
///
/// Example:
/// ```dart
/// final token = CancellationToken();
///
/// // In async operation
/// await someAsyncWork();
/// token.throwIfCancelled();  // Throws if cancelled
/// await moreWork();
///
/// // In controller onClose
/// token.cancel();
/// ```
class CancellationToken {
  bool _isCancelled = false;

  /// Check if cancellation has been requested
  bool get isCancelled => _isCancelled;

  /// Request cancellation
  void cancel() {
    _isCancelled = true;
  }

  /// Throw exception if cancelled
  /// Call this between async operations to exit early
  void throwIfCancelled() {
    if (_isCancelled) {
      throw CancelledException();
    }
  }

  /// Run operation only if not cancelled
  Future<T?> runIfNotCancelled<T>(Future<T> Function() operation) async {
    if (_isCancelled) return null;
    return await operation();
  }
}

/// Exception thrown when an operation is cancelled
class CancelledException implements Exception {
  final String message;

  CancelledException([this.message = 'Operation was cancelled']);

  @override
  String toString() => 'CancelledException: $message';
}
