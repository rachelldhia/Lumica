import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    if (tabIndex.value == index) return;
    tabIndex.value = index;
    // IndexedStack handles the view switch, no need for Get.toNamed with id
  }
}
