import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/features/profile/controllers/personal_info_controller.dart';
import 'package:lumica_app/features/profile/widgets/edit_text_field.dart';
import 'package:lumica_app/features/profile/widgets/gender_selector.dart';
import 'package:lumica_app/features/profile/widgets/location_dropdown.dart';
import 'package:lumica_app/features/profile/widgets/profile_avatar_selector.dart';

class PersonalInfoPage extends GetView<PersonalInfoController> {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.whiteColor, // Removed for dark mode
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkBrown,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'personalInfo.title'.tr,
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            // color: AppColors.darkBrown, // Removed hardcode
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username field
            Text(
              'personalInfo.username'.tr,
              style: AppTextTheme.textTheme.titleMedium?.copyWith(
                // color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            EditTextField(
              iconAsset: AppIcon.personalInformation,
              hintText: 'personalInfo.yourName'.tr,
              controller: controller.usernameController,
            ),

            // Username validation error
            Obx(
              () => controller.usernameError.value.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 6.h, left: 4.w),
                      child: Text(
                        controller.usernameError.value,
                        style: AppTextTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            SizedBox(height: 20.h),

            // Password field
            Text(
              'auth.password'.tr,
              style: AppTextTheme.textTheme.titleMedium?.copyWith(
                // color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => EditTextField(
                iconAsset: AppIcon.lock,
                hintText: 'auth.password'.tr,
                controller: controller.passwordController,
                obscureText: true,
                isPasswordVisible: controller.isPasswordVisible.value,
                onVisibilityToggle: controller.togglePasswordVisibility,
              ),
            ),

            // Password validation error
            Obx(
              () => controller.passwordError.value.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 6.h, left: 4.w),
                      child: Text(
                        controller.passwordError.value,
                        style: AppTextTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            SizedBox(height: 20.h),

            // Profile picture selector
            Text(
              'personalInfo.chooseProfilePicture'.tr,
              style: AppTextTheme.textTheme.titleMedium?.copyWith(
                // color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => ProfileAvatarSelector(
                selectedAvatarIndex: controller.selectedAvatarIndex.value,
                onAvatarSelected: controller.updateAvatar,
                uploadedAvatar: controller.uploadedAvatar.value,
                onUploadTap: controller.uploadCustomAvatar,
              ),
            ),

            SizedBox(height: 20.h),

            // Location dropdown
            Text(
              'personalInfo.location'.tr,
              style: AppTextTheme.textTheme.titleMedium?.copyWith(
                // color: AppColors.darkBrown,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => LocationSelector(
                selectedLocation: controller.selectedLocation.value,
                onTap: controller.showLocationDialog,
              ),
            ),

            SizedBox(height: 20.h),

            // Gender selector
            Obx(
              () => GenderSelector(
                selectedGender: controller.selectedGender.value,
                onGenderChanged: controller.updateGender,
              ),
            ),

            SizedBox(height: 32.h),

            // Save button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vividOrange,
                    disabledBackgroundColor: AppColors.vividOrange.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(3, (index) {
                              return TweenAnimationBuilder<double>(
                                key: ValueKey('dot_$index'),
                                duration: const Duration(milliseconds: 1200),
                                tween: Tween(begin: 0.0, end: 1.0),
                                curve: Curves.easeInOut,
                                builder: (context, value, child) {
                                  final delay = index * 0.2;
                                  final progress = (value - delay).clamp(
                                    0.0,
                                    1.0,
                                  );
                                  final opacity =
                                      (1 - (progress - 0.5).abs() * 2).clamp(
                                        0.3,
                                        1.0,
                                      );

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                    ),
                                    child: Container(
                                      width: 6.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor.withValues(
                                          alpha: opacity,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'personalInfo.saveSettings'.tr,
                              style: AppTextTheme.textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check,
                              color: AppColors.whiteColor,
                              size: 20.sp,
                            ),
                          ],
                        ),
                ),
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
