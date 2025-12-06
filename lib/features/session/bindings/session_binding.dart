import 'package:get/get.dart';
import 'package:lumica_app/features/session/controllers/session_controller.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionController>(
      () => SessionController(),
    );
  }

}