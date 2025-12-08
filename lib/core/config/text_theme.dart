import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

class AppTextTheme {
  static TextTheme get textTheme => TextTheme(
    // Display styles - largest text
    // Usage: Hero sections, splash screens, very short marketing copy
    displayLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
      height: 1.3,
    ),
    displaySmall: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBrown,
      height: 1.3,
    ),

    // Headline styles - section headers
    // Usage: Page titles, Top-level section headers
    headlineLarge: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBrown,
      height: 1.4,
    ),

    // Title styles - card titles
    // Usage: Card headers, List item titles, Dialog titles
    titleLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBrown,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBrown,
      height: 1.4,
    ),

    // Body styles - main content
    // Usage: Paragraphs, Descriptions, User generated content
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.darkBrown,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.darkBrown,
      height: 1.5,
    ),
    // Usage: Footnotes, Captions, Secondary info
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.darkBrown.withValues(alpha: 0.7),
      height: 1.5,
    ),

    // Label styles - buttons, tags
    // Usage: Button text, Chip labels, Navigation labels
    labelLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.vividOrange,
      height: 1.2,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.vividOrange,
      height: 1.2,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.vividOrange,
      height: 1.2,
    ),
  );
}
