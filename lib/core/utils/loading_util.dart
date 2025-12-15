import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';

class LoadingUtil {
  static bool _isLoading = false;
  static const String _loadingDialogTag = 'APP_LOADING_DIALOG';
  static Timer? _timeoutTimer;

  /// Show modern loading dialog with blur backdrop
  static void show({String? message}) {
    // Check if already showing to prevent multiple dialogs
    if (_isLoading) return;

    // 1. Dismiss Keyboard to ensure clean state
    FocusManager.instance.primaryFocus?.unfocus();

    // Check if dialog with same tag is already open
    if (Get.isDialogOpen ?? false) {
      // If we are already showing OUR dialog, do nothing
      try {
        if (Get.currentRoute == _loadingDialogTag) return;
      } catch (_) {}
    }

    _isLoading = true;

    // Set timeout safeguard to prevent stuck loading forever
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (_isLoading) {
        debugPrint('⚠️ Loading timeout (30s) - force hiding');
        hide();
      }
    });

    Get.dialog(
      PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modern spinner - CircularProgressIndicator animates continuously by default
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.vividOrange,
                              AppColors.vividOrange.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: CircularProgressIndicator(
                            strokeWidth: 3.w,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (message != null) ...[
                        SizedBox(height: 20.h),
                        Text(
                          message,
                          style: TextStyle(
                            color: AppColors.darkBrown,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      routeSettings: const RouteSettings(name: _loadingDialogTag),
    );
  }

  /// Hide loading dialog safely
  static void hide() {
    if (!_isLoading) return;

    _isLoading = false;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    // 1. Dismiss Keyboard first (Crucial!)
    // Often Get.back() closes the keyboard instead of the dialog if focused
    FocusManager.instance.primaryFocus?.unfocus();

    // 2. Close check
    if (Get.isDialogOpen == true) {
      // Use close(1) logic? Or stick to back.
      // We'll use Get.until to be safe against stacked overlays (like multiple clicks)
      // BUT Get.until is risky if used wrong.

      // Attempt safe pop
      final currentRoute = Get.currentRoute;
      if (currentRoute == _loadingDialogTag) {
        Get.back();
      } else {
        // If we aren't on top, we might be buried (unlikely with barrier false)
        // or keyboard was handled.
        // Let's force pop once.
        Get.back();
      }

      // 3. Double Check (Rescue mechanism)
      // If after short delay, we are STILL showing the loading dialog, pop again.
      // This handles the "Keyboard ate my Pop" scenario if unfocus didn't finish fast enough.
      Future.delayed(const Duration(milliseconds: 100), () {
        if (Get.isDialogOpen == true && Get.currentRoute == _loadingDialogTag) {
          debugPrint('⚠️ LoadingUtil: Rescue pop triggered!');
          Get.back();
        }
      });
    } else {
      // If no dialog is open, we desynced.
      debugPrint(
        '⚠️ LoadingUtil.hide() called but Get.isDialogOpen is false. Dialog might have been closed by user or back button.',
      );
    }
  }

  /// Force hide - use only in emergency cases
  static void forceHide() {
    _isLoading = false;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    if (Get.isDialogOpen == true) {
      try {
        Get.back();
      } catch (e) {
        debugPrint('⚠️ Error force closing: $e');
      }
    }
  }

  /// Run async task with loading
  static Future<T> wrap<T>(Future<T> Function() task, {String? message}) async {
    try {
      show(message: message);
      return await task();
    } finally {
      hide();
    }
  }
}
