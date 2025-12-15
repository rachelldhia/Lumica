import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

/// Utility class for standardized dialog displays
class DialogUtil {
  /// Show a confirmation dialog with customizable options
  /// Returns `true` if confirmed, `false` or `null` if cancelled
  static Future<bool?> showConfirmation({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    return Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          title,
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        content: Text(
          message,
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText ?? 'common.cancel'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.darkSlateGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText ?? 'common.confirm'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: isDangerous
                    ? Colors.red
                    : (confirmColor ?? AppColors.vividOrange),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show a delete confirmation dialog
  static Future<bool?> showDeleteConfirmation({
    required String itemName,
    String? title,
    String? message,
  }) async {
    return showConfirmation(
      title: title ?? 'common.delete'.tr,
      message:
          message ??
          'Are you sure you want to delete "$itemName"? This action cannot be undone.',
      confirmText: 'common.delete'.tr,
      isDangerous: true,
    );
  }

  /// Show a logout confirmation dialog
  static Future<bool?> showLogoutConfirmation() async {
    return showConfirmation(
      title: 'profile.logOut'.tr,
      message: 'profile.logOutConfirm'.tr,
      confirmText: 'profile.logOut'.tr,
      isDangerous: true,
    );
  }

  /// Show an info dialog (single button)
  static Future<void> showInfo({
    required String title,
    required String message,
    String? buttonText,
  }) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          title,
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        content: Text(
          message,
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              buttonText ?? 'common.ok'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.vividOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show an input dialog
  static Future<String?> showInput({
    required String title,
    String? hintText,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await Get.dialog<String>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          title,
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text(
              cancelText ?? 'common.cancel'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.darkSlateGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: controller.text),
            child: Text(
              confirmText ?? 'common.confirm'.tr,
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.vividOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }
}
