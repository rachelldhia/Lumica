import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class EditTextField extends StatelessWidget {
  final String? iconAsset;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onEditTap;
  final VoidCallback? onVisibilityToggle;
  final bool? isPasswordVisible;

  const EditTextField({
    super.key,
    this.iconAsset,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.onEditTap,
    this.onVisibilityToggle,
    this.isPasswordVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkSlateGray.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Leading icon
          if (iconAsset != null)
            Image.asset(
              iconAsset!,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
            ),

          SizedBox(width: 12.w),

          // Text field
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText && !(isPasswordVisible ?? false),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.darkBrown,
              ),
            ),
          ),

          // Password visibility toggle (if password field)
          if (obscureText && onVisibilityToggle != null) ...[
            GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(
                isPasswordVisible ?? false
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.greyText,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],

          // Edit icon
          if (onEditTap != null)
            GestureDetector(
              onTap: onEditTap,
              child: Image.asset(
                'assets/icons/edit.png',
                width: 20.w,
                height: 20.h,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}
