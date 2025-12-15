import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/app_states.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/core/widgets/replayable_animated_list.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/action_button.dart';
import 'package:lumica_app/features/home/widgets/mood_button.dart';
import 'package:lumica_app/features/home/widgets/mood_chart_card.dart';
import 'package:lumica_app/features/home/widgets/session_card.dart';
import 'package:lumica_app/routes/app_routes.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () => controller.refreshData(),
          // Wrap with ReplayableAnimateWrapper to replay animations on tab switch
          child: ReplayableAnimateWrapper(
            animationKey: controller.animationKey,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with pop effect
                    _buildHeader()
                        .animate()
                        .fadeIn(duration: 200.ms, curve: Curves.easeOut)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          curve: Curves.easeOut,
                          duration: 200.ms,
                        ),
                    SizedBox(height: 20.h),
                    // Greeting with slide
                    _buildGreeting()
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 50.ms)
                        .slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
                    SizedBox(height: 20.h),
                    // Question text with subtle animation
                    Text(
                          'home.howAreYou'.tr,
                          style: AppTextTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: AppColors.darkSlateGray,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    SizedBox(height: 16.h),
                    // Mood selector
                    _buildMoodSelector()
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 150.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    SizedBox(height: 20.h),
                    // Session card
                    const SessionCard().animate().fadeIn(
                      duration: 200.ms,
                      delay: 200.ms,
                    ),
                    SizedBox(height: 18.h),
                    // Action buttons
                    _buildActionButtons().animate().fadeIn(
                      duration: 200.ms,
                      delay: 250.ms,
                    ),
                    SizedBox(height: 20.h),
                    // Quote section
                    _buildQuoteSection()
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 300.ms)
                        .slideX(begin: 0.05, end: 0, curve: Curves.easeOut),
                    SizedBox(height: 20.h),
                    // Mood Chart with elegant entrance
                    Obx(
                          () => MoodChartCard(
                            moodEntries: controller.moodEntries,
                            isLoading: controller.isLoadingMoods.value,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 350.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                  ],
                ),
              ),
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
    return Column(
      children: [
        // Wellness Toolkit Button (Full width)
        ActionButton(
              icon: Icons.spa_outlined,
              label: 'Wellness Toolkit',
              color: AppColors.oceanBlue,
              onTap: () async {
                await Get.toNamed(
                  '${AppRoutes.dashboard}${AppRoutes.wellness}',
                );
                controller.replayAnimations();
              },
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: 350.ms)
            .slideY(begin: 0.1, end: 0),
        SizedBox(height: 12.h),
        // Journal & Mood Track Row
        Row(
          children: [
            Expanded(
              child:
                  ActionButton(
                        icon: Icons.book_outlined,
                        label: 'journal.journal'.tr,
                        onTap: () {
                          Get.toNamed('/dashboard${AppRoutes.journal}');
                        },
                      )
                      .animate()
                      .fadeIn(delay: 50.ms, duration: 200.ms)
                      .slideX(begin: -0.05, end: 0),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child:
                  ActionButton(
                        icon: Icons.insert_chart_outlined,
                        label: 'home.moodTrack'.tr,
                        onTap: () {
                          Get.toNamed('/dashboard${AppRoutes.moodTrack}');
                        },
                      )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 200.ms)
                      .slideX(begin: 0.05, end: 0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteSection() {
    return Obx(
      () => AnimatedSwitcher(
        duration: AppAnimations.medium,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey(controller.currentQuote.value),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.stoneGray.withValues(alpha: 0.15),
                AppColors.stoneGray.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Image.asset(
                AppImages.imageQuoteLeft,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.contain,
                color: AppColors.vividOrange.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
