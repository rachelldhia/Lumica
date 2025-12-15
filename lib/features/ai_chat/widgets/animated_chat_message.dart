import 'package:flutter/material.dart';

/// Wraps chat messages with an optimized slide-in animation
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
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Slightly faster
    );

    // Reduced slide distance for more subtle effect
    final beginOffset = widget.isUser
        ? const Offset(0.15, 0) // Subtle slide from right
        : const Offset(-0.15, 0); // Subtle slide from left

    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic, // Smoother curve
          ),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Subtle scale for depth
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Reduced delay for snappier feel
    Future.delayed(Duration(milliseconds: 30 * widget.index), () {
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
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
      ),
    );
  }
}
