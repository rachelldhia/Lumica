import 'package:flutter/material.dart';

import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/constants/app_icon.dart';

class PlanExpiredCard extends StatelessWidget {
  const PlanExpiredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4FA06F), // Green start
            Color(0xFF6ABF8B), // Green end
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Plan Expired',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'make a plan of your activities',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Make Your Plan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    AppIcon.arrowRight,
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              AppImages.imageMeditation, // Lotus flower
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              color: Colors.white.withValues(
                alpha: 0.5,
              ), // Subtle overlay effect if needed, or just raw
            ),
          ),
        ],
      ),
    );
  }
}
