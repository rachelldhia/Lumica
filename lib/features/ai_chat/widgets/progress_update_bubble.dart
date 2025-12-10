import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ProgressUpdateBubble extends StatelessWidget {
  final String message;

  const ProgressUpdateBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.vividOrange,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up, size: 18.sp, color: AppColors.whiteColor),
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
