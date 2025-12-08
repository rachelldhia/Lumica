import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/routes/app_routes.dart';

class DashboardNavBar extends GetView<DashboardController> {
  const DashboardNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return GestureDetector(
      onTap: () => controller.changeTabIndex(2),
      child: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.vividOrange, Color(0xFFFF9D5C)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.vividOrange.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            AppIcon.iconChatAI,
            width: 32.w,
            height: 32.h,
            fit: BoxFit.contain,
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
      child: Container(
        height: 60.h, // Match FAB height
        width: 40.w, // Sufficient width for hit target
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dot indicator - sticks to top
            Positioned(
              top: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.vividOrange : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Icon - Centered
            Image.asset(
              imagePath,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
              color: isActive ? AppColors.vividOrange : AppColors.stoneGray,
            ),
          ],
        ),
      ),
    );
  }
}
