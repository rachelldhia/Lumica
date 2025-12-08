import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/background_circle.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/auth/controllers/auth_controller.dart';
import 'package:lumica_app/features/auth/widgets/auth_text_field.dart';
import 'package:lumica_app/features/auth/widgets/error_message_box.dart';
import 'package:lumica_app/features/auth/widgets/social_login_button.dart';
import 'package:lumica_app/routes/app_routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Removed GlobalKey to prevent duplication issues during navigation
  late final AuthController controller;

  // Gesture recognizers
  late final TapGestureRecognizer _signUpTapRecognizer;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();

    _signUpTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        FocusScope.of(context).unfocus(); // Clear focus before navigating
        Get.toNamed(AppRoutes.signup);
      };
  }

  @override
  void dispose() {
    _signUpTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            BackgroundCircle(
              position: CirclePosition.topCenter,
              circleColor: AppColors.amethyst,
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        // No key needed, we use Form.of(context) via Builder
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Builder(
                          builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 40.h),
                                // Lumi Mascot
                                Image.asset(
                                  AppImages.logo,
                                  width: 120.w,
                                  height: 120.h,
                                ),
                                SizedBox(height: 20.h),
                                // Title
                                Text(
                                  'Sign In To Lumica',
                                  style: AppTextTheme.textTheme.displayMedium,
                                ),
                                SizedBox(height: 30.h),
                                // Email Address Label
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email Address',
                                    style: AppTextTheme.textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // Email TextFormField
                                AuthTextField(
                                  controller: controller.signInEmailController,
                                  hintText: 'kentudbadoag@gmail.com',
                                  prefixIconPath: AppIcon.emailDuotone,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    if (GetUtils.isEmail(value)) {
                                      controller.signInEmailError.value = '';
                                    } else {
                                      controller.signInEmailError.value =
                                          'Invalid Email Address!!';
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        !GetUtils.isEmail(value)) {
                                      controller.signInEmailError.value =
                                          'Invalid Email Address!!';
                                      return '';
                                    }
                                    controller.signInEmailError.value = '';
                                    return null;
                                  },
                                ),
                                Obx(
                                  () => ErrorMessageBox(
                                    message: controller.signInEmailError.value,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                // Password Label
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: AppTextTheme.textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // Password TextFormField
                                Obx(
                                  () => AuthTextField(
                                    controller:
                                        controller.signInPasswordController,
                                    hintText: 'Enter your password...',
                                    prefixIconPath: AppIcon.lock,
                                    obscureText:
                                        !controller.signInPasswordVisible.value,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.signInPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColors.greyText,
                                      ),
                                      onPressed: controller
                                          .signInPasswordVisible
                                          .toggle,
                                    ),
                                    onChanged: (value) {
                                      if (value.length >= 6) {
                                        controller.signInPasswordError.value =
                                            '';
                                      } else {
                                        controller.signInPasswordError.value =
                                            'Password must be at least 6 characters';
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        controller.signInPasswordError.value =
                                            'Password must be at least 6 characters';
                                        return '';
                                      }
                                      controller.signInPasswordError.value = '';
                                      return null;
                                    },
                                  ),
                                ),
                                Obx(
                                  () => ErrorMessageBox(
                                    message:
                                        controller.signInPasswordError.value,
                                  ),
                                ),
                                SizedBox(height: 25.h),
                                // Sign In Button
                                PrimaryButton(
                                  text: 'Sign In',
                                  onPressed: () {
                                    if (Form.of(context).validate()) {
                                      controller.signIn();
                                    }
                                  },
                                  icon: Image.asset(
                                    AppIcon.arrowRight,
                                    width: 20.w,
                                    height: 20.h,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 35.h),
                                // Social Login Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SocialLoginButton(
                                      iconPath: AppIcon.facebook,
                                      onPressed: controller.signInWithFacebook,
                                    ),
                                    SizedBox(width: 15.w),
                                    SocialLoginButton(
                                      iconPath: AppIcon.google,
                                      onPressed: controller.signInWithGoogle,
                                    ),
                                    SizedBox(width: 15.w),
                                    SocialLoginButton(
                                      iconPath: AppIcon.instagram,
                                      onPressed: controller.signInWithInstagram,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const Spacer(),
                        // Don't have an account? Sign Up
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextTheme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Sign Up.',
                                style: AppTextTheme.textTheme.labelMedium,
                                recognizer: _signUpTapRecognizer,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Forgot Password Link
                        TextButton(
                          onPressed: controller.forgotPassword,
                          child: Text(
                            'Forgot Password',
                            style: AppTextTheme.textTheme.labelMedium,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
