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
import 'package:lumica_app/data/datasources/profile_local_datasource.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/data/repositories/profile_repository_impl.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Initialize all child controllers since they're used in IndexedStack
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<VidcallController>(() => VidcallController());
    Get.lazyPut<AiChatController>(() => AiChatController());
    // Register NoteRepository for JournalController
    Get.lazyPut(() => NoteRemoteDataSource(Supabase.instance.client));
    Get.lazyPut<NoteRepository>(() => NoteRepositoryImpl(Get.find()));
    Get.lazyPut<JournalController>(() => JournalController());

    // Register ProfileRepository for ProfileController
    Get.lazyPut(() => ProfileRemoteDataSource(Supabase.instance.client));
    Get.lazyPut(() => ProfileLocalDataSource());
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        Get.find<ProfileRemoteDataSource>(),
        Get.find<ProfileLocalDataSource>(),
        Supabase.instance.client,
      ),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
