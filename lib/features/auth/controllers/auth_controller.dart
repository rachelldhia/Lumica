import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Controllers for sign up
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailError = ''.obs;
  final passwordError = ''.obs;

  // UI state
  final isPasswordVisible = false.obs;
  final agreeToTerms = false.obs;

  // Controllers for sign in (can be added later)
  // final signInEmailController = TextEditingController();
  // final signInPasswordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      // Form is valid, proceed with sign up logic
      // For example, calling an auth repository or API

      // You would typically navigate to the home screen or a verification page here
      // Get.offAllNamed('/home');
    }
  }

  // A sign in method can be added here as well
  // void signIn() { ... }
}
