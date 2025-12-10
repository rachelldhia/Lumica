/// Base exception class
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server/API exceptions
class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred']);
}

/// Authentication exceptions
class AppAuthException extends AppException {
  AppAuthException([super.message = 'Authentication failed']);
}

/// Network exceptions
class NetworkException extends AppException {
  NetworkException([super.message = 'Network error']);
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException([super.message = 'Cache error']);
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException([super.message = 'Validation error']);
}

/// Not found exceptions
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Resource not found']);
}
