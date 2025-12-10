import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showMoreIcon;
  final VoidCallback? onMoreTap;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.showMoreIcon = true,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextTheme.textTheme.titleLarge?.copyWith(
                  // color: AppColors.darkBrown, // Removed hardcode
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showMoreIcon)
                GestureDetector(
                  onTap: onMoreTap,
                  child: Icon(
                    Icons.more_vert,
                    color: AppColors.greyText,
                    size: 24.sp,
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Settings container
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color, // Use theme card color
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkSlateGray.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.stoneGray.withValues(alpha: 0.2),
                    indent: 54.w,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
