import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/action_button.dart';
import 'package:lumica_app/features/home/widgets/mood_button.dart';
import 'package:lumica_app/features/home/widgets/plan_expired_card.dart';
import 'package:lumica_app/features/home/widgets/session_card.dart';
import 'package:lumica_app/routes/app_routes.dart';

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
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildGreeting(),
                SizedBox(height: 20.h),
                Text(
                  'home.howAreYou'.tr,
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: AppColors.darkSlateGray,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildMoodSelector(),
                SizedBox(height: 20.h),
                const SessionCard(),
                SizedBox(height: 18.h),
                _buildActionButtons(),
                SizedBox(height: 20.h),
                _buildQuoteSection(),
                SizedBox(height: 20.h),
                const PlanExpiredCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => ProfileAvatar(size: 48, imagePath: controller.userAvatarUrl.value),
    );
  }

  Widget _buildGreeting() {
    return Obx(
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
    );
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              MoodButton(
                imagePath: AppImages.emoHappy,
                label: 'mood.happy'.tr,
                color: AppColors.brightYellow,
                isSelected: controller.selectedMoodIndex.value == 0,
                onTap: () => controller.selectMood(0),
              ),
              SizedBox(width: 16.w),
              MoodButton(
                imagePath: AppImages.emoCalm,
                label: 'mood.calm'.tr,
                color: AppColors.lightSkyBlue,
                isSelected: controller.selectedMoodIndex.value == 1,
                onTap: () => controller.selectMood(1),
              ),
              SizedBox(width: 16.w),
              MoodButton(
                imagePath: AppImages.emoExited,
                label: 'mood.excited'.tr,
                color: AppColors.brightPink,
                isSelected: controller.selectedMoodIndex.value == 2,
                onTap: () => controller.selectMood(2),
              ),
              SizedBox(width: 16.w),
              MoodButton(
                imagePath: AppImages.emoAngry,
                label: 'mood.angry'.tr,
                color: AppColors.brightRed,
                isSelected: controller.selectedMoodIndex.value == 3,
                onTap: () => controller.selectMood(3),
              ),
              SizedBox(width: 16.w),
              MoodButton(
                imagePath: AppImages.emoSad,
                label: 'mood.sad'.tr,
                color: AppColors.darkBlue,
                isSelected: controller.selectedMoodIndex.value == 4,
                onTap: () => controller.selectMood(4),
              ),
              SizedBox(width: 16.w),
              MoodButton(
                imagePath: AppImages.emoStress,
                label: 'mood.stress'.tr,
                color: AppColors.darkGray,
                isSelected: controller.selectedMoodIndex.value == 5,
                onTap: () => controller.selectMood(5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ActionButton(
          icon: Icons.book_outlined,
          label: 'journal.journal'.tr,
          onTap: () {
            Get.toNamed('/dashboard${AppRoutes.journal}');
          },
        ),
        SizedBox(width: 12.w),
        ActionButton(
          icon: Icons.insert_chart_outlined,
          label: 'home.moodTrack'.tr,
          onTap: () {
            Get.toNamed('/dashboard${AppRoutes.moodTrack}');
          },
        ),
      ],
    );
  }

  Widget _buildQuoteSection() {
    return Obx(
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
    );
  }
}
