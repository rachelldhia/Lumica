import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isDisabled;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isDisabled = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _sendButtonController;
  late Animation<double> _scaleAnimation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _sendButtonController = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _sendButtonController,
        curve: AppAnimations.standard,
      ),
    );

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _sendButtonController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend() {
    if (widget.isDisabled || !_hasText) return;
    HapticFeedback.lightImpact();
    _sendButtonController.forward().then((_) {
      _sendButtonController.reverse();
    });
    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: AppAnimations.medium,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: _hasText
                      ? AppColors.paleSalmon.withValues(alpha: 0.2)
                      : AppColors.stoneGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24.r),
                  border: _hasText
                      ? Border.all(
                          color: AppColors.vividOrange.withValues(alpha: 0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: !widget.isDisabled,
                  decoration: InputDecoration(
                    hintText: 'Type to start chatting...',
                    hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkSlateGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkBrown,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: widget.isDisabled ? null : (_) => _handleSend(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            AnimatedBuilder(
              animation: _sendButtonController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: _handleSend,
                child: AnimatedContainer(
                  duration: AppAnimations.medium,
                  curve: AppAnimations.standard,
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: widget.isDisabled
                        ? AppColors.stoneGray.withValues(alpha: 0.5)
                        : (_hasText
                              ? AppColors.mossGreen
                              : AppColors.stoneGray),
                    shape: BoxShape.circle,
                    boxShadow: _hasText && !widget.isDisabled
                        ? [
                            BoxShadow(
                              color: AppColors.mossGreen.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: AppColors.whiteColor,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
