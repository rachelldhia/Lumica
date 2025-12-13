import 'package:get/get.dart';
import 'package:lumica_app/data/datasources/mood_remote_datasource.dart';
import 'package:lumica_app/data/repositories/mood_repository_impl.dart';
import 'package:lumica_app/domain/repositories/mood_repository.dart';
import 'package:lumica_app/features/mood_track/controllers/mood_track_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoodRemoteDataSource(Supabase.instance.client));
    Get.lazyPut<MoodRepository>(() => MoodRepositoryImpl(Get.find()));
    Get.lazyPut<MoodTrackController>(() => MoodTrackController());
  }
}
