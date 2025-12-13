import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

import 'package:lumica_app/core/widgets/profile_avatar.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';

class VidcallPage extends GetView<VidcallController> {
  const VidcallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  primaryButtonText: 'Reschedule',
                  secondaryButtonText: 'Join Now',
                  isRebook: false,
                ),
                SizedBox(height: 12.h),
                _buildSessionCard(
                  name: 'Sahana V',
                  credentials: 'Msc in Clinical Psychology',
                  date: '31st March \'22',
                  time: '7:30 PM - 8:30 PM',
                  primaryButtonText: 'Re-book',
                  secondaryButtonText: 'View Profile',
                  isRebook: true,
                ),
                SizedBox(height: 12.h),
                _buildSessionCard(
                  name: 'Sahana V',
                  credentials: 'Msc in Clinical Psychology',
                  date: '31st March \'22',
                  time: '7:30 PM - 8:30 PM',
                  primaryButtonText: 'Re-book',
                  secondaryButtonText: 'View Profile',
                  isRebook: true,
                ),
                SizedBox(height: 20.h),
              ],
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
        color: AppColors.paleSalmon,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Session', style: AppTextTheme.textTheme.headlineLarge),
          SizedBox(height: 8.h),
          Text(
            'Sahana V, Msc in Clinical Psychology',
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkBrown.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text('7:30 PM - 8:30 PM', style: AppTextTheme.textTheme.titleMedium),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text('Join Now', style: AppTextTheme.textTheme.labelLarge),
              SizedBox(width: 6.w),
              Icon(
                Icons.play_circle,
                color: AppColors.vividOrange,
                size: 20.sp,
              ),
            ],
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
            Text('All Sessions', style: AppTextTheme.textTheme.headlineSmall),
            SizedBox(width: 6.w),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.darkBrown,
              size: 20.sp,
            ),
          ],
        ),
        Icon(Icons.sort, color: AppColors.stoneGray, size: 24.sp),
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
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isRebook
            ? AppColors.stoneGray.withValues(alpha: 0.15)
            : AppColors.paleSalmon,
        borderRadius: BorderRadius.circular(16.r),
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
                      borderRadius: BorderRadius.circular(8.r),
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
                  ),
                  child: Text(
                    secondaryButtonText,
                    style: AppTextTheme.textTheme.labelMedium,
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
