import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/mood_button.dart';
import 'package:lumica_app/features/home/widgets/session_card.dart';
import 'package:lumica_app/features/home/widgets/action_button.dart';
import 'package:lumica_app/features/home/widgets/plan_expired_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
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
                                    color: AppColors.stoneGray.withValues(
                                      alpha: 0.3,
                                    ),
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
                              isSelected:
                                  controller.selectedMoodIndex.value == 0,
                              onTap: () => controller.selectMood(0),
                            ),
                            MoodButton(
                              imagePath: AppImages.emoCalm,
                              label: 'Calm',
                              color: AppColors.lightSkyBlue,
                              isSelected:
                                  controller.selectedMoodIndex.value == 1,
                              onTap: () => controller.selectMood(1),
                            ),
                            MoodButton(
                              imagePath: AppImages.emoExited,
                              label: 'Exited',
                              color: AppColors.brightPink,
                              isSelected:
                                  controller.selectedMoodIndex.value == 2,
                              onTap: () => controller.selectMood(2),
                            ),
                            MoodButton(
                              imagePath: AppImages.emoAngry,
                              label: 'Angry',
                              color: AppColors.brightRed,
                              isSelected:
                                  controller.selectedMoodIndex.value == 3,
                              onTap: () => controller.selectMood(3),
                            ),
                            MoodButton(
                              imagePath: AppImages.emoSad,
                              label: 'Sad',
                              color: AppColors.darkBlue,
                              isSelected:
                                  controller.selectedMoodIndex.value == 4,
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
                            color: AppColors.stoneGray.withValues(alpha: 0.2),
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
                                color: AppColors.darkSlateGray.withValues(
                                  alpha: 0.3,
                                ),
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

            // Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavItem(
                          imagePath: AppIcon.homeOrange,
                          imagePathInactive: AppIcon.homeGray,
                          index: 0,
                          isActive: controller.currentNavIndex.value == 0,
                        ),
                        _buildNavItem(
                          imagePath: AppIcon.cameraOrange,
                          imagePathInactive: AppIcon.cameraGrey,
                          index: 1,
                          isActive: controller.currentNavIndex.value == 1,
                        ),
                        // Center FAB
                        GestureDetector(
                          onTap: () {
                            controller.changeNavIndex(2); // AI Chat index
                          },
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.vividOrange,
                                  Color(0xFFFF9D5C),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.vividOrange.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                AppIcon.iconChatAI,
                                width: 32.w,
                                height: 32.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        _buildNavItem(
                          imagePath: AppIcon.jurnalOrange,
                          imagePathInactive: AppIcon.jurnalGrey,
                          index: 3,
                          isActive: controller.currentNavIndex.value == 3,
                        ),
                        _buildNavItem(
                          imagePath: AppIcon.profileOrange,
                          imagePathInactive: AppIcon.profileGrey,
                          index: 4,
                          isActive: controller.currentNavIndex.value == 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String imagePathInactive,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changeNavIndex(index),
      child: Container(
        height: 60.h, // Match FAB height
        width: 40.w, // Sufficient width for hit target
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dot indicator - sticks to top
            Positioned(
              top: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.vividOrange : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Icon - Centered
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.whiteColor : AppColors.stoneGray,
                BlendMode.modulate,
              ),
              child: Image.asset(
                isActive ? imagePath : imagePathInactive,
                width: 28.w,
                height: 28.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
