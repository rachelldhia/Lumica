import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom page transitions for premium feel
class AppTransitions {
  /// Fade + Scale transition (elegant)
  static GetPageBuilder fadeScale({required Widget page}) {
    return () => page;
  }

  /// Slide from bottom with fade
  static Transition get slideUp => Transition.downToUp;

  /// Zoom in transition
  static Transition get zoom => Transition.zoom;

  /// Custom fade transition
  static Transition get fade => Transition.fadeIn;
}

/// Custom transition builder for smooth animations
class CustomTransitionBuilder extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeOutCubic,
      ),
      child: SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(0.0, 0.03),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: curve ?? Curves.easeOutCubic,
              ),
            ),
        child: child,
      ),
    );
  }
}

/// Scale + Fade transition for modals
class ScaleFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: child,
      ),
    );
  }
}
