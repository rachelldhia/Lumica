import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserModel>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// Reset password
  Future<Either<Failure, void>> resetPassword(String email);

  /// Update user profile
  Future<Either<Failure, UserModel>> updateProfile({
    required String userId,
    String? name,
  });

  /// Check if user is authenticated
  bool isAuthenticated();
}
