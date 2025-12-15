import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';

class NetworkController extends GetxController {
  final InternetConnection _connection = InternetConnection();
  Timer? _debounceTimer;
  Timer? _autoRetryTimer;
  bool _wasDisconnected = false;

  @override
  void onInit() {
    super.onInit();
    _listenToNetworkChanges();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _autoRetryTimer?.cancel();
    super.onClose();
  }

  void _listenToNetworkChanges() {
    _connection.onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.disconnected) {
        // Optimized: Reduced debounce to 500ms for faster feedback
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          _wasDisconnected = true;
          _showNoInternetOverlay();
          _startAutoRetry();
          HapticFeedback.mediumImpact();
        });
      } else {
        // Connected
        _debounceTimer?.cancel();
        _autoRetryTimer?.cancel();

        // Immediately dismiss any open snackbars
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        // Show "Back Online" only if we were previously disconnected
        if (_wasDisconnected) {
          _wasDisconnected = false;
          // Delay back-online message slightly to ensure previous snackbar is dismissed
          Future.delayed(const Duration(milliseconds: 100), () {
            _showBackOnlineOverlay();
          });
          HapticFeedback.lightImpact();
        }
      }
    });
  }

  void _startAutoRetry() {
    // Optimized: Auto-retry every 3 seconds for faster reconnection detection
    _autoRetryTimer?.cancel();
    _autoRetryTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final status = await _connection.internetStatus;
      if (status == InternetStatus.connected) {
        timer.cancel();

        // Immediately dismiss any open snackbars
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        _wasDisconnected = false;

        // Delay back-online message slightly
        Future.delayed(const Duration(milliseconds: 100), () {
          _showBackOnlineOverlay();
        });
        HapticFeedback.lightImpact();
      }
    });
  }

  void _showNoInternetOverlay() {
    if (Get.isSnackbarOpen) return;
    AppSnackbar.noInternet();
  }

  void _showBackOnlineOverlay() {
    AppSnackbar.backOnline();
  }
}
