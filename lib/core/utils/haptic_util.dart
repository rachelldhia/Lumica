import 'package:flutter/services.dart';

/// Utility class for haptic feedback
/// Provides consistent haptic feedback across the app
class HapticUtil {
  /// Light haptic feedback for selections, toggles
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for button taps, confirmations
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for important actions, warnings
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback for scrolling through options
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Success haptic (light double tap feeling)
  static void success() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
  }

  /// Error haptic (warning pattern)
  static void error() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.mediumImpact();
    });
  }

  /// Notification haptic
  static void notification() {
    HapticFeedback.vibrate();
  }
}
