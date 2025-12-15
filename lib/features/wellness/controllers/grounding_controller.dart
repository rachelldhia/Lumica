import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';

class GroundingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  final List<Map<String, dynamic>> steps = [
    {
      'number': 5,
      'title': 'Things you see',
      'description':
          'Look around and notice 5 things you hadn\'t noticed before.',
      'icon': Icons.visibility_outlined,
      'color': AppColors.vividOrange,
    },
    {
      'number': 4,
      'title': 'Things you feel',
      'description':
          'Notice 4 sensations on your body (e.g. feet on floor, shirt on skin).',
      'icon': Icons.touch_app_outlined,
      'color': AppColors.forestGreen,
    },
    {
      'number': 3,
      'title': 'Things you hear',
      'description':
          'Listen closely for 3 distinct sounds in your environment.',
      'icon': Icons.hearing_outlined,
      'color': AppColors.skyBlue,
    },
    {
      'number': 2,
      'title': 'Things you smell',
      'description':
          'Focus on 2 smells. If you can\'t smell anything, imagine your favorite scent.',
      'icon': Icons.local_florist_outlined,
      'color': AppColors.amethyst,
    },
    {
      'number': 1,
      'title': 'Thing you taste',
      'description':
          'Focus on 1 thing you can taste right now, or take a sip of water.',
      'icon': Icons.restaurant_outlined,
      'color': AppColors.brightRed,
    },
    {
      'number': 0, // Done
      'title': 'You are here',
      'description':
          'Great job. Take a moment to feel grounded in the present.',
      'icon': Icons.check_circle_outline,
      'color': AppColors.limeGreen,
    },
  ];

  void nextStep() {
    if (currentStep.value < steps.length - 1) {
      pageController.nextPage(duration: 500.ms, curve: Curves.easeOutQuart);
      currentStep.value++;
      HapticFeedback.lightImpact();
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
