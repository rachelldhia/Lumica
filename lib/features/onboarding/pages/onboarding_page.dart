import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Center(
            child: Padding(
              padding: EdgeInsets.all(15.w),

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'It’s Ok Not To Be OKAY !!',
                      style: GoogleFonts.alegreya(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Welcome to the ultimate UI Kit!',
                      style: GoogleFonts.poppins(
                        fontSize: 34.sp,
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Your mindful mental health AI companion for everyone, anywhere 🍃',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    Image.asset(AppImages.lumiBot),
                    SizedBox(height: 60.h),
                    PrimaryButton(
                      width: 290.w,
                      text: 'Let Us Help You',
                      onPressed: controller.toSignUpPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
