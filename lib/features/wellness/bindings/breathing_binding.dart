import 'package:get/get.dart';
import 'package:lumica_app/features/wellness/controllers/breathing_controller.dart';

class BreathingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreathingController>(() => BreathingController());
  }
}
