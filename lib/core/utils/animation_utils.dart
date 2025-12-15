import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Extension methods for easy animations using flutter_animate
extension AnimateWidgetExtensions on Widget {
  /// Fade in from bottom with staggered delay
  Widget fadeInFromBottom({int delayMs = 0, int durationMs = 400}) {
    return animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: Duration(milliseconds: durationMs))
        .slideY(
          begin: 0.1,
          end: 0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOutCubic,
        );
  }

  /// Slide in from left
  Widget slideInFromLeft({int delayMs = 0, int durationMs = 300}) {
    return animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: Duration(milliseconds: durationMs))
        .slideX(
          begin: -0.2,
          end: 0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOutCubic,
        );
  }

  /// Slide in from right
  Widget slideInFromRight({int delayMs = 0, int durationMs = 300}) {
    return animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: Duration(milliseconds: durationMs))
        .slideX(
          begin: 0.2,
          end: 0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOutCubic,
        );
  }

  /// Scale in with bounce
  Widget scaleInWithBounce({int delayMs = 0, int durationMs = 400}) {
    return animate(delay: Duration(milliseconds: delayMs))
        .fadeIn(duration: Duration(milliseconds: durationMs))
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: Duration(milliseconds: durationMs),
          curve: Curves.elasticOut,
        );
  }

  /// Subtle pulse effect (for attention)
  Widget pulse({int durationMs = 2000}) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      begin: const Offset(1, 1),
      end: const Offset(1.02, 1.02),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOut,
    );
  }

  /// Shimmer effect overlay
  Widget shimmerEffect({int durationMs = 1500}) {
    return animate(onPlay: (controller) => controller.repeat()).shimmer(
      duration: Duration(milliseconds: durationMs),
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  /// Looping float animation (subtle up/down movement)
  Widget loopingFloat({int durationMs = 2000, double distance = 5}) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveY(
      begin: -distance,
      end: distance,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOut,
    );
  }

  /// Breathing animation (for empty states, icons)
  Widget breathe({int durationMs = 2500}) {
    return animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 0.95,
          end: 1.0,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeInOut,
        )
        .fadeIn(begin: 0.7, duration: Duration(milliseconds: durationMs));
  }

  /// Bounce loop animation (for buttons, CTAs)
  Widget bounceLoop({int durationMs = 1500}) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scaleXY(
      begin: 1.0,
      end: 1.05,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOut,
    );
  }

  /// Gentle rotation animation (for loading indicators)
  Widget gentleRotate({int durationMs = 3000}) {
    return animate(onPlay: (controller) => controller.repeat()).rotate(
      begin: 0,
      end: 1,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.linear,
    );
  }

  /// Glow pulse animation (for live indicators, notifications)
  Widget glowPulse({int durationMs = 1500, Color color = Colors.green}) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).boxShadow(
      begin: BoxShadow(
        color: color.withValues(alpha: 0.2),
        blurRadius: 4,
        spreadRadius: 1,
      ),
      end: BoxShadow(
        color: color.withValues(alpha: 0.6),
        blurRadius: 12,
        spreadRadius: 4,
      ),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeInOut,
    );
  }
}

/// Staggered animation helper for lists
class StaggeredListAnimation {
  /// Calculate delay for item at index
  static int getDelay(int index, {int baseDelayMs = 50, int maxDelayMs = 500}) {
    return (index * baseDelayMs).clamp(0, maxDelayMs);
  }
}

/// Page transition builders for custom route animations
class AppPageTransitions {
  /// Fade transition
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Slide up transition
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 0.1);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Scale transition
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
