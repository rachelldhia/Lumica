import 'package:get/get.dart';
import 'package:lumica_app/features/wellness/controllers/grounding_controller.dart';

class GroundingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroundingController>(() => GroundingController());
  }
}
