import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  final String? avatarUrl;

  const UserMessageBubble({
    super.key,
    required this.message,
    this.avatarUrl, // Optional avatar URL
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.skyBlue,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                message,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBrown,
                  fontSize: 15.sp,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          ProfileAvatar(size: 32, borderWidth: 2, imagePath: avatarUrl),
        ],
      ),
    );
  }
}
