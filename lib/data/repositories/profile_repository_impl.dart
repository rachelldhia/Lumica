import 'package:flutter/foundation.dart';
import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/data/datasources/profile_local_datasource.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of ProfileRepository using Supabase
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final SupabaseClient _supabase;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._supabase,
  );

  @override
  Future<Either<Failure, UserModel>> getProfile(String userId) async {
    try {
      // 1. Try fetching from remote
      final profileData = await _remoteDataSource.getProfile(userId);

      if (profileData != null) {
        // 2. Cache it
        await _localDataSource.cacheProfile(profileData);

        return _mergeWithAuth(profileData);
      } else {
        return const Left(NotFoundFailure('Profile not found'));
      }
    } on Exception catch (e) {
      // 3. Fallback to local cache on error (offline support)
      final cachedProfile = _localDataSource.getLastProfile();
      if (cachedProfile != null && cachedProfile.id == userId) {
        debugPrint('⚠️ Returning cached profile due to error: $e');
        return _mergeWithAuth(cachedProfile);
      }

      if (e is AppException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  Either<Failure, UserModel> _mergeWithAuth(UserModel profileData) {
    // Get email from auth.users
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) {
      return const Left(AuthFailure('Not authenticated'));
    }

    // Merge profile with auth data
    final authUserModel = UserModel.fromSupabaseAuth(authUser);
    final completeUser = authUserModel.mergeWithProfile(profileData);

    return Right(completeUser);
  }

  @override
  Future<Either<Failure, UserModel>> updateUsername(
    String userId,
    String username,
  ) async {
    try {
      final profileData = await _remoteDataSource.updateUsername(
        userId: userId,
        username: username,
      );

      // Cache updated profile
      await _localDataSource.cacheProfile(profileData);

      return _mergeWithAuth(profileData);
    } on AppException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateDisplayName(
    String userId,
    String displayName,
  ) async {
    try {
      final profileData = await _remoteDataSource.updateDisplayName(
        userId: userId,
        displayName: displayName,
      );

      // Cache updated profile
      await _localDataSource.cacheProfile(profileData);

      return _mergeWithAuth(profileData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateAvatarUrl(
    String userId,
    String avatarUrl,
  ) async {
    try {
      final profileData = await _remoteDataSource.updateAvatarUrl(
        userId: userId,
        avatarUrl: avatarUrl,
      );

      // Cache updated profile
      await _localDataSource.cacheProfile(profileData);

      return _mergeWithAuth(profileData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameAvailable(
    String username, {
    String? excludeUserId,
  }) async {
    try {
      final isAvailable = await _remoteDataSource.isUsernameAvailable(
        username,
        excludeUserId: excludeUserId,
      );
      return Right(isAvailable);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> ensureProfileExists(String userId) async {
    try {
      final profileData = await _remoteDataSource.ensureProfileExists(userId);

      await _localDataSource.cacheProfile(profileData);

      return _mergeWithAuth(profileData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar(
    String userId,
    dynamic file,
  ) async {
    try {
      final avatarUrl = await _remoteDataSource.uploadAvatar(userId, file);
      // Note: This only returns URL, does not return Profile, so we don't cache here.
      // The updateAvatarUrl call usually follows this.
      return Right(avatarUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
