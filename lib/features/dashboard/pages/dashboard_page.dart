import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/dashboard/controllers/dashboard_controller.dart';
import 'package:lumica_app/features/dashboard/widgets/dashboard_nav_bar.dart';
import 'package:lumica_app/routes/app_pages.dart';
import 'package:lumica_app/routes/app_routes.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetNavigator(
        key: Get.nestedKey(1), // Match the ID in the controller
        initialRoute: AppRoutes.home,
        onGenerateRoute: (settings) {
          final dashboardChildren = AppPages.pages
              .firstWhere((p) => p.name == AppRoutes.dashboard)
              .children;
          
          final targetRoute = dashboardChildren.firstWhere(
            (p) => p.name == settings.name,
            orElse: () => dashboardChildren.first, // Fallback to home
          );

          return GetPageRoute(
            settings: settings,
            page: targetRoute.page,
            binding: targetRoute.binding,
            transition: targetRoute.transition,
          );
        },
      ),
      bottomNavigationBar: const DashboardNavBar(),
    );
  }
}

