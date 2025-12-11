import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';

/// Profile repository interface for managing user profile data
abstract class ProfileRepository {
  /// Get user profile from public.users
  Future<Either<Failure, UserModel>> getProfile(String userId);

  /// Update username (NO email update allowed)
  Future<Either<Failure, UserModel>> updateUsername(
    String userId,
    String username,
  );

  /// Update display name
  Future<Either<Failure, UserModel>> updateDisplayName(
    String userId,
    String displayName,
  );

  /// Update avatar URL
  Future<Either<Failure, UserModel>> updateAvatarUrl(
    String userId,
    String avatarUrl,
  );

  /// Upload avatar file and get URL
  Future<Either<Failure, String>> uploadAvatar(String userId, dynamic file);

  /// Check if username is available
  Future<Either<Failure, bool>> isUsernameAvailable(
    String username, {
    String? excludeUserId,
  });

  /// Ensure profile exists (create if missing)
  Future<Either<Failure, UserModel>> ensureProfileExists(String userId);
}
