import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/widgets/keep_alive_wrapper.dart';
import 'package:lumica_app/features/ai_chat/pages/ai_chat_page.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/dashboard/widgets/dashboard_nav_bar.dart';
import 'package:lumica_app/features/home/pages/home_page.dart';
import 'package:lumica_app/features/journal/pages/journal_page.dart';
import 'package:lumica_app/features/profile/pages/profile_page.dart';
import 'package:lumica_app/features/vidcall/pages/vidcall_page.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          KeepAliveWrapper(child: HomePage()),
          KeepAliveWrapper(child: VidcallPage()),
          KeepAliveWrapper(child: AiChatPage()),
          KeepAliveWrapper(child: JournalPage()),
          KeepAliveWrapper(child: ProfilePage()),
        ],
      ),
      bottomNavigationBar: const DashboardNavBar(),
    );
  }
}
