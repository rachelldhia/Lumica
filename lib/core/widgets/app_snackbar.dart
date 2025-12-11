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
    final IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.mossGreen;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFFF5252);
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = AppColors.vividOrange;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.darkSlateGray;
        icon = Icons.info_outline;
    }

    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            // Icon container with soft background
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  if (title != null) SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor.withValues(alpha: 0.95),
        duration: duration,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        borderRadius: 16.r,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        boxShadows: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
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
