import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:lumica_app/features/dashboard/controllers/network_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/config/supabase_config.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/translations/app_translations.dart';
import 'package:lumica_app/routes/app_pages.dart';
import 'package:lumica_app/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load connection strings from .env
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  await StorageService.init();

  // Initialize Global Network Controller
  Get.put(NetworkController(), permanent: true);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil first so it's ready for AppTheme which uses .sp
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.cupertino,
          initialRoute: AppPages.initial,
          getPages: AppPages.pages,

          // Translations
          translations: AppTranslations(),
          locale: const Locale('en', 'EN'), // Default language
          fallbackLocale: const Locale('en', 'EN'),

          // Theme
          // Now safe to use AppTheme because ScreenUtil is initialized
          theme: AppTheme.lightTheme(),
          themeMode: ThemeMode.light,

          localizationsDelegates: const [FlutterQuillLocalizations.delegate],
          builder: (context, child) {
            // Apply text scale factor clamping if needed, or other global builders
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
        );
      },
    );
  }
}
