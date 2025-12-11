import 'package:get/get.dart';
import 'package:lumica_app/data/datasources/profile_local_datasource.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/data/repositories/profile_repository_impl.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/features/profile/controllers/personal_info_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    // Check if ProfileRepository is already registered
    if (!Get.isRegistered<ProfileRepository>()) {
      Get.lazyPut<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSource(Supabase.instance.client),
      );
      Get.lazyPut(() => ProfileLocalDataSource());
      Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(
          Get.find<ProfileRemoteDataSource>(),
          Get.find<ProfileLocalDataSource>(),
          Supabase.instance.client,
        ),
      );
    }

    Get.lazyPut<PersonalInfoController>(() => PersonalInfoController());
  }
}
