import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';
import 'package:lumica_app/domain/repositories/auth_repository.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  AuthController(this._authRepository, this._profileRepository);

  // Sign In controllers
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInEmailError = ''.obs;
  final signInPasswordError = ''.obs;
  final signInPasswordVisible = false.obs;

  // Real-time validation state
  final isSignInFormValid = false.obs;

  // Sign Up controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final nameError = ''.obs;
  final signUpPasswordVisible = false.obs;

  // UI state for Sign Up
  final agreeToTerms = false.obs;

  // Loading and error states
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Current user with profile
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // Validate on text change
    signInEmailController.addListener(_validateSignIn);
    signInPasswordController.addListener(_validateSignIn);
  }

  void _validateSignIn() {
    isSignInFormValid.value =
        GetUtils.isEmail(signInEmailController.text) &&
        signInPasswordController.text.length >= 6;
  }

  /// Sign up with email and password
  Future<void> signUp() async {
    if (isLoading.value) return;

    isLoading.value = true;
    LoadingUtil.show(message: 'Creating account...');
    errorMessage.value = '';

    try {
      final result = await _authRepository.signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : null,
      );

      await result.fold(
        (failure) async {
          LoadingUtil.hide(); // Hide first on error
          errorMessage.value = failure.message;
          debugPrint('Sign up failed: ${failure.message}');
          AppSnackbar.error(failure.message, title: 'Sign Up Failed');
        },
        (authUser) async {
          debugPrint('Sign up successful: ${authUser.id}');

          // Try to fetch profile (graceful fallback if table doesn't exist)
          await _fetchAndMergeProfile(authUser.id, isNewUser: true);

          _clearSignUpFields();

          LoadingUtil.hide(); // Hide BEFORE Nav

          AppSnackbar.success(
            'Your account has been created successfully!',
            title: 'Welcome!',
          );

          // Navigate to dashboard (profile check optional for now)
          Get.offAllNamed(AppRoutes.dashboard);
        },
      );
    } catch (e) {
      LoadingUtil.hide();
      debugPrint('Sign up error: $e');
      AppSnackbar.error(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
      // Do NOT call LoadingUtil.hide() here blindly, as we might have already navigated
    }
  }

  /// Sign in with email and password
  Future<void> signIn() async {
    if (isLoading.value) return;

    isLoading.value = true;
    LoadingUtil.show(message: 'Signing in...');
    errorMessage.value = '';

    try {
      final result = await _authRepository.signInWithEmail(
        email: signInEmailController.text.trim(),
        password: signInPasswordController.text,
      );

      await result.fold(
        (failure) async {
          LoadingUtil.hide(); // Hide on error
          errorMessage.value = failure.message;
          debugPrint('Sign in failed: ${failure.message}');
          AppSnackbar.error(failure.message, title: 'Sign In Failed');
        },
        (authUser) async {
          debugPrint('Sign in successful: ${authUser.id}');

          // Try to fetch profile (graceful fallback)
          await _fetchAndMergeProfile(authUser.id);

          _clearSignInFields();

          LoadingUtil.hide(); // Hide BEFORE Nav

          AppSnackbar.success('Welcome back!', title: 'Success');

          // Navigate to dashboard
          Get.offAllNamed(AppRoutes.dashboard);
        },
      );
    } catch (e) {
      LoadingUtil.hide();
      debugPrint('Sign in error: $e');
      AppSnackbar.error(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
      // No blind hide
    }
  }

  /// Fetch profile and merge with auth user data
  /// Gracefully handles missing profile table
  Future<void> _fetchAndMergeProfile(
    String userId, {
    bool isNewUser = false,
  }) async {
    try {
      final profileResult = await _profileRepository.getProfile(userId);

      profileResult.fold(
        (failure) {
          debugPrint('Profile fetch failed: ${failure.message}');
          debugPrint('⚠️  This is OK if public.users table doesn\'t exist yet');
          debugPrint('   Run the SQL migration to enable profile features');

          // Use basic auth user without profile for now
          final authUser = Supabase.instance.client.auth.currentUser;
          if (authUser != null) {
            currentUser.value = UserModel.fromSupabaseAuth(authUser);
            debugPrint('Using auth-only user (no profile data)');
          }
        },
        (completeUser) {
          currentUser.value = completeUser;
          debugPrint('Profile loaded: username=${completeUser.username}');

          // Only redirect to complete profile if username is truly required
          // For now, skip this check to allow app to work without migration
          // if (completeUser.username == null || completeUser.username?.isEmpty == true) {
          //   Get.offAllNamed(AppRoutes.completeProfile);
          // }
        },
      );
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      debugPrint('Continuing without profile data...');

      // Fallback: use basic auth user
      final authUser = Supabase.instance.client.auth.currentUser;
      if (authUser != null) {
        currentUser.value = UserModel.fromSupabaseAuth(authUser);
      }
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (isLoading.value) return;

    isLoading.value = true;
    LoadingUtil.show(message: 'Signing out...');

    try {
      final result = await _authRepository.signOut();

      result.fold(
        (failure) {
          LoadingUtil.hide();
          AppSnackbar.error(failure.message, title: 'Sign Out Failed');
        },
        (_) {
          LoadingUtil.hide(); // Hide before nav

          currentUser.value = null;
          AppSnackbar.success('You have been logged out');
          Get.offAllNamed(AppRoutes.signin);
        },
      );
    } catch (e) {
      LoadingUtil.hide();
      debugPrint('Sign out error: $e');
      AppSnackbar.error('Failed to sign out');
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot password - send reset email
  Future<void> forgotPassword() async {
    final email = signInEmailController.text.trim();

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.warning(
        'Please enter a valid email address first.',
        title: 'Invalid Email',
      );
      return;
    }

    isLoading.value = true;
    LoadingUtil.show(message: 'Sending email...');

    try {
      final result = await _authRepository.resetPassword(email);

      result.fold(
        (failure) {
          AppSnackbar.error(failure.message, title: 'Reset Failed');
        },
        (_) {
          AppSnackbar.success(
            'Check your email for password reset instructions.',
            title: 'Email Sent',
          );
        },
      );
    } catch (e) {
      debugPrint('Password reset error: $e');
      AppSnackbar.error('Failed to send reset email');
    } finally {
      isLoading.value = false;
      LoadingUtil.hide(); // Safe to use here as no navigation happens
    }
  }

  /// Sign in with Facebook OAuth
  Future<void> signInWithFacebook() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.lumica://login-callback/',
      );
    } catch (e) {
      debugPrint('Facebook login error: $e');
      AppSnackbar.error(
        'Failed to connect with Facebook. Please try again.',
        title: 'Facebook Login Failed',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with Google OAuth
  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.lumica://login-callback/',
      );
    } catch (e) {
      debugPrint('Google login error: $e');
      AppSnackbar.error(
        'Failed to connect with Google. Please try again.',
        title: 'Google Login Failed',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is already authenticated
  bool get isAuthenticated => _authRepository.isAuthenticated();

  /// Load current user data (used on app startup)
  Future<void> loadCurrentUser() async {
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser != null) {
      await _fetchAndMergeProfile(authUser.id);
    }
  }

  void _clearSignInFields() {
    signInEmailController.clear();
    signInPasswordController.clear();
    signInEmailError.value = '';
    signInPasswordError.value = '';
  }

  void _clearSignUpFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    agreeToTerms.value = false;
  }
}
