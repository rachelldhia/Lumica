import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/utils/haptic_util.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);

    // Trigger initial animation for the first tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTabChanged();
    });

    // Listen to tab changes and trigger animation replay
    ever(tabIndex, (_) => _onTabChanged());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    // Add haptic feedback on tab change
    HapticUtil.selection();

    // Always trigger animation even if same tab (for refresh effect)
    tabIndex.value = index;
    pageController.jumpToPage(index);

    // Force trigger animation replay
    _onTabChanged();
  }

  void _onTabChanged() {
    // Trigger animation replay for the active page
    switch (tabIndex.value) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().animationKey.value++;
        }
        break;
      case 1:
        if (Get.isRegistered<VidcallController>()) {
          Get.find<VidcallController>().animationKey.value++;
        }
        break;
      case 2:
        if (Get.isRegistered<AiChatController>()) {
          Get.find<AiChatController>().animationKey.value++;
        }
        break;
      case 3:
        if (Get.isRegistered<JournalController>()) {
          Get.find<JournalController>().animationKey.value++;
        }
        break;
      case 4:
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().animationKey.value++;
        }
        break;
    }
  }
}
