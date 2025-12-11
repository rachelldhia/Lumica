import 'package:lumica_app/core/errors/exceptions.dart';
import 'package:lumica_app/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth remote data source (Supabase)
class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase);

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw AppAuthException('Sign in failed');
      }

      return UserModel.fromSupabaseAuth(response.user!);
    } on AppAuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AppAuthException('Sign in failed: ${e.message}');
    } catch (e) {
      throw AppAuthException('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user == null) {
        throw AppAuthException('Sign up failed');
      }

      // Check if session is missing (indicates email confirmation is required)
      if (response.session == null) {
        throw AppAuthException(
          'Please check your email to verify your account before logging in.',
        );
      }

      return UserModel.fromSupabaseAuth(response.user!);
    } on AppAuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AppAuthException('Sign up failed: ${e.message}');
    } catch (e) {
      throw AppAuthException('Sign up failed: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on AuthApiException catch (e) {
      throw AppAuthException('Sign out failed: ${e.message}');
    } catch (e) {
      throw AppAuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseAuth(user);
    } catch (e) {
      throw AppAuthException('Failed to get current user: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      throw AppAuthException('Password reset failed: ${e.message}');
    } catch (e) {
      throw AppAuthException('Password reset failed: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(data: name != null ? {'name': name} : null),
      );

      if (response.user == null) {
        throw AppAuthException('Profile update failed');
      }

      return UserModel.fromSupabaseAuth(response.user!);
    } on AppAuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AppAuthException('Profile update failed: ${e.message}');
    } catch (e) {
      throw AppAuthException('Profile update failed: ${e.toString()}');
    }
  }

  /// Check if authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }
}
