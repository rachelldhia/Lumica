import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';

class SettingsTile extends StatelessWidget {
  final String? iconAsset;
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    this.iconAsset,
    this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  }) : assert(
         iconAsset != null || icon != null,
         'Either iconAsset or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: iconAsset != null
                  ? Image.asset(
                      iconAsset!,
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon!,
                      size: 24.sp,
                      // color: AppColors.darkBrown // Use default theme icon color
                    ),
            ),
            SizedBox(width: 16.w),

            // Title
            Expanded(
              child: Text(
                title,
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  // color: AppColors.darkBrown, // Removed hardcode
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Trailing widget
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
