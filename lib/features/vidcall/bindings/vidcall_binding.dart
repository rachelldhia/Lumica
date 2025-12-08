import 'package:get/get.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';

class VidcallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VidcallController>(() => VidcallController());
  }
}
