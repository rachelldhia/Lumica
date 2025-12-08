import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Page')));
  }
}
