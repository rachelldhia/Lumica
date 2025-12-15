import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/app_states.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/core/widgets/replayable_animated_list.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';

class VidcallPage extends GetView<VidcallController> {
  const VidcallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            // TODO: Implement actual refresh when backend is ready
            await Future.delayed(const Duration(milliseconds: 500));
          },
          // Use ReplayableAnimatedList to replay animations on tab switch
          child: ReplayableAnimatedList(
            animationKey: controller.animationKey,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 450),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 40.0,
                      curve: Curves.easeOutCubic,
                      child: FadeInAnimation(
                        child: ScaleAnimation(
                          scale: 0.95,
                          curve: Curves.easeOutBack,
                          child: widget,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeader(),
                      SizedBox(height: 24.h),
                      _buildUpcomingSessionCard(),
                      SizedBox(height: 24.h),
                      _buildSessionsHeader(),
                      SizedBox(height: 16.h),
                      _buildSessionCard(
                        name: 'Sahana V',
                        credentials: 'Msc in Clinical Psychology',
                        date: '31st March \'22',
                        time: '7:30 PM - 8:30 PM',
                        primaryButtonText: 'vidcall.reschedule'.tr,
                        secondaryButtonText: 'vidcall.joinNow'.tr,
                        isRebook: false,
                        index: 0,
                      ),
                      SizedBox(height: 12.h),
                      _buildSessionCard(
                        name: 'Sahana V',
                        credentials: 'Msc in Clinical Psychology',
                        date: '31st March \'22',
                        time: '7:30 PM - 8:30 PM',
                        primaryButtonText: 'vidcall.rebook'.tr,
                        secondaryButtonText: 'common.viewProfile'.tr,
                        isRebook: true,
                        index: 1,
                      ),
                      SizedBox(height: 12.h),
                      _buildSessionCard(
                        name: 'Sahana V',
                        credentials: 'Msc in Clinical Psychology',
                        date: '31st March \'22',
                        time: '7:30 PM - 8:30 PM',
                        primaryButtonText: 'vidcall.rebook'.tr,
                        secondaryButtonText: 'common.viewProfile'.tr,
                        isRebook: true,
                        index: 2,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const ProfileAvatar(size: 48)],
    );
  }

  Widget _buildUpcomingSessionCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.paleSalmon,
            AppColors.paleSalmon.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.paleSalmon.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'vidcall.upcomingSession'.tr,
                style: AppTextTheme.textTheme.headlineLarge,
              ),
              const Spacer(),
              // Pulsing live indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.limeGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppColors.limeGreen,
                            shape: BoxShape.circle,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.3, 1.3),
                          duration: 800.ms,
                        ),
                    SizedBox(width: 4.w),
                    Text(
                      'vidcall.live'.tr,
                      style: AppTextTheme.textTheme.labelSmall?.copyWith(
                        color: AppColors.limeGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Sahana V, Msc in Clinical Psychology',
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkBrown.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text('7:30 PM - 8:30 PM', style: AppTextTheme.textTheme.titleMedium),
          SizedBox(height: 16.h),
          // Enhanced Join Now button
          GestureDetector(
            onTap: () {
              // TODO: Implement join functionality
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.vividOrange,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vividOrange.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'vidcall.joinNow'.tr,
                    style: AppTextTheme.textTheme.labelLarge?.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.play_circle,
                    color: AppColors.whiteColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'vidcall.allSessions'.tr,
              style: AppTextTheme.textTheme.headlineSmall,
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.darkBrown,
              size: 20.sp,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.stoneGray.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.sort, color: AppColors.darkSlateGray, size: 20.sp),
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String name,
    required String credentials,
    required String date,
    required String time,
    required String primaryButtonText,
    required String secondaryButtonText,
    required bool isRebook,
    required int index,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isRebook
            ? AppColors.stoneGray.withValues(alpha: 0.1)
            : AppColors.paleSalmon.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isRebook
              ? AppColors.stoneGray.withValues(alpha: 0.2)
              : AppColors.paleSalmon.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const ProfileAvatar(size: 48),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextTheme.textTheme.titleLarge),
                    SizedBox(height: 2.h),
                    Text(credentials, style: AppTextTheme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: AppColors.darkBrown.withValues(alpha: 0.6),
              ),
              SizedBox(width: 6.w),
              Text(date, style: AppTextTheme.textTheme.bodySmall),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                size: 14.sp,
                color: AppColors.darkBrown.withValues(alpha: 0.6),
              ),
              SizedBox(width: 6.w),
              Text(time, style: AppTextTheme.textTheme.bodySmall),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vividOrange,
                    foregroundColor: AppColors.whiteColor,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    primaryButtonText,
                    style: AppTextTheme.textTheme.labelMedium?.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.vividOrange,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: AppColors.vividOrange.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Text(
                    secondaryButtonText,
                    style: AppTextTheme.textTheme.labelMedium?.copyWith(
                      color: AppColors.vividOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
