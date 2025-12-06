import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  index: 0,
                  isActive: controller.currentNavIndex.value == 0,
                  onTap: () => controller.changeNavIndex(0),
                ),
                _buildNavItem(
                  imagePath: AppIcon.vidcall,
                  index: 1,
                  isActive: controller.currentNavIndex.value == 1,
                  onTap: () => controller.changeNavIndex(1),
                ),
                // Center FAB
                GestureDetector(
                  onTap: () {
                    controller.changeNavIndex(2); // AI Chat index
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.vividOrange,
                          Color(0xFFFF9D5C),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.vividOrange.withOpacity(0.4),
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
                ),
                _buildNavItem(
                  imagePath: AppIcon.jurnalGrey,
                  index: 3,
                  isActive: controller.currentNavIndex.value == 3,
                  onTap: () => controller.changeNavIndex(3),
                ),
                _buildNavItem(
                  imagePath: AppIcon.profile,
                  index: 4,
                  isActive: controller.currentNavIndex.value == 4,
                  onTap: () => controller.changeNavIndex(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String imagePath,
    required int index,
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
