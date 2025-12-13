import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';

import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';
import 'package:lumica_app/data/repositories/note_repository_impl.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:lumica_app/data/datasources/note_remote_datasource.dart';
import 'package:lumica_app/data/datasources/mood_remote_datasource.dart';
import 'package:lumica_app/data/repositories/mood_repository_impl.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Initialize all child controllers since they're used in IndexedStack
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<VidcallController>(() => VidcallController());
    Get.lazyPut<AiChatController>(() => AiChatController());

    // Mood Feature Dependencies (for HomeController)
    Get.lazyPut(() => MoodRemoteDataSource(Supabase.instance.client));
    Get.lazyPut<MoodRepository>(() => MoodRepositoryImpl(Get.find()));

    // Journal Feature Dependencies
    // Using put (not lazyPut) because JournalPage is in PageView with KeepAliveWrapper
    // and needs controllers to be available immediately
    Get.put(NoteRemoteDataSource(Supabase.instance.client));
    Get.put<NoteRepository>(NoteRepositoryImpl(Get.find()));
    Get.put<JournalController>(JournalController());

    // Profile Feature Dependencies
    // ProfileController uses the Global ProfileRepository registered in Splash
    // We only need to provide ProfileController itself
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
