import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/shimmer_widgets.dart';
import 'package:lumica_app/features/mood_track/controllers/mood_track_controller.dart';
import 'package:lumica_app/features/mood_track/widgets/mood_stat_card.dart';

class MoodTrackPage extends GetView<MoodTrackController> {
  const MoodTrackPage({super.key});

  // Emoji image asset mapping for each mood
  String _getMoodImage(String mood) {
    switch (mood) {
      case 'happy':
        return AppImages.emoHappy;
      case 'calm':
        return AppImages.emoCalm;
      case 'excited':
        return AppImages.emoExited;
      case 'angry':
        return AppImages.emoAngry;
      case 'sad':
        return AppImages.emoSad;
      case 'stress':
        return AppImages.emoStress;
      default:
        return AppImages.emoHappy;
    }
  }

  // Color mapping for each mood
  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return AppColors.brightYellow;
      case 'calm':
        return AppColors.lightSkyBlue;
      case 'excited':
        return AppColors.brightPink;
      case 'angry':
        return AppColors.brightRed;
      case 'sad':
        return AppColors.darkBlue;
      case 'stress':
        return AppColors.darkGray;
      default:
        return AppColors.brightYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header shimmer
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        ShimmerCircle(size: 24.w),
                        SizedBox(width: 8.w),
                        ShimmerLine(width: 120.w, height: 18),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Dominant mood shimmer
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 200.h,
                      borderRadius: 32,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Mood stats grid shimmer
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.15,
                      children: List.generate(
                        6,
                        (index) => ShimmerBox(
                          width: double.infinity,
                          height: 150.h,
                          borderRadius: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.darkBrown,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'tracker mood',
                        style: AppTextTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkBrown,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Dominant mood display
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 48.h,
                    horizontal: 24.w,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _getMoodColor(
                          controller.dominantMood.value,
                        ).withValues(alpha: 0.25),
                        _getMoodColor(
                          controller.dominantMood.value,
                        ).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your mood is',
                        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkSlateGray,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.moodNames[controller.dominantMood.value] ??
                            'Happy',
                        style: AppTextTheme.textTheme.displayLarge?.copyWith(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBrown,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        width: 72.w,
                        height: 72.h,
                        decoration: BoxDecoration(
                          color: _getMoodColor(controller.dominantMood.value),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            _getMoodImage(controller.dominantMood.value),
                            width: 44.w,
                            height: 44.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Mood statistics grid with staggered animation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final moods = [
                        ('Happy', 'happy'),
                        ('Calm', 'calm'),
                        ('Excited', 'excited'),
                        ('Angry', 'angry'),
                        ('Sad', 'sad'),
                        ('Stress', 'stress'),
                      ];

                      final (moodName, moodKey) = moods[index];

                      return TweenAnimationBuilder<double>(
                        key: ValueKey('mood_stat_$moodKey'),
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: MoodStatCard(
                          mood: moodName,
                          percentage: controller.getMoodPercentage(moodKey),
                          imagePath: _getMoodImage(moodKey),
                          backgroundColor: _getMoodColor(moodKey),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
