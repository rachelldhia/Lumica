import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Helper text
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Choose only 1',
            style: AppTextTheme.textTheme.bodySmall?.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // Gender options
        Row(
          children: [
            Expanded(child: _buildGenderOption('Male')),
            SizedBox(width: 12.w),
            Expanded(child: _buildGenderOption('Female')),
          ],
        ),

        SizedBox(height: 12.h),

        _buildGenderOption('Other'),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => onGenderChanged(gender),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.vividOrange : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.vividOrange
                : AppColors.stoneGray.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                color: isSelected ? AppColors.whiteColor : AppColors.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.whiteColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.whiteColor : AppColors.greyText,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.vividOrange,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
