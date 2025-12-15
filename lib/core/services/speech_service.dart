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
      await _speechToText.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
          debugPrint('🎤 Recognized: ${result.recognizedWords}');

          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 60), // Increased timeout
        pauseFor: const Duration(seconds: 5), // Longer pause detection
        listenOptions: SpeechListenOptions(
          partialResults: true,
          onDevice: false, // Use cloud recognition for better accuracy
          listenMode: ListenMode.confirmation,
          cancelOnError: false, // Don't auto-cancel on error
          autoPunctuation: true,
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
      return 'Tidak mendeteksi suara. Coba bicara lebih jelas.';
    } else if (error.contains('error_network')) {
      return 'Kesalahan jaringan. Periksa koneksi internet.';
    } else if (error.contains('error_audio')) {
      return 'Masalah audio. Periksa mikrofon Anda.';
    } else if (error.contains('error_busy')) {
      return 'Layanan sibuk. Coba lagi.';
    }
    return 'Terjadi kesalahan. Coba lagi.';
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
