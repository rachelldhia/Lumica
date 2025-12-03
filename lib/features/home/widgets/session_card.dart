import 'package:flutter/material.dart';
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
                const Text(
                  '1 on 1 Sessions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's open up to the things that\nmatter the most",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.darkBrown,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.vividOrange,
                      ),
                    ),
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
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
