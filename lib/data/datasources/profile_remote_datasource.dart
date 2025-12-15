import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';

/// Remote data source for profile operations on public.profiles table
class ProfileRemoteDataSource {
  final SupabaseClient _supabase;

  ProfileRemoteDataSource(this._supabase);

  /// Fetch user profile from public.profiles
  Future<UserModel?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch profile: ${e.toString()}');
    }
  }

  /// Update username in public.profiles
  Future<UserModel> updateUsername({
    required String userId,
    required String username,
  }) async {
    try {
      debugPrint('📝 Updating username for user: $userId to: $username');
      final response = await _supabase
          .from('profiles')
          .update({
            'username': username,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();
      debugPrint('✅ Username updated successfully');
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      debugPrint('❌ PostgrestException in updateUsername: ${e.message}');
      debugPrint('Error code: ${e.code}');

      // Handle missing profile row (PGRST116: The result contains 0 rows)
      if (e.code == 'PGRST116') {
        debugPrint(
          '⚠️ Profile missing. Attempting to create profile for $userId...',
        );
        try {
          // Auto-create profile
          await _supabase.from('profiles').insert({
            'id': userId,
            'updated_at': DateTime.now().toIso8601String(),
          });

          debugPrint('✅ Profile created. Retrying username update...');

          // Retry update
          final retryResponse = await _supabase
              .from('profiles')
              .update({
                'username': username,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', userId)
              .select()
              .single();

          return UserModel.fromJson(retryResponse);
        } catch (createError) {
          debugPrint('❌ Failed to auto-create profile: $createError');
          throw ServerException('Failed to create profile: $createError');
        }
      }

      if (e.code == '23505') {
        throw AppException('Username already taken');
      }
      throw ServerException('Failed to update username: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error in updateUsername: $e');
      throw ServerException('Failed to update username: ${e.toString()}');
    }
  }

  /// Update display name in public.profiles
  Future<UserModel> updateDisplayName({
    required String userId,
    required String displayName,
  }) async {
    try {
      final response = await _supabase
          .from('profiles')
          .update({
            'display_name': displayName,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update display name: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update display name: ${e.toString()}');
    }
  }

  /// Update avatar URL in public.profiles
  Future<UserModel> updateAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    try {
      final response = await _supabase
          .from('profiles')
          .update({
            'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update avatar: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update avatar: ${e.toString()}');
    }
  }

  /// Upload avatar file to storage bucket and return Public URL
  Future<String> uploadAvatar(String userId, dynamic file) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName; // Root of bucket

      await _supabase.storage
          .from('avatars')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);
      return imageUrl;
    } on StorageException catch (e) {
      throw ServerException('Failed to upload avatar: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to upload avatar: $e');
    }
  }

  /// Check if username is available (not taken by another user)
  Future<bool> isUsernameAvailable(
    String username, {
    String? excludeUserId,
  }) async {
    try {
      var query = _supabase
          .from('profiles')
          .select('id')
          .eq('username', username);

      // Exclude current user when checking (for profile edits)
      if (excludeUserId != null) {
        query = query.neq('id', excludeUserId);
      }

      final response = await query.maybeSingle();
      return response == null;
    } on PostgrestException catch (e) {
      throw ServerException(
        'Failed to check username availability: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        'Failed to check username availability: ${e.toString()}',
      );
    }
  }

  /// Ensure profile exists - create if missing (for edge cases where trigger failed)
  Future<UserModel> ensureProfileExists(String userId) async {
    try {
      // First check if exists
      final existing = await getProfile(userId);
      if (existing != null) {
        return existing;
      }

      // Create profile if missing
      final response = await _supabase
          .from('profiles')
          .insert({
            'id': userId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to ensure profile exists: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to ensure profile exists: ${e.toString()}');
    }
  }

  /// Update location in public.profiles
  Future<UserModel> updateLocation({
    required String userId,
    required String location,
  }) async {
    try {
      final response = await _supabase
          .from('profiles')
          .update({
            'location': location,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update location: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update location: ${e.toString()}');
    }
  }
}
