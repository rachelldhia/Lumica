import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/routes/app_routes.dart';

class DashboardNavBar extends StatefulWidget {
  const DashboardNavBar({super.key});

  @override
  State<DashboardNavBar> createState() => _DashboardNavBarState();
}

class _DashboardNavBarState extends State<DashboardNavBar> {
  final controller = Get.find<DashboardController>();
  bool _isFabPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  imagePath: AppIcon.home,
                  route: AppRoutes.home,
                  isActive: controller.tabIndex.value == 0,
                  onTap: () => controller.changeTabIndex(0),
                ),
                _buildNavItem(
                  imagePath: AppIcon.vidcall,
                  route: AppRoutes.vidcall,
                  isActive: controller.tabIndex.value == 1,
                  onTap: () => controller.changeTabIndex(1),
                ),
                // Center FAB
                _buildFab(),
                _buildNavItem(
                  imagePath: AppIcon.jurnalGrey,
                  route: AppRoutes.journal,
                  isActive: controller.tabIndex.value == 3,
                  onTap: () => controller.changeTabIndex(3),
                ),
                _buildNavItem(
                  imagePath: AppIcon.profile,
                  route: AppRoutes.profile,
                  isActive: controller.tabIndex.value == 4,
                  onTap: () => controller.changeTabIndex(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    final isActive = controller.tabIndex.value == 2;

    return AnimatedScale(
      scale: _isFabPressed ? 0.85 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isFabPressed = true),
        onTapUp: (_) {
          setState(() => _isFabPressed = false);
          Future.delayed(const Duration(milliseconds: 50), () {
            controller.changeTabIndex(2);
          });
        },
        onTapCancel: () => setState(() => _isFabPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isActive
                  ? [AppColors.vividOrange, const Color(0xFFFF9D5C)]
                  : [
                      AppColors.vividOrange.withValues(alpha: 0.9),
                      const Color(0xFFFF9D5C).withValues(alpha: 0.9),
                    ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.vividOrange.withValues(
                  alpha: _isFabPressed ? 0.6 : (isActive ? 0.5 : 0.3),
                ),
                blurRadius: _isFabPressed ? 20 : (isActive ? 16 : 12),
                spreadRadius: _isFabPressed ? 4 : (isActive ? 3 : 2),
                offset: Offset(0, _isFabPressed ? 6 : 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Image.asset(
                AppIcon.iconChatAI,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required String route,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.vividOrange.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Image.asset(
                imagePath,
                width: 26.w,
                height: 26.h,
                fit: BoxFit.contain,
                color: isActive ? AppColors.vividOrange : AppColors.stoneGray,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isActive ? 6.w : 0,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.vividOrange,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
