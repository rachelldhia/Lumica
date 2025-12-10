import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isDisabled;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.stoneGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: controller,
                  enabled: !isDisabled,
                  decoration: InputDecoration(
                    hintText: 'Type to start chatting...',
                    hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkSlateGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkBrown,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: isDisabled ? null : (_) => onSend(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: isDisabled ? null : onSend,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColors.stoneGray.withValues(alpha: 0.5)
                      : AppColors.mossGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
