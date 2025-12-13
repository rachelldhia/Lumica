import 'package:flutter/material.dart';
import 'package:lumica_app/core/config/theme.dart';

/// Wraps chat messages with a slide-in animation
/// User messages slide in from the right, AI messages from the left
class AnimatedChatMessage extends StatefulWidget {
  final Widget child;
  final bool isUser;
  final int index;

  const AnimatedChatMessage({
    super.key,
    required this.child,
    required this.isUser,
    this.index = 0,
  });

  @override
  State<AnimatedChatMessage> createState() => _AnimatedChatMessageState();
}

class _AnimatedChatMessageState extends State<AnimatedChatMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    // Slide direction based on sender
    final beginOffset = widget.isUser
        ? const Offset(0.3, 0) // Slide from right
        : const Offset(-0.3, 0); // Slide from left

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.enter));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.enter));

    // Start animation with slight delay based on index
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
    );
  }
}
