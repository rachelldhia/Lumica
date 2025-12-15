import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // Force rebuild when animationKey changes to replay animations
        final _ = controller.animationKey.value;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                [
                      // Name field
                      _buildSectionTitle('personalInfo.yourName'.tr),
                      SizedBox(height: 8.h),
                      EditTextField(
                        iconAsset: AppIcon.personalInformation,
                        hintText: 'personalInfo.yourName'.tr,
                        controller: controller.nameController,
                      ),
                      _buildNameError(),

                      SizedBox(height: 20.h),

                      // Password field
                      _buildSectionTitle('auth.password'.tr),
                      SizedBox(height: 8.h),
                      Obx(
                        () => EditTextField(
                          iconAsset: AppIcon.lock,
                          hintText: 'auth.password'.tr,
                          controller: controller.passwordController,
                          obscureText: true,
                          isPasswordVisible: controller.isPasswordVisible.value,
                          onVisibilityToggle:
                              controller.togglePasswordVisibility,
                        ),
                      ),
                      _buildPasswordError(),

                      SizedBox(height: 24.h),

                      // Profile picture selector
                      _buildSectionTitle(
                        'personalInfo.chooseProfilePicture'.tr,
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => ProfileAvatarSelector(
                          selectedAvatarIndex:
                              controller.selectedAvatarIndex.value,
                          onAvatarSelected: controller.updateAvatar,
                          uploadedAvatar: controller.uploadedAvatar.value,
                          onUploadTap: controller.uploadCustomAvatar,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Location dropdown with Detect Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionTitle('personalInfo.location'.tr),
                          Obx(
                            () => InkWell(
                              onTap: controller.isLocating.value
                                  ? null
                                  : controller.detectLocation,
                              child: Row(
                                children: [
                                  if (controller.isLocating.value)
                                    SizedBox(
                                      width: 12.w,
                                      height: 12.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.my_location,
                                      size: 16.sp,
                                      color: AppColors.vividOrange,
                                    ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Detect Me',
                                    style: AppTextTheme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.vividOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      _buildSectionTitle('personalInfo.gender'.tr),
                      SizedBox(height: 8.h),
                      Obx(
                        () => GenderSelector(
                          selectedGender: controller.selectedGender.value,
                          onGenderChanged: controller.updateGender,
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // Save button
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.saveSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.vividOrange,
                              disabledBackgroundColor: AppColors.vividOrange
                                  .withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.vividOrange.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            child: controller.isLoading.value
                                ? _buildLoadingDots()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'personalInfo.saveSettings'.tr,
                                        style: AppTextTheme
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: AppColors.whiteColor,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ]
                    .animate(interval: 50.ms)
                    .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.darkBrown,
      ),
    );
  }

  Widget _buildNameError() {
    return Obx(
      () => controller.nameError.value.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text(
                controller.nameError.value,
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ).animate().fadeIn().slideX(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildPasswordError() {
    return Obx(
      () => controller.passwordError.value.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text(
                controller.passwordError.value,
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ).animate().fadeIn().slideX(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
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
              final progress = (value - delay).clamp(0.0, 1.0);
              final opacity = (1 - (progress - 0.5).abs() * 2).clamp(0.3, 1.0);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withValues(alpha: opacity),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
            onEnd: () {},
          );
        }),
      ],
    );
  }
}
