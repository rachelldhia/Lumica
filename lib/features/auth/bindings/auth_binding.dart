import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/data/datasources/auth_remote_datasource.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/data/repositories/auth_repository_impl.dart';
import 'package:lumica_app/data/repositories/profile_repository_impl.dart';
import 'package:lumica_app/domain/repositories/auth_repository.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/features/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Get Supabase client
    final supabaseClient = Supabase.instance.client;

    // Create data sources
    final authDataSource = AuthRemoteDataSource(supabaseClient);
    final profileDataSource = ProfileRemoteDataSource(supabaseClient);

    // Create repositories
    final authRepository = AuthRepositoryImpl(authDataSource);
    final profileRepository = ProfileRepositoryImpl(
      profileDataSource,
      supabaseClient,
    );

    // Register repositories for global access
    Get.lazyPut<AuthRepository>(() => authRepository, fenix: true);
    Get.lazyPut<ProfileRepository>(() => profileRepository, fenix: true);

    // Register AuthController with both repositories
    Get.lazyPut(
      () => AuthController(authRepository, profileRepository),
      fenix: true,
    );
  }
}
