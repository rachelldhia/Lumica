import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/features/home/controllers/home_controller.dart';
import 'package:lumica_app/features/home/widgets/home_content.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      // The body is now just the HomeContent, which is scrollable.
      // The controller is automatically provided by the HomeBinding.
      body: SafeArea(
        child: HomeContent(controller: controller),
      ),
    );
  }
}
