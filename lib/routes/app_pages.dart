import 'package:get/get.dart';
import 'package:lumica_app/features/auth/bindings/auth_binding.dart';
import 'package:lumica_app/features/auth/pages/signin_page.dart';
import 'package:lumica_app/features/auth/pages/signup_page.dart';
import 'package:lumica_app/features/home/bindings/home_binding.dart';
import 'package:lumica_app/features/home/pages/home_page.dart';
import 'package:lumica_app/features/onboarding/bindings/onboarding_binding.dart';
import 'package:lumica_app/features/onboarding/pages/onboarding_page.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignInPage(),
      binding: AuthBinding(),
    ),
  ];
}
