import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class LocationSelectionDialog extends StatelessWidget {
  final List<String> locations;
  final String selectedLocation;
  final Function(String) onLocationSelected;

  const LocationSelectionDialog({
    super.key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Local observable for the dialog state
    // We initialize it with the currently selected location from controller
    final RxString tempSelected = selectedLocation.obs;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Select Location',
              style: AppTextTheme.textTheme.titleLarge?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),

            // Location options - Scrollable
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: locations
                      .map(
                        (location) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Obx(
                            () => _buildLocationOption(
                              location,
                              tempSelected.value == location,
                              () {
                                tempSelected.value = location;
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Done button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  onLocationSelected(tempSelected.value);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vividOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Done',
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption(
    String location,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.vividOrange
              : AppColors.stoneGray.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.vividOrange
                : AppColors.stoneGray.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                location,
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.darkBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.whiteColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
