import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/errors/exceptions.dart';

/// Remote data source for profile operations on public.users table
class ProfileRemoteDataSource {
  final SupabaseClient _supabase;

  ProfileRemoteDataSource(this._supabase);

  /// Fetch user profile from public.users
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to fetch profile: ${e.toString()}');
    }
  }

  /// Update username in public.users
  /// NO email updates allowed from client
  Future<Map<String, dynamic>> updateUsername({
    required String userId,
    required String username,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .update({'username': username})
          .eq('id', userId)
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation
        throw AppException('Username already taken');
      }
      throw ServerException('Failed to update username: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update username: ${e.toString()}');
    }
  }

  /// Update display name in public.users
  Future<Map<String, dynamic>> updateDisplayName({
    required String userId,
    required String displayName,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .update({'display_name': displayName})
          .eq('id', userId)
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update display name: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update display name: ${e.toString()}');
    }
  }

  /// Update avatar URL in public.users
  Future<Map<String, dynamic>> updateAvatarUrl({
    required String userId,
    required String avatarUrl,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .update({'avatar_url': avatarUrl})
          .eq('id', userId)
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update avatar: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to update avatar: ${e.toString()}');
    }
  }

  /// Check if username is available (not taken by another user)
  Future<bool> isUsernameAvailable(
    String username, {
    String? excludeUserId,
  }) async {
    try {
      var query = _supabase.from('users').select('id').eq('username', username);

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
  Future<Map<String, dynamic>> ensureProfileExists(String userId) async {
    try {
      // First check if exists
      final existing = await getProfile(userId);
      if (existing != null) {
        return existing;
      }

      // Create profile if missing
      final response = await _supabase
          .from('users')
          .insert({'id': userId})
          .select()
          .single();
      return response;
    } on PostgrestException catch (e) {
      throw ServerException('Failed to ensure profile exists: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to ensure profile exists: ${e.toString()}');
    }
  }
}
