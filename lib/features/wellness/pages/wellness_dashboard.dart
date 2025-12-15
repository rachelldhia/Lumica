import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/routes/app_routes.dart';

class WellnessDashboard extends StatelessWidget {
  const WellnessDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 24.sp,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ).animate().scale(
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),

                  SizedBox(height: 24.h),

                  Text(
                        'wellness.title'.tr,
                        style: AppTextTheme.textTheme.displayMedium,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.1, end: 0),

                  SizedBox(height: 8.h),

                  Text(
                        'wellness.subtitle'.tr,
                        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyText,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideX(begin: -0.1, end: 0),
                ],
              ),

              SizedBox(height: 32.h),

              // Breathing Card (Large)
              _buildFeatureCard(
                title: 'wellness.breathing'.tr,
                subtitle: 'wellness.breathingDesc'.tr,
                icon: Icons.air,
                color: const Color(0xFF48CAE4), // Ocean Blue
                onTap: () {
                  Get.toNamed(
                    '${AppRoutes.dashboard}${AppRoutes.wellness}${AppRoutes.breathing}',
                  );
                },
                delay: 300.ms,
              ),

              SizedBox(height: 16.h),

              // Grounding Card
              _buildFeatureCard(
                title: 'wellness.grounding'.tr,
                subtitle: 'wellness.groundingDesc'.tr,
                icon: Icons.nature,
                color: const Color(0xFF06D6A0), // Calm Green
                onTap: () {
                  Get.toNamed(
                    '${AppRoutes.dashboard}${AppRoutes.wellness}${AppRoutes.grounding}',
                  );
                },
                delay: 400.ms,
              ),

              SizedBox(height: 16.h),

              // Panic Button (Distinct Style)
              _buildPanicButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Duration delay = Duration.zero,
  }) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(icon, color: color, size: 32.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextTheme.textTheme.titleLarge),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.greyText.withValues(alpha: 0.5),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay, duration: 500.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildPanicButton(BuildContext context) {
    return GestureDetector(
          onTap: () => _showPanicDialog(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF9F1C).withValues(alpha: 0.1),
                  const Color(0xFFFF9F1C).withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: const Color(0xFFFF9F1C).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9F1C).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sos_rounded,
                    color: const Color(0xFFE85D04),
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'wellness.panicTitle'.tr,
                        style: AppTextTheme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFE85D04),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'wellness.panicDesc'.tr,
                        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFE85D04).withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  void _showPanicDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'wellness.panicDialogTitle'.tr,
          style: AppTextTheme.textTheme.titleMedium,
        ),
        content: Text('wellness.panicDialogMessage'.tr),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('common.close'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AppSnackbar.info(
                'wellness.comingSoonMessage'.tr,
                title: 'wellness.comingSoon'.tr,
              );
            },
            child: Text('wellness.callHelper'.tr),
          ),
        ],
      ),
    );
  }
}
