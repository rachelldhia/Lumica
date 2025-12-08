import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/splash/controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
