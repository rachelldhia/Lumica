import 'package:get/get.dart';
import 'package:lumica_app/features/home/pages/home_page.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
  ];
}
