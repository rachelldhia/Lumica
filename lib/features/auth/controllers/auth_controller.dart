import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AuthController extends GetxController {
  // Sign In controllers
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInEmailError = ''.obs;
  final signInPasswordError = ''.obs;
  final signInPasswordVisible = false.obs;

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

  // Method to manually clean up when completely exiting auth flow
  @override
  void onClose() {
    // Don't dispose controllers here - they may still be used during navigation animations
    // GetX will handle cleanup when controller is truly no longer needed
    super.onClose();
  }

  void signUp() {
    // Perform sign up logic
    // Called after form validation passes in the SignUpPage
    // For example, calling an auth repository or API
    // Get.offAllNamed('/home');
  }

  void signIn() {
    // Perform sign in logic
    // Called after form validation passes in the SignInPage
    Get.offAllNamed(AppRoutes.dashboard);
  }

  void forgotPassword() {
    // Implement forgot password functionality
    // For now, just show a snackbar
    Get.snackbar(
      'Forgot Password',
      'This feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signInWithFacebook() {
    // TODO: Implement Facebook OAuth
    Get.snackbar(
      'Facebook Login',
      'Facebook login will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signInWithGoogle() {
    // TODO: Implement Google OAuth
    Get.snackbar(
      'Google Login',
      'Google login will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signInWithInstagram() {
    // TODO: Implement Instagram OAuth
    Get.snackbar(
      'Instagram Login',
      'Instagram login will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
