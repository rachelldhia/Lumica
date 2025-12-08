import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key, this.badgeCount = 0, this.onTap});

  final int badgeCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.stoneGray.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 24.sp,
              color: AppColors.darkBrown,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: 4.w,
              top: 4.h,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: const BoxDecoration(
                  color: AppColors.vividOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
