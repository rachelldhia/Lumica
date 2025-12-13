/// A lightweight Result type for clean error handling
/// Use this instead of throwing exceptions for expected error cases
sealed class Result<T> {
  const Result();

  /// Execute a callback based on success or failure
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Exception? exception) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(message: final msg, exception: final e) => failure(msg, e),
    };
  }

  /// Map the success value to a new type
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(data: final data) => Success(transform(data)),
      Failure<T>(message: final msg, exception: final e) => Failure(msg, e),
    };
  }

  /// Flat map for chaining Result operations
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      Success<T>(data: final data) => transform(data),
      Failure<T>(message: final msg, exception: final e) => Failure(msg, e),
    };
  }
}

/// Represents a successful result with data
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed result with error information
class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}

/// Extension methods for easier Result handling
extension ResultExtension<T> on Result<T> {
  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Failure<T>;

  /// Returns the data if Success, null otherwise
  T? get dataOrNull => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };

  /// Returns the error message if Failure, null otherwise
  String? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(message: final msg) => msg,
  };

  /// Returns the data if Success, or the provided default value
  T getOrElse(T defaultValue) => dataOrNull ?? defaultValue;

  /// Returns the data if Success, or throws the exception
  T getOrThrow() {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>(message: final msg, exception: final e) =>
        throw e ?? Exception(msg),
    };
  }
}
