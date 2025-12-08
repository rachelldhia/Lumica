import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class MoodButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final Color color; // Kept for text color or potential future use
  final bool isSelected;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 60.w, fit: BoxFit.contain),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextTheme.textTheme.labelSmall?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
