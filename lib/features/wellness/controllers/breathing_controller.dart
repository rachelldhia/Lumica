import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';

class BreathingController extends GetxController
    with GetTickerProviderStateMixin {
  // Phase durations
  static const int inhaleDuration = 4;
  static const int holdDuration = 7;
  static const int exhaleDuration = 8;

  // Observables
  final RxString instruction = 'Ready?'.obs;
  final RxString detail = 'Inhale for 4, Hold for 7, Exhale for 8'.obs;
  final Rx<Color> circleColor = AppColors.oceanBlue.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble circleScale = 1.0.obs;

  Timer? _timer;

  void toggleSession() {
    if (isPlaying.value) {
      stopSession();
    } else {
      startSession();
    }
  }

  void startSession() {
    isPlaying.value = true;
    _runCycle();
  }

  void stopSession() {
    _timer?.cancel();
    isPlaying.value = false;
    instruction.value = 'Paused';
    detail.value = 'Tap Resume to continue';
    circleScale.value = 1.0;
  }

  void _runCycle() async {
    if (!isPlaying.value) return;

    // INHALE
    instruction.value = 'Inhale';
    detail.value = 'Breathe in slowly through your nose';
    circleColor.value = AppColors.oceanBlue;
    circleScale.value = 1.5;
    HapticFeedback.heavyImpact();

    await Future.delayed(const Duration(seconds: inhaleDuration));
    if (!isPlaying.value) return;

    // HOLD
    instruction.value = 'Hold';
    detail.value = 'Hold your breath gently';
    circleColor.value = AppColors.amethyst;
    circleScale.value = 1.5; // Stay expanded
    HapticFeedback.lightImpact();

    await Future.delayed(const Duration(seconds: holdDuration));
    if (!isPlaying.value) return;

    // EXHALE
    instruction.value = 'Exhale';
    detail.value = 'Release slowly through your mouth';
    circleColor.value = AppColors.mossGreen;
    circleScale.value = 1.0;
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(seconds: exhaleDuration));
    if (!isPlaying.value) return;

    // Loop
    _runCycle();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
