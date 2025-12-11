import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';

class NetworkController extends GetxController {
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Check initial status
    InternetConnection().hasInternetAccess.then((result) {
      isConnected.value = result;
    });

    // Listen to changes
    InternetConnection().onStatusChange.listen((status) {
      final hasInternet = status == InternetStatus.connected;
      isConnected.value = hasInternet;

      if (!hasInternet) {
        AppSnackbar.error(
          'No internet connection. Please check your network.',
          title: 'Offline',
        );
      }
    });
  }
}
