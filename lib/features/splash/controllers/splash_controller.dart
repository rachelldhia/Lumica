import 'dart:async';
import 'package:get/get.dart';
import 'package:lumica_app/routes/app_routes.dart';
import 'package:lumica_app/storage/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startRedirectTimer();
  }

  void _startRedirectTimer() {
    Timer(const Duration(seconds: 2), () {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });
  }
}
