import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/profile_constants.dart';

class ProfileAvatarSelector extends StatelessWidget {
  final int selectedAvatarIndex;
  final Function(int) onAvatarSelected;
  final File? uploadedAvatar;
  final VoidCallback? onUploadTap;

  const ProfileAvatarSelector({
    super.key,
    required this.selectedAvatarIndex,
    required this.onAvatarSelected,
    this.uploadedAvatar,
    this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            ProfileConstants.avatarPresets.length + 1, // +1 for upload button
        itemBuilder: (context, index) {
          if (index == 0) {
            // Upload button or uploaded avatar
            return _buildUploadButton();
          }

          final avatarIndex = index - 1;
          final avatar = ProfileConstants.avatarPresets[avatarIndex];
          final isSelected = selectedAvatarIndex == avatar.id;

          return _buildAvatarOption(avatar, avatar.id, isSelected);
        },
      ),
    );
  }

  Widget _buildUploadButton() {
    // If there's an uploaded avatar, show it
    if (uploadedAvatar != null) {
      return GestureDetector(
        onTap: onUploadTap,
        child: Container(
          width: 60.w,
          height: 60.h,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: selectedAvatarIndex == -1
                ? Border.all(color: AppColors.vividOrange, width: 2.5)
                : null,
            boxShadow: selectedAvatarIndex == -1
                ? [
                    BoxShadow(
                      color: AppColors.vividOrange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            image: DecorationImage(
              image: FileImage(uploadedAvatar!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // Otherwise show the upload button
    return GestureDetector(
      onTap: onUploadTap,
      child: Container(
        width: 60.w,
        height: 60.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: CustomPaint(
          painter: DashedCirclePainter(
            color: AppColors.darkBrown.withValues(alpha: 0.4),
            strokeWidth: 1.5,
            dashWidth: 4,
            dashSpace: 4,
          ),
          child: Center(
            child: Icon(
              Icons.arrow_downward,
              color: AppColors.darkBrown.withValues(alpha: 0.6),
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption(AvatarOption avatar, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onAvatarSelected(index),
      child: Container(
        width: 60.w,
        height: 60.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatar.color,
          border: isSelected
              ? Border.all(color: AppColors.vividOrange, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.vividOrange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(avatar.icon, color: Colors.white, size: 28.sp),
        ),
      ),
    );
  }
}

// Custom painter for smooth dashed circle
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = (size.width / 2) - (strokeWidth / 2);
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final adjustedDashSpace =
        (circumference - (dashCount * dashWidth)) / dashCount;

    double startAngle = -3.141592653589793 / 2; // Start from top

    for (int i = 0; i < dashCount; i++) {
      final sweepAngle = dashWidth / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle + (adjustedDashSpace / radius);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
