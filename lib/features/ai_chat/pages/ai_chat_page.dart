import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';

class AiChatPage extends GetView<AiChatController> {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('AI Chat Page')));
  }
}
