import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

/// A wrapper widget that forces child animations to replay when [animationKey] changes.
///
/// This is designed to work with tab navigation where pages are kept alive
/// but animations need to replay when returning to a tab.
///
/// Usage:
/// ```dart
/// ReplayableAnimatedList(
///   animationKey: controller.animationKey,
///   child: ListView.builder(...),
/// )
/// ```
class ReplayableAnimatedList extends StatelessWidget {
  /// The animation key from the controller. When this value changes,
  /// the child widget tree will be rebuilt and animations will replay.
  final RxInt animationKey;

  /// The child widget to animate. This should contain widgets using
  /// [AnimationConfiguration.staggeredList] or similar.
  final Widget child;

  /// Whether to use [AnimationLimiter] to coordinate staggered animations.
  /// Defaults to true.
  final bool useAnimationLimiter;

  const ReplayableAnimatedList({
    super.key,
    required this.animationKey,
    required this.child,
    this.useAnimationLimiter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Using animationKey in the Key forces a complete rebuild
      // when the tab is activated, replaying all animations
      final key = ValueKey('animated_list_${animationKey.value}');

      if (useAnimationLimiter) {
        return AnimationLimiter(key: key, child: child);
      }

      return KeyedSubtree(key: key, child: child);
    });
  }
}

/// A wrapper for flutter_animate animations that replay on tab navigation.
///
/// This widget should wrap content that uses `.animate()` extension.
/// When [animationKey] changes, the entire subtree rebuilds, replaying animations.
class ReplayableAnimateWrapper extends StatelessWidget {
  /// The animation key from the controller.
  final RxInt animationKey;

  /// The child widget with flutter_animate animations.
  final Widget child;

  const ReplayableAnimateWrapper({
    super.key,
    required this.animationKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Force rebuild when animationKey changes
      return KeyedSubtree(
        key: ValueKey('animate_wrapper_${animationKey.value}'),
        child: child,
      );
    });
  }
}
