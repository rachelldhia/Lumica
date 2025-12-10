import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Server-related failures (Supabase, API, etc.)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Network/connection failures
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Network error. Please check your connection',
  ]);
}

/// Local cache/storage failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Validation failures (form, input, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Permission/authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}
