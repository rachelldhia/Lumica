import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/routes/app_routes.dart';

class SplashController extends GetxController {
  // Loading state for UI
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Start checking auth after a brief delay
    _checkAuthAndRedirect();
  }

  /// Check if user has an active Supabase session
  Future<void> _checkAuthAndRedirect() async {
    // Wait 2 seconds for splash animation
    await Future.delayed(const Duration(seconds: 2));

    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // User is logged in, go to dashboard
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        // User is not logged in, go to onboarding
        Get.offAllNamed(AppRoutes.onboarding);
      }
    } catch (e) {
      // If there's any error, go to onboarding
      debugPrint('Splash auth check error: $e');
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
