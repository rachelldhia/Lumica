import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paleSalmon,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1 on 1 Sessions',
                  style: AppTextTheme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's open up to the things that\nmatter the most",
                  style: AppTextTheme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Book Now', style: AppTextTheme.textTheme.bodyMedium),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.vividOrange,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Meditation illustration
          Image.asset(
            AppImages.imageMeetup,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
