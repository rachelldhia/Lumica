import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/config/transitions.dart';
import 'package:lumica_app/core/translations/app_translations.dart';
import 'package:lumica_app/core/widgets/custom_error_widget.dart';
// import 'package:lumica_app/features/splash/controllers/splash_controller.dart'; // Unused
import 'package:lumica_app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global Error Handling
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorDetails: details);
  };

  // Lock orientation to portrait for better UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
          // Custom smooth transition
          customTransition: CustomTransitionBuilder(),
          transitionDuration: const Duration(milliseconds: 350),
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
