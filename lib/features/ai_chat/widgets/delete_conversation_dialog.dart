import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/constants/app_images.dart';

class DeleteConversationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConversationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trash illustration
            Image.asset(
              AppImages.imageTrash,
              height: 180.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              'Delete This\nConversation?',
              textAlign: TextAlign.center,
              style: AppTextTheme.textTheme.headlineSmall?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                height: 1.2,
              ),
            ),
            SizedBox(height: 12.h),

            // Description
            Text(
              'Don\'t worry. You can still restore the\nconversation within 30 days',
              textAlign: TextAlign.center,
              style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkSlateGray,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),

            // Cancel button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: Image.asset(
                  AppIcon.cancle,
                  width: 18.w,
                  height: 18.h,
                  color: AppColors.vividOrange,
                ),
                label: Text(
                  'Cancel',
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: AppColors.vividOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.paleSalmon.withValues(alpha: 0.3),
                  side: BorderSide(
                    color: AppColors.vividOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Delete button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  onConfirm();
                },
                icon: Image.asset(
                  AppIcon.trash,
                  width: 18.w,
                  height: 18.h,
                  color: AppColors.whiteColor,
                ),
                label: Text(
                  'Delete Conversation',
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vividOrange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
