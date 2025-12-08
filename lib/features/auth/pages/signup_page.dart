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
import 'package:lumica_app/routes/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Removed GlobalKey to prevent duplication issues during navigation
  late final AuthController controller;

  // Gesture recognizers
  late final TapGestureRecognizer _signInTapRecognizer;
  late final TapGestureRecognizer _termsTapRecognizer;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();

    _signInTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        FocusScope.of(context).unfocus(); // Clear focus before navigating
        Get.toNamed(AppRoutes.signin);
      };

    _termsTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.snackbar(
          'Terms & Conditions',
          'This page will be implemented soon',
          snackPosition: SnackPosition.BOTTOM,
        );
      };
  }

  @override
  void dispose() {
    _signInTapRecognizer.dispose();
    _termsTapRecognizer.dispose();
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
                                // Logo
                                Image.asset(AppImages.logo, width: 150.w),
                                SizedBox(height: 20.h),
                                // Title
                                Text(
                                  'Sign Up For Free',
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
                                  controller: controller.emailController,
                                  hintText: 'Enter your email...',
                                  prefixIconPath: AppIcon.emailDuotone,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    if (GetUtils.isEmail(value)) {
                                      controller.emailError.value = '';
                                    } else {
                                      controller.emailError.value =
                                          'Invalid Email Address!!';
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        !GetUtils.isEmail(value)) {
                                      controller.emailError.value =
                                          'Invalid Email Address!!';
                                      return '';
                                    }
                                    controller.emailError.value = '';
                                    return null;
                                  },
                                ),
                                Obx(
                                  () => ErrorMessageBox(
                                    message: controller.emailError.value,
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
                                    controller: controller.passwordController,
                                    hintText: 'Enter your password...',
                                    prefixIconPath: AppIcon.lock,
                                    obscureText:
                                        !controller.signUpPasswordVisible.value,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.signUpPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColors.greyText,
                                      ),
                                      onPressed: controller
                                          .signUpPasswordVisible
                                          .toggle,
                                    ),
                                    onChanged: (value) {
                                      if (value.length >= 6) {
                                        controller.passwordError.value = '';
                                      } else {
                                        controller.passwordError.value =
                                            'Password must be at least 6 characters';
                                      }
                                    },
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        controller.passwordError.value =
                                            'Password must be at least 6 characters';
                                        return '';
                                      }
                                      controller.passwordError.value = '';
                                      return null;
                                    },
                                  ),
                                ),
                                Obx(
                                  () => ErrorMessageBox(
                                    message: controller.passwordError.value,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                // Terms and Conditions
                                Obx(
                                  () => Row(
                                    children: [
                                      SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: Checkbox(
                                          value: controller.agreeToTerms.value,
                                          onChanged: (bool? newValue) {
                                            controller.agreeToTerms.value =
                                                newValue!;
                                          },
                                          activeColor: AppColors.vividOrange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'I Agree with the ',
                                            style: AppTextTheme
                                                .textTheme
                                                .bodyMedium,
                                            children: [
                                              TextSpan(
                                                text: 'Terms & Conditions',
                                                style: AppTextTheme
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.mossGreen,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          AppColors.mossGreen,
                                                    ),
                                                recognizer: _termsTapRecognizer,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                // Sign Up Button
                                Obx(
                                  () => PrimaryButton(
                                    text: 'Sign Up',
                                    onPressed: controller.agreeToTerms.value
                                        ? () {
                                            if (Form.of(context).validate()) {
                                              controller.signUp();
                                            }
                                          }
                                        : null,
                                  ),
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
                        // Sign In Link
                        Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: AppTextTheme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Sign In.',
                                style: AppTextTheme.textTheme.labelMedium,
                                recognizer: _signInTapRecognizer,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
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
