import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class MoodButton extends StatefulWidget {
  final String imagePath;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<MoodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.bounce),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale:
                _scaleAnimation.value *
                (widget.isSelected ? _bounceAnimation.value : 1.0),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppAnimations.medium,
          curve: AppAnimations.standard,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppAnimations.medium,
                curve: AppAnimations.standard,
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: widget.isSelected
                      ? Border.all(
                          color: widget.color.withValues(alpha: 0.8),
                          width: 3,
                        )
                      : null,
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.imagePath,
                    width: 56.w,
                    height: 56.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              AnimatedDefaultTextStyle(
                duration: AppAnimations.fast,
                style:
                    AppTextTheme.textTheme.labelSmall?.copyWith(
                      color: widget.isSelected
                          ? widget.color
                          : AppColors.darkBrown,
                      fontWeight: widget.isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 11.sp,
                    ) ??
                    const TextStyle(),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
