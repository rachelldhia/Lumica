import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/journal/models/text_format.dart';

class TextFormattingToolbar extends StatelessWidget {
  final TextFormat currentFormat;
  final Function(TextFormat) onFormatChanged;

  const TextFormattingToolbar({
    super.key,
    required this.currentFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Bold
            _buildFormatButton(
              icon: Icons.format_bold,
              isActive: currentFormat.isBold,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(isBold: !currentFormat.isBold),
                );
              },
            ),

            // Italic
            _buildFormatButton(
              icon: Icons.format_italic,
              isActive: currentFormat.isItalic,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(isItalic: !currentFormat.isItalic),
                );
              },
            ),

            // Underline
            _buildFormatButton(
              icon: Icons.format_underline,
              isActive: currentFormat.isUnderline,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(
                    isUnderline: !currentFormat.isUnderline,
                  ),
                );
              },
            ),

            // Strikethrough
            _buildFormatButton(
              icon: Icons.format_strikethrough,
              isActive: currentFormat.isStrikethrough,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(
                    isStrikethrough: !currentFormat.isStrikethrough,
                  ),
                );
              },
            ),

            // Divider
            Container(
              width: 1,
              height: 24.h,
              color: AppColors.whiteColor.withValues(alpha: 0.3),
            ),

            // Align left
            _buildFormatButton(
              icon: Icons.format_align_left,
              isActive: currentFormat.alignment == TextAlign.left,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(alignment: TextAlign.left),
                );
              },
            ),

            // Align center
            _buildFormatButton(
              icon: Icons.format_align_center,
              isActive: currentFormat.alignment == TextAlign.center,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(alignment: TextAlign.center),
                );
              },
            ),

            // Align right
            _buildFormatButton(
              icon: Icons.format_align_right,
              isActive: currentFormat.alignment == TextAlign.right,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(alignment: TextAlign.right),
                );
              },
            ),

            // Align justify
            _buildFormatButton(
              icon: Icons.format_align_justify,
              isActive: currentFormat.alignment == TextAlign.justify,
              onTap: () {
                onFormatChanged(
                  currentFormat.copyWith(alignment: TextAlign.justify),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.whiteColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, color: AppColors.whiteColor, size: 22.sp),
      ),
    );
  }
}
