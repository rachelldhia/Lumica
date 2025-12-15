import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/supabase_config.dart';
import 'package:lumica_app/core/controllers/network_controller.dart';
import 'package:lumica_app/data/datasources/auth_remote_datasource.dart';
import 'package:lumica_app/data/datasources/profile_local_datasource.dart';
import 'package:lumica_app/data/datasources/profile_remote_datasource.dart';
import 'package:lumica_app/data/repositories/auth_repository_impl.dart';
import 'package:lumica_app/data/repositories/profile_repository_impl.dart';
import 'package:lumica_app/domain/repositories/auth_repository.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/features/auth/controllers/auth_controller.dart';
// import 'package:lumica_app/features/dashboard/controllers/network_controller.dart'; // Deleted
import 'package:lumica_app/routes/app_routes.dart';
import 'package:lumica_app/storage/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  // Loading state for UI
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize services
    _initServices();

    // Start network monitoring
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }

  /// Initialize all core services and dependencies
  Future<void> _initServices() async {
    try {
      // 1. Load Environment Variables
      await dotenv.load(fileName: ".env");

      // 2. Initialize Core Services (Parallel)
      await Future.wait([
        // Supabase
        Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
        ),
        // Local Storage
        StorageService.init(),
      ]);

      // 3. Initialize Global Controllers & Dependencies
      _initDependencies();

      // 4. Minimum Splash Delay (for smooth animation)
      await Future.delayed(const Duration(milliseconds: 1000));

      // 5. Check Auth & Redirect
      _checkAuthAndRedirect();
    } catch (e, stack) {
      debugPrint('❌ Initialization Error: $e');
      debugPrint(stack.toString());
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  void _initDependencies() {
    // Network Controller (Global)
    Get.put(NetworkController(), permanent: true);

    // --- Auth Dependencies (Global for Logout/Session management) ---
    final supabaseClient = Supabase.instance.client;

    // Data Sources
    final authDataSource = AuthRemoteDataSource(supabaseClient);
    final profileRemoteDataSource = ProfileRemoteDataSource(supabaseClient);
    final profileLocalDataSource = ProfileLocalDataSource();

    // Repositories
    final authRepository = AuthRepositoryImpl(authDataSource);
    final profileRepository = ProfileRepositoryImpl(
      profileRemoteDataSource,
      profileLocalDataSource,
      supabaseClient,
    );

    // Register Repositories (Available globally)
    Get.put<AuthRepository>(authRepository, permanent: true);
    Get.put<ProfileRepository>(profileRepository, permanent: true);

    // Register AuthController (Permanent to handle logout anywhere)
    Get.put<AuthController>(
      AuthController(authRepository, profileRepository),
      permanent: true,
    );
  }

  /// Check if user has an active Supabase session
  Future<void> _checkAuthAndRedirect() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // Pre-load user data if possible
        await Get.find<AuthController>().loadCurrentUser();
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    } catch (e) {
      debugPrint('Splash auth check error: $e');
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
