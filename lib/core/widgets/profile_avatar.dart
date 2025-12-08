import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.imagePath,
    this.borderWidth = 2.5,
  });

  final double size;
  final String? imagePath;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.vividOrange, width: borderWidth),
      ),
      child: ClipOval(
        child: Image.asset(imagePath ?? AppImages.kentud, fit: BoxFit.cover),
      ),
    );
  }
}
