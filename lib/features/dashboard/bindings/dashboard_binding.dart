import 'package:get/get.dart';
import 'package:lumica_app/core/services/speech_service.dart';
import 'package:lumica_app/data/datasources/mood_remote_datasource.dart';
import 'package:lumica_app/data/datasources/note_remote_datasource.dart';
import 'package:lumica_app/data/repositories/chat_repository_impl.dart';
import 'package:lumica_app/data/repositories/mood_repository_impl.dart';
import 'package:lumica_app/data/repositories/note_repository_impl.dart';
import 'package:lumica_app/data/services/gemini_service.dart';
import 'package:lumica_app/domain/repositories/chat_repository.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:lumica_app/features/ai_chat/controllers/ai_chat_controller.dart';
import 'package:lumica_app/features/ai_chat/services/chat_history_manager.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/features/vidcall/controllers/vidcall_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dashboard Binding - Fixed Dependency Order
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Register Dashboard Controller first
    Get.lazyPut<DashboardController>(() => DashboardController());

    // 2. Register child tab controllers
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<VidcallController>(() => VidcallController());

    // 3. AI Chat Dependencies - MUST register services BEFORE controller
    Get.lazyPut(() => GeminiService(), fenix: true);
    Get.lazyPut<ChatRepositoryInterface>(
      () => ChatRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut(() => SpeechService(), fenix: true);
    Get.lazyPut(() => ChatHistoryManager(), fenix: true);

    // Then register AI Chat Controller with explicit dependencies
    Get.lazyPut<AiChatController>(
      () => AiChatController(
        geminiService: Get.find<GeminiService>(),
        repository: Get.find<ChatRepositoryInterface>(),
        speechService: Get.find<SpeechService>(),
        historyManager: Get.find<ChatHistoryManager>(),
      ),
      fenix: true,
    );

    // 4. Mood Feature Dependencies
    Get.lazyPut(
      () => MoodRemoteDataSource(Supabase.instance.client),
      fenix: true,
    );
    Get.lazyPut<MoodRepository>(
      () => MoodRepositoryImpl(Get.find()),
      fenix: true,
    );

    // 5. Journal Feature Dependencies
    Get.lazyPut(
      () => NoteRemoteDataSource(Supabase.instance.client),
      fenix: true,
    );
    Get.lazyPut<NoteRepository>(
      () => NoteRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<JournalController>(() => JournalController(), fenix: true);

    // 6. Profile Feature Dependencies
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
