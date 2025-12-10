import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/notification_bell.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/action_button.dart';
import 'package:lumica_app/features/home/widgets/mood_button.dart';
import 'package:lumica_app/features/home/widgets/plan_expired_card.dart';
import 'package:lumica_app/features/home/widgets/session_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile and notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ProfileAvatar(size: 48),
                    NotificationBell(badgeCount: 3, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 20),

                // Greeting
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.greeting.value,
                        style: AppTextTheme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        controller.userName.value,
                        style: AppTextTheme.textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // How are you feeling today
                Text(
                  'home.howAreYou'.tr,
                  style: AppTextTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 18),

                // Mood selector
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MoodButton(
                        imagePath: AppImages.emoHappy,
                        label: 'mood.happy'.tr,
                        color: AppColors.brightYellow,
                        isSelected: controller.selectedMoodIndex.value == 0,
                        onTap: () => controller.selectMood(0),
                      ),
                      MoodButton(
                        imagePath: AppImages.emoCalm,
                        label: 'mood.calm'.tr,
                        color: AppColors.lightSkyBlue,
                        isSelected: controller.selectedMoodIndex.value == 1,
                        onTap: () => controller.selectMood(1),
                      ),
                      MoodButton(
                        imagePath: AppImages.emoExited,
                        label: 'mood.excited'.tr,
                        color: AppColors.brightPink,
                        isSelected: controller.selectedMoodIndex.value == 2,
                        onTap: () => controller.selectMood(2),
                      ),
                      MoodButton(
                        imagePath: AppImages.emoAngry,
                        label: 'mood.angry'.tr,
                        color: AppColors.brightRed,
                        isSelected: controller.selectedMoodIndex.value == 3,
                        onTap: () => controller.selectMood(3),
                      ),
                      MoodButton(
                        imagePath: AppImages.emoSad,
                        label: 'mood.sad'.tr,
                        color: AppColors.darkBlue,
                        isSelected: controller.selectedMoodIndex.value == 4,
                        onTap: () => controller.selectMood(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 1 on 1 Sessions Card
                const SessionCard(),
                const SizedBox(height: 18),

                // Journal and Mood Track buttons
                Row(
                  children: [
                    ActionButton(
                      icon: Icons.book_outlined,
                      label: 'journal.journal'.tr,
                      onTap: () {
                        // Navigate to journal
                      },
                    ),
                    const SizedBox(width: 12),
                    ActionButton(
                      icon: Icons.insert_chart_outlined,
                      label: 'home.moodTrack'.tr,
                      onTap: () {
                        // Navigate to mood track
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quote section (auto-rotating)
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.stoneGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.currentQuote.value,
                            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkSlateGray,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Epilogue',
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Image.asset(
                          AppImages.imageQuoteLeft,
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.contain,
                          color: AppColors.darkSlateGray.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Plan Expired Card
                const PlanExpiredCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
