import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/routes/app_pages.dart';
import 'package:lumica_app/routes/app_routes.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
