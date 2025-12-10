import 'package:get/get.dart';
import 'package:lumica_app/data/repositories/note_repository_impl.dart';
import 'package:lumica_app/domain/repositories/note_repository.dart';
import 'package:lumica_app/features/journal/controllers/journal_controller.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteRepository>(() => NoteRepositoryImpl());
    Get.lazyPut<JournalController>(() => JournalController());
  }
}
