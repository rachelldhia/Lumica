import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';

enum SnackbarType { success, error, info, warning }

class AppSnackbar {
  static void show({
    required String message,
    SnackbarType type = SnackbarType.info,
    String? title,
    Duration duration = const Duration(seconds: 2),
  }) {
    final Color backgroundColor;
    final Color textColor;
    final IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.mossGreen;
        textColor = Colors.white;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFFF5252);
        textColor = Colors.white;
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = AppColors.vividOrange;
        textColor = Colors.white;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.darkSlateGray;
        textColor = Colors.white;
        icon = Icons.info_outline;
    }

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        title: title,
        backgroundColor: backgroundColor,
        messageText: Text(message, style: TextStyle(color: textColor)),
        duration: duration,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        borderRadius: 12.r,
        icon: Icon(icon, color: textColor, size: 24.sp),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  static void success(String message, {String? title}) {
    show(message: message, title: title, type: SnackbarType.success);
  }

  static void error(String message, {String? title}) {
    show(
      message: message,
      title: title,
      type: SnackbarType.error,
      duration: const Duration(seconds: 3),
    );
  }

  static void warning(String message, {String? title}) {
    show(message: message, title: title, type: SnackbarType.warning);
  }

  static void info(String message, {String? title}) {
    show(message: message, title: title, type: SnackbarType.info);
  }
}
