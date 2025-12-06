import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/action_button.dart';
import 'package:lumica_app/features/home/widgets/mood_button.dart';
import 'package:lumica_app/features/home/widgets/plan_expired_card.dart';
import 'package:lumica_app/features/home/widgets/session_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile and notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.vividOrange,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.whiteColor,
                      size: 24.sp,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.stoneGray.withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 28.sp,
                          color: AppColors.darkBrown,
                        ),
                      ),
                      Positioned(
                        right: 6.w,
                        top: 6.h,
                        child: Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: const BoxDecoration(
                            color: AppColors.vividOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkBrown,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      controller.userName.value,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBrown,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // How are you feeling today
              Text(
                'How are you feeling today ?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBrown,
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
                      label: 'Happy',
                      color: AppColors.brightYellow,
                      isSelected: controller.selectedMoodIndex.value == 0,
                      onTap: () => controller.selectMood(0),
                    ),
                    MoodButton(
                      imagePath: AppImages.emoCalm,
                      label: 'Calm',
                      color: AppColors.lightSkyBlue,
                      isSelected: controller.selectedMoodIndex.value == 1,
                      onTap: () => controller.selectMood(1),
                    ),
                    MoodButton(
                      imagePath: AppImages.emoExited,
                      label: 'Exited',
                      color: AppColors.brightPink,
                      isSelected: controller.selectedMoodIndex.value == 2,
                      onTap: () => controller.selectMood(2),
                    ),
                    MoodButton(
                      imagePath: AppImages.emoAngry,
                      label: 'Angry',
                      color: AppColors.brightRed,
                      isSelected: controller.selectedMoodIndex.value == 3,
                      onTap: () => controller.selectMood(3),
                    ),
                    MoodButton(
                      imagePath: AppImages.emoSad,
                      label: 'Sad',
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
                    label: 'Journal',
                    onTap: () {
                      // Navigate to journal
                    },
                  ),
                  const SizedBox(width: 12),
                  ActionButton(
                    icon: Icons.insert_chart_outlined,
                    label: 'Mood Track',
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
                    color: AppColors.stoneGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.currentQuote.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.darkSlateGray,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Epilogue',
                            height: 1.4,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Image.asset(
                        AppImages.imageQuoteLeft,
                        width: 32.w,
                        height: 32.h,
                        fit: BoxFit.contain,
                        color: AppColors.darkSlateGray.withOpacity(0.3),
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
    );
  }
}
