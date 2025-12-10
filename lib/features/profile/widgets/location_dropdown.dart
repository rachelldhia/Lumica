import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';

class LocationSelector extends StatelessWidget {
  final String selectedLocation;
  final VoidCallback onTap;

  const LocationSelector({
    super.key,
    required this.selectedLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Location icon
            Image.asset(
              AppIcon.location,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
            ),

            SizedBox(width: 12.w),

            // Selected location text
            Expanded(
              child: Text(
                selectedLocation,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBrown,
                ),
              ),
            ),

            // Dropdown arrow
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.darkBrown,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
