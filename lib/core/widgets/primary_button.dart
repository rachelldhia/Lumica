import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.backgroundColor,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ??
              (onPressed == null ? AppColors.stoneGray : AppColors.vividOrange),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style:
                  textStyle ??
                  AppTextTheme.textTheme.labelLarge?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (icon != null) ...[SizedBox(width: 10.w), icon!],
          ],
        ),
      ),
    );
  }
}
