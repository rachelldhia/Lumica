import 'package:get/get.dart';
import 'package:lumica_app/data/repositories/note_repository_impl.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';
import 'package:lumica_app/data/datasources/note_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoteRemoteDataSource(Supabase.instance.client));
    Get.lazyPut<NoteRepository>(() => NoteRepositoryImpl(Get.find()));
    Get.lazyPut<JournalController>(() => JournalController());
  }
}
