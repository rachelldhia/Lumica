import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/background_circle.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/onboarding/controllers/onboarding_controller.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.amethyst,
      body: Stack(
        children: [
          BackgroundCircle(
            position: CirclePosition.centerLeft,
            circleColor: AppColors.circlePurple.withAlpha(100),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 1),
                            Text(
                              "It's Ok Not To Be OKAY !!",
                              style: AppTextTheme.textTheme.displayLarge
                                  ?.copyWith(color: AppColors.whiteColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Welcome to Lumica!',
                              style: AppTextTheme.textTheme.displaySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Your mindful mental health AI companion for everyone, anywhere 🍃',
                              style: AppTextTheme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.blackColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30.h),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 250.h),
                              child: Image.asset(
                                AppImages.lumiRobot,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(flex: 2),
                            PrimaryButton(
                              width: 290.w,
                              text: 'Let Us Help You',
                              onPressed: controller.toSignUpPage,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
