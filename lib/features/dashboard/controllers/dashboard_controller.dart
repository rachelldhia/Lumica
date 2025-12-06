 import 'package:get/get.dart';
import 'package:lumica_app/routes/app_routes.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;

  final List<String> _pageRoutes = [
    AppRoutes.home,
    AppRoutes.vidcall,
    AppRoutes.aiChat,
    AppRoutes.journal,
    AppRoutes.profile,
  ];
  void changeTabIndex(int index) {
    if (tabIndex.value == index) return;
    tabIndex.value = index;
    Get.toNamed(_pageRoutes[index], id: 1); // Use nested navigator with id 1
  }
}
