import 'package:either_dart/either.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/core/errors/failures.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/data/models/user_model.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of ProfileRepository using Supabase
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final SupabaseClient _supabase;

  ProfileRepositoryImpl(this._remoteDataSource, this._supabase);

  @override
  Future<Either<Failure, UserModel>> getProfile(String userId) async {
    try {
      final profileData = await _remoteDataSource.getProfile(userId);

      if (profileData == null) {
        return const Left(NotFoundFailure('Profile not found'));
      }

      // Get email from auth.users
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure('Not authenticated'));
      }

      // Merge profile with auth data
      final authUserModel = UserModel.fromSupabaseAuth(authUser);
      final completeUser = authUserModel.mergeWithProfile(profileData);

      return Right(completeUser);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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

      // Get email from auth.users
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure('Not authenticated'));
      }

      final authUserModel = UserModel.fromSupabaseAuth(authUser);
      final updatedUser = authUserModel.mergeWithProfile(profileData);

      return Right(updatedUser);
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

      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure('Not authenticated'));
      }

      final authUserModel = UserModel.fromSupabaseAuth(authUser);
      final updatedUser = authUserModel.mergeWithProfile(profileData);

      return Right(updatedUser);
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

      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure('Not authenticated'));
      }

      final authUserModel = UserModel.fromSupabaseAuth(authUser);
      final updatedUser = authUserModel.mergeWithProfile(profileData);

      return Right(updatedUser);
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

      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return const Left(AuthFailure('Not authenticated'));
      }

      final authUserModel = UserModel.fromSupabaseAuth(authUser);
      final user = authUserModel.mergeWithProfile(profileData);

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
