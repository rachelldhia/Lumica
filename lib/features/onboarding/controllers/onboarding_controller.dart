import 'package:get/get.dart';
import 'package:lumica_app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  void toSignUpPage() {
    Get.toNamed(AppRoutes.signup);
  }
}
