import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/routes/app_pages.dart';
import 'package:lumica_app/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp is the true root to ensure GetX stability
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      // Provide a basic theme initially (will be overridden in builder)
      theme: ThemeData.light(),
      builder: (context, child) {
        // Initialize ScreenUtil and Apply Theme inside the App context
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, _) {
            return Theme(
              // Apply the custom text theme which uses .sp
              // This is safe because ScreenUtil is initialized above this Theme
              data: ThemeData(
                textTheme: AppTextTheme.textTheme,
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors
                    .deepPurple, // Example, matching previous implicit defaults
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
