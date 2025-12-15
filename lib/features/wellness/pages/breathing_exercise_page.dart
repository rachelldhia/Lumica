import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/wellness/controllers/breathing_controller.dart';

class BreathingExercisePage extends GetView<BreathingController> {
  const BreathingExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.darkBrown,
              size: 20.sp,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient Background - Very Subtle
          Obx(
            () => AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    controller.circleColor.value.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Breathing Visualizer Area
              SizedBox(
                width: 320.w,
                height: 320.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Aura (Faintest, Largest)
                    Obx(
                      () => _buildAnimatedCircle(
                        scale: controller.circleScale.value * 1.4,
                        color: controller.circleColor.value.withValues(
                          alpha: 0.1,
                        ),
                        duration: _getDuration(controller),
                        curve: _getCurve(controller),
                      ),
                    ),

                    // Middle Aura (Medium, Medium)
                    Obx(
                      () => _buildAnimatedCircle(
                        scale: controller.circleScale.value * 1.2,
                        color: controller.circleColor.value.withValues(
                          alpha: 0.2,
                        ),
                        duration: _getDuration(controller),
                        curve: _getCurve(controller),
                      ),
                    ),

                    // Inner Core (Solid, Smallest)
                    Obx(
                      () => _buildAnimatedCircle(
                        scale: controller.circleScale.value,
                        color: controller.circleColor.value.withValues(
                          alpha: 0.3,
                        ),
                        duration: _getDuration(controller),
                        curve: _getCurve(controller),
                        hasBorder: true,
                        borderColor: controller.circleColor.value.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),

                    // Text (Static Position, Changing Content)
                    Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.instruction.value,
                            style: AppTextTheme.textTheme.displaySmall
                                ?.copyWith(
                                  color: AppColors.darkBrown,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                          ).animate().fadeIn(
                            duration: 300.ms,
                          ), // Smooth text fade
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // Instruction Detail
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Obx(
                  () =>
                      Text(
                            controller.detail.value,
                            textAlign: TextAlign.center,
                            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyText,
                              height: 1.5,
                            ),
                          )
                          .animate(target: controller.isPlaying.value ? 1 : 0)
                          .fadeIn(),
                ),
              ),

              SizedBox(height: 48.h),

              // Controls
              Obx(
                () => PrimaryButton(
                  text: controller.isPlaying.value
                      ? 'Pause'
                      : 'Start Breathing',
                  onPressed: controller.toggleSession,
                  backgroundColor: controller.isPlaying.value
                      ? AppColors.stoneGray
                      : AppColors.vividOrange,
                  width: 200.w,
                  textStyle: AppTextTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper for consistent animation params
  Duration _getDuration(BreathingController controller) {
    if (!controller.isPlaying.value) return const Duration(milliseconds: 500);
    final instr = controller.instruction.value;
    if (instr == 'Inhale') return const Duration(seconds: 4);
    if (instr == 'Exhale') return const Duration(seconds: 8);
    return const Duration(seconds: 7); // Hold
  }

  Curve _getCurve(BreathingController controller) {
    final instr = controller.instruction.value;
    if (instr == 'Inhale') return Curves.easeOutQuad;
    if (instr == 'Exhale') return Curves.easeInQuad;
    return Curves.linear;
  }

  Widget _buildAnimatedCircle({
    required double scale,
    required Color color,
    required Duration duration,
    required Curve curve,
    bool hasBorder = false,
    Color? borderColor,
  }) {
    return Transform.scale(
      scale: scale,
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: 200.w, // Base size
        height: 200.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: hasBorder
              ? Border.all(color: borderColor ?? Colors.transparent, width: 1.5)
              : null,
          boxShadow: hasBorder
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
