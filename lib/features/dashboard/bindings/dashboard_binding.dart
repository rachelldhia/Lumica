import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';

import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';
import 'package:lumica_app/data/repositories/note_repository_impl.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Initialize all child controllers since they're used in IndexedStack
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<VidcallController>(() => VidcallController());
    Get.lazyPut<AiChatController>(() => AiChatController());
    // Register NoteRepository for JournalController
    Get.lazyPut<NoteRepository>(() => NoteRepositoryImpl());
    Get.lazyPut<JournalController>(() => JournalController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}