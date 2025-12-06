import 'package:get/get.dart';
import 'package:lumica_app/features/ai_chat/bindings/ai_chat_binding.dart';
import 'package:lumica_app/features/ai_chat/pages/ai_chat_page.dart';
import 'package:lumica_app/features/auth/bindings/auth_binding.dart';
import 'package:lumica_app/features/auth/pages/signin_page.dart';
import 'package:lumica_app/features/auth/pages/signup_page.dart';
import 'package:lumica_app/features/dashboard/bindings/dashboard_binding.dart';
import 'package:lumica_app/features/dashboard/pages/dashboard_page.dart';
import 'package:lumica_app/features/home/bindings/home_binding.dart';
import 'package:lumica_app/features/home/pages/home_page.dart';
import 'package:lumica_app/features/journal/bindings/journal_binding.dart';
import 'package:lumica_app/features/journal/pages/journal_page.dart';
import 'package:lumica_app/features/onboarding/bindings/onboarding_binding.dart';
import 'package:lumica_app/features/onboarding/pages/onboarding_page.dart';
import 'package:lumica_app/features/profile/bindings/profile_binding.dart';
import 'package:lumica_app/features/profile/pages/profile_page.dart';
import 'package:lumica_app/features/session/bindings/session_binding.dart';
import 'package:lumica_app/features/session/pages/session_page.dart';
import 'package:lumica_app/features/splash/bindings/splash_binding.dart';
import 'package:lumica_app/features/splash/pages/splash_page.dart';
import 'package:lumica_app/features/vidcall/bindings/vidcall_binding.dart';
import 'package:lumica_app/features/vidcall/pages/vidcall_page.dart';
import 'package:lumica_app/routes/app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: AppRoutes.dashboard,
        page: () => const DashboardPage(),
        binding: DashboardBinding(),
        children: [
          GetPage(
            name: AppRoutes.home,
            page: () => const HomePage(),
            binding: HomeBinding(),
          ),
          GetPage(
            name: AppRoutes.vidcall,
            page: () => const VidcallPage(),
            binding: VidcallBinding(),
          ),
          GetPage(
            name: AppRoutes.aiChat,
            page: () => const AiChatPage(),
            binding: AiChatBinding(),
          ),
          GetPage(
            name: AppRoutes.journal,
            page: () => const JournalPage(),
            binding: JournalBinding(),
          ),
          GetPage(
            name: AppRoutes.profile,
            page: () => const ProfilePage(),
            binding: ProfileBinding(),
          ),
        ]),
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
    GetPage(
      name: AppRoutes.session,
      page: () => const SessionPage(),
      binding: SessionBinding(),
    ),
  ];
}
