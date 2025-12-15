/// Common reusable card widgets for the app
/// Provides consistent card styling across features
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

/// Base card widget with standard elevation and padding
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: cardContent);
    }

    return cardContent;
  }
}

/// Info card with icon, title, and subtitle
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.vividOrange).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.vividOrange,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.greyText.withValues(alpha: 0.5),
            ),
        ],
      ),
    );
  }
}

/// Statistic card showing a number and label
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 32.sp, color: color ?? AppColors.oceanBlue),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.darkBrown,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.greyText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
