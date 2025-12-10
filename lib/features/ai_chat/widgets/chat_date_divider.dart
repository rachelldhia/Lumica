import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ChatDateDivider extends StatelessWidget {
  final String dateText;

  const ChatDateDivider({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.darkSlateGray.withValues(alpha: 0.4),
              thickness: 1.5,
              endIndent: 16.w,
            ),
          ),
          Text(
            dateText,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkSlateGray,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.darkSlateGray.withValues(alpha: 0.4),
              thickness: 1.5,
              indent: 16.w,
            ),
          ),
        ],
      ),
    );
  }
}
