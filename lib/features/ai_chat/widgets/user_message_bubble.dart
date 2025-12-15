import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/core/widgets/profile_avatar.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  final String? avatarUrl;
  final DateTime? timestamp;

  const UserMessageBubble({
    super.key,
    required this.message,
    this.avatarUrl,
    this.timestamp,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: message));
                    HapticFeedback.lightImpact();
                    AppSnackbar.copied();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
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
                if (timestamp != null)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w, top: 4.h),
                    child: Text(
                      DateFormat('h:mm a').format(timestamp!),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.darkSlateGray.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ProfileAvatar(size: 32, borderWidth: 2, imagePath: avatarUrl),
        ],
      ),
    );
  }
}
