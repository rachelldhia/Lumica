import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ErrorMessageBox extends StatelessWidget {
  const ErrorMessageBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.vividOrange.withAlpha(50),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.vividOrange, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.vividOrange,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.vividOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
