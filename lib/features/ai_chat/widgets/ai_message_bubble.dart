import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';

class AiMessageBubble extends StatelessWidget {
  final String message;
  final bool hasEmotionBadge;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.hasEmotionBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileAvatar(
            size: 32,
            borderWidth: 2,
            imagePath: AppImages.lumiRobot,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.paleSalmon,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                message,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBrown,
                  fontSize: 15.sp, // Slightly larger
                  height: 1.6, // Better line spacing for readability
                  letterSpacing: 0.2, // Subtle spacing
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
