import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AuthController extends GetxController {
  // Form keys - separated for each page
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

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

  @override
  void onClose() {
    // Dispose Sign In controllers
    signInEmailController.dispose();
    signInPasswordController.dispose();

    // Dispose Sign Up controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  void signUp() {
    if (signUpFormKey.currentState!.validate()) {
      // Form is valid, proceed with sign up logic
      // For example, calling an auth repository or API

      // You would typically navigate to the home screen or a verification page here
      // Get.offAllNamed('/home');
    }
  }

  void signIn() {
    if (signInFormKey.currentState!.validate()) {
      Get.offAllNamed(AppRoutes.home);
    }
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
