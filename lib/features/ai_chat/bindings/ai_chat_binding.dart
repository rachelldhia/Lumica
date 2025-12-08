import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';

class AiChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiChatController>(() => AiChatController());
  }
}
