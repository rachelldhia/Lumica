import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/widgets/background_circle.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/features/profile/widgets/settings_section.dart';
import 'package:lumica_app/features/profile/widgets/settings_tile.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.whiteColor, // Removed to use Theme background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background circle - ikut scroll
              BackgroundCircle(
                position: CirclePosition.topCenter,
                circleColor: AppColors.amethyst,
              ),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 80.h),

                    // Profile Header
                    _buildProfileHeader(),

                    SizedBox(height: 32.h),

                    // General Settings Section
                    Obx(
                      () => SettingsSection(
                        title: 'profile.generalSettings'.tr,
                        children: [
                          SettingsTile(
                            iconAsset: AppIcon.notification,
                            title: 'profile.notifications'.tr,
                            trailing: Image.asset(
                              AppIcon.panahKanan,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onTap: controller.navigateToNotifications,
                          ),
                          SettingsTile(
                            iconAsset: AppIcon.personalInformation,
                            title: 'profile.personalInfo'.tr,
                            trailing: Image.asset(
                              AppIcon.panahKanan,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onTap: controller.navigateToPersonalInfo,
                          ),
                          SettingsTile(
                            iconAsset: AppIcon.language,
                            title: 'profile.language'.tr,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.selectedLanguage.value,
                                  style: AppTextTheme.textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.greyText),
                                ),
                                SizedBox(width: 8.w),
                                Image.asset(
                                  AppIcon.panahKanan,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                              ],
                            ),
                            onTap: controller.navigateToLanguageSelection,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Log Out Section
                    SettingsSection(
                      title: 'profile.logOut'.tr,
                      showMoreIcon: true,
                      children: [
                        SettingsTile(
                          icon: Icons.logout,
                          title: 'profile.logOut'.tr,
                          trailing: Image.asset(
                            AppIcon.panahKanan,
                            width: 20.w,
                            height: 20.h,
                          ),
                          onTap: controller.logout,
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Obx(
      () => Column(
        children: [
          // Avatar
          ProfileAvatar(size: 120, imagePath: controller.userAvatarUrl.value),

          SizedBox(height: 12.h),

          // Name
          Text(
            controller.userName.value,
            style: AppTextTheme.textTheme.headlineSmall?.copyWith(
              // Using theme color will handle dark mode automatically
              // color: AppColors.darkBrown, // Removed hardcode
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 4.h),

          // Email
          Text(
            controller.userEmail.value,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors
                  .darkSlateGray, // This might need a dark mode variant
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          // Location
          Text(
            controller.userLocation.value,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
