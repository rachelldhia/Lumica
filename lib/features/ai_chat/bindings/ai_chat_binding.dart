import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/data/services/gemini_service.dart';

class AiChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeminiService>(() => GeminiService());
    Get.lazyPut<AiChatController>(() => AiChatController());
  }
}
