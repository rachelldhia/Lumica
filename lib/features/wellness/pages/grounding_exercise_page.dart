import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/wellness/controllers/grounding_controller.dart';

class GroundingExercisePage extends GetView<GroundingController> {
  const GroundingExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkBrown,
          ),
        ),
        title: Text(
          '5-4-3-2-1 Grounding',
          style: AppTextTheme.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.steps.length,
              itemBuilder: (context, index) {
                final step = controller.steps[index];
                return _buildStep(step);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Obx(
              () => PrimaryButton(
                text:
                    controller.currentStep.value == controller.steps.length - 1
                    ? 'Finish'
                    : 'Next Step',
                onPressed: controller.nextStep,
                backgroundColor:
                    controller.currentStep.value == controller.steps.length - 1
                    ? AppColors.limeGreen
                    : AppColors.vividOrange,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> step) {
    final isDone = step['number'] == 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: (step['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(step['icon'], size: 64.sp, color: step['color']),
              )
              .animate(key: ValueKey(step['number']))
              .scale(duration: 500.ms, curve: Curves.easeOutBack),

          SizedBox(height: 48.h),

          if (!isDone)
            Text(
              '${step['number']}',
              style: AppTextTheme.textTheme.displayLarge?.copyWith(
                fontSize: 80.sp,
                color: (step['color'] as Color).withValues(alpha: 0.5),
                height: 1,
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

          SizedBox(height: 16.h),

          Text(
            step['title'],
            style: AppTextTheme.textTheme.displayMedium?.copyWith(
              fontSize: 28.sp,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms),

          SizedBox(height: 16.h),

          Text(
            step['description'],
            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.greyText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
