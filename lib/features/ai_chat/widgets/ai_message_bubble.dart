import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';

class AiMessageBubble extends StatelessWidget {
  final String message;
  final bool hasEmotionBadge;
  final DateTime? timestamp;
  final VoidCallback? onSpeak;
  final bool isSpeaking;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.hasEmotionBadge = false,
    this.timestamp,
    this.onSpeak,
    this.isSpeaking = false,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: message));
                    HapticFeedback.lightImpact();
                    AppSnackbar.copied();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.paleSalmon.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        topRight: Radius.circular(18.r),
                        bottomLeft: Radius.circular(18.r),
                        bottomRight: Radius.circular(18.r),
                      ),
                      border: Border.all(
                        color: AppColors.paleSalmon.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.paleSalmon.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkBrown,
                        fontSize: 14.5.sp,
                        height: 1.6,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
                if (timestamp != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 6.h),
                    child: Text(
                      DateFormat('h:mm a').format(timestamp!),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.darkSlateGray.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
