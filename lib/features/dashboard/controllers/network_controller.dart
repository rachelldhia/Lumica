import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';

class NetworkController extends GetxController {
  final RxBool isConnected = true.obs;
  final RxBool wasDisconnected = false.obs;
  StreamSubscription<InternetStatus>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _initNetworkMonitoring();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _initNetworkMonitoring() {
    // Check initial status
    InternetConnection().hasInternetAccess.then((result) {
      isConnected.value = result;
    });

    // Listen to changes
    _subscription = InternetConnection().onStatusChange.listen((status) {
      final hasInternet = status == InternetStatus.connected;

      // Track if we were previously disconnected
      if (!isConnected.value && !hasInternet) {
        wasDisconnected.value = true;
      }

      isConnected.value = hasInternet;

      if (!hasInternet) {
        wasDisconnected.value = true;
        AppSnackbar.error(
          'No internet connection. Please check your network.',
          title: 'Offline',
        );
      } else if (wasDisconnected.value && hasInternet) {
        // Connection restored notification
        wasDisconnected.value = false;
        AppSnackbar.success('Connection restored!', title: 'Online');
      }
    });
  }

  /// Check if network is available (for use before API calls)
  bool get hasConnection => isConnected.value;
}
