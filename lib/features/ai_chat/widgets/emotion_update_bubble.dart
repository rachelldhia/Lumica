import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/ai_chat/models/chat_message.dart';

class EmotionUpdateBubble extends StatelessWidget {
  final String message;
  final EmotionType? emotion;

  const EmotionUpdateBubble({super.key, required this.message, this.emotion});

  Color _getEmotionColor() {
    if (emotion == null) return AppColors.mossGreen;

    switch (emotion!) {
      case EmotionType.happy:
        return AppColors.mossGreen;
      case EmotionType.sad:
      case EmotionType.despair:
        return AppColors.vividOrange;
      case EmotionType.angry:
        return AppColors.vividOrange;
      case EmotionType.calm:
        return AppColors.mossGreen;
      case EmotionType.excited:
        return AppColors.mossGreen;
      case EmotionType.stress:
        return AppColors.vividOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: _getEmotionColor(),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_emotions,
                size: 18.sp,
                color: AppColors.whiteColor,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  message,
                  style: AppTextTheme.textTheme.labelSmall?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 13.sp, // Slight override to match design
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
