import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color:
                widget.color?.withValues(alpha: 0.2) ??
                AppColors.stoneGray.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20.sp,
                color:
                    widget.iconColor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.vividOrange
                        : (widget.color != null
                              ? widget.color!
                              : AppColors.darkSlateGray)),
              ),
              SizedBox(width: 12.w),
              Text(
                widget.label,
                style: AppTextTheme.textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
