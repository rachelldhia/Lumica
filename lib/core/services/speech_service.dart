import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Service to handle speech-to-text functionality
/// Simplified version focused on reliable speech recognition
class SpeechService extends GetxService {
  final SpeechToText _speechToText = SpeechToText();

  // Observable states
  final RxBool isListening = false.obs;
  final RxString recognizedText = ''.obs;
  final RxString errorMessage = ''.obs;

  /// Initialize speech recognition
  Future<bool> initializeSpeech() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        errorMessage.value = 'Microphone permission denied';
        debugPrint('⚠️ Microphone permission denied');
        return false;
      }

      // Initialize speech recognition
      final available = await _speechToText.initialize(
        onError: (error) {
          debugPrint('❌ Speech error: ${error.errorMsg}');
          errorMessage.value = _getUserFriendlyError(error.errorMsg);
          isListening.value = false;
        },
        onStatus: (status) {
          debugPrint('🎤 Speech status: $status');
          if (status == 'notListening') {
            isListening.value = false;
          }
        },
      );

      if (!available) {
        errorMessage.value = 'Speech recognition not available';
        debugPrint('❌ Speech recognition not available');
        return false;
      }

      debugPrint('✅ Speech services initialized');
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to initialize speech';
      debugPrint('❌ Failed to initialize speech: $e');
      return false;
    }
  }

  /// Start listening for speech input with improved settings
  Future<void> startListening(Function(String) onResult) async {
    if (!_speechToText.isAvailable) {
      errorMessage.value = 'Speech recognition not available';
      debugPrint('⚠️ Speech recognition not available');
      return;
    }

    if (isListening.value) {
      await stopListening();
      return;
    }

    recognizedText.value = '';
    errorMessage.value = '';
    isListening.value = true;

    try {
      // Get available locales and prioritize Indonesian
      final locales = await _speechToText.locales();
      String? localeId;

      // Try to find Indonesian locale
      final indonesianLocale = locales.firstWhereOrNull(
        (locale) =>
            locale.localeId.startsWith('id') ||
            locale.localeId.startsWith('in'),
      );

      if (indonesianLocale != null) {
        localeId = indonesianLocale.localeId;
        debugPrint('🌐 Using Indonesian locale: $localeId');
      } else {
        debugPrint('🌐 Using system default locale');
      }

      await _speechToText.listen(
        localeId: localeId, // Use Indonesian if available
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
          debugPrint('🎤 Recognized: ${result.recognizedWords}');
          debugPrint('🎤 Confidence: ${result.confidence}');

          // Only accept results with reasonable confidence
          if (result.finalResult &&
              result.recognizedWords.isNotEmpty &&
              result.confidence > 0.5) {
            onResult(result.recognizedWords);
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 30), // Reasonable timeout
        pauseFor: const Duration(seconds: 3), // Pause detection
        listenOptions: SpeechListenOptions(
          partialResults: true, // Show real-time results
          onDevice: true, // Use on-device for better privacy & speed
          listenMode: ListenMode.dictation, // Better for natural speech
          cancelOnError: false,
          autoPunctuation: true,
          enableHapticFeedback: true, // Haptic feedback on recognition
        ),
      );

      debugPrint('🎤 Started listening...');
    } catch (e) {
      errorMessage.value = 'Failed to start listening';
      isListening.value = false;
      debugPrint('❌ Failed to start listening: $e');
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (isListening.value) {
      await _speechToText.stop();
      isListening.value = false;
      debugPrint('🎤 Stopped listening');
    }
  }

  /// Convert error codes to user-friendly messages
  String _getUserFriendlyError(String error) {
    if (error.contains('error_no_match') || error.contains('7')) {
      return 'Tidak mendeteksi suara. Coba bicara lebih jelas dan keras.';
    } else if (error.contains('error_network')) {
      return 'Kesalahan jaringan. Periksa koneksi internet.';
    } else if (error.contains('error_audio')) {
      return 'Masalah audio. Pastikan mikrofon tidak digunakan app lain.';
    } else if (error.contains('error_busy')) {
      return 'Layanan sibuk. Tunggu sebentar dan coba lagi.';
    } else if (error.contains('error_speech_timeout')) {
      return 'Waktu habis. Coba bicara lebih cepat.';
    }
    return 'Terjadi kesalahan recognition. Coba lagi.';
  }

  /// Check if speech recognition is available
  bool get isAvailable => _speechToText.isAvailable;

  /// Check if currently listening
  bool get isCurrentlyListening => _speechToText.isListening;

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }
}
