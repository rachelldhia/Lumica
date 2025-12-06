import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

class AppTextTheme {
  static final TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.darkBrown,
    ),
    headline2: TextStyle(
      fontSize: 12.sp,
      color: AppColors.darkBrown,
      height: 1.4,
    ),
    bodyText1: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.vividOrange,
    ),
  );
}
