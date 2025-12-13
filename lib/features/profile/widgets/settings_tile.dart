import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';

class SettingsTile extends StatefulWidget {
  final String? iconAsset;
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    this.iconAsset,
    this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  }) : assert(
         iconAsset != null || icon != null,
         'Either iconAsset or icon must be provided',
       );

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isPressed
                ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.03)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: widget.iconAsset != null
                    ? Image.asset(
                        widget.iconAsset!,
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      )
                    : Icon(widget.icon!, size: 24.sp),
              ),
              SizedBox(width: 16.w),

              // Title
              Expanded(
                child: Text(
                  widget.title,
                  style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Trailing widget
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
