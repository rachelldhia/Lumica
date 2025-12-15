import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
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
        AppSnackbar.info(
          'This page will be implemented soon',
          title: 'Terms & Conditions',
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                Image.asset(
                                  AppImages.lumicaLogo,
                                  width: 120.w,
                                  height: 120.h,
                                ),
                                SizedBox(height: 20.h),
                                // Title
                                Text(
                                  'auth.signUpForFree'.tr,
                                  style: AppTextTheme.textTheme.displayMedium,
                                ),
                                SizedBox(height: 30.h),
                                // Email Address Label
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'auth.emailAddress'.tr,
                                    style: AppTextTheme.textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // Email TextFormField
                                AuthTextField(
                                  controller: controller.emailController,
                                  hintText: 'auth.enterEmail'.tr,
                                  prefixIconPath: AppIcon.emailDuotone,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    if (GetUtils.isEmail(value)) {
                                      controller.emailError.value = '';
                                    } else {
                                      controller.emailError.value =
                                          'auth.invalidEmail'.tr;
                                    }
                                  },
                                  validator: (value) {
                                    final hasError =
                                        value == null ||
                                        !GetUtils.isEmail(value);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          controller.emailError.value = hasError
                                              ? 'auth.invalidEmail'.tr
                                              : '';
                                        });
                                    return hasError ? '' : null;
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
                                    'auth.password'.tr,
                                    style: AppTextTheme.textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // Password TextFormField
                                Obx(
                                  () => AuthTextField(
                                    controller: controller.passwordController,
                                    hintText: 'auth.passwordHint'.tr,
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
                                            'auth.passwordTooShort'.tr;
                                      }
                                    },
                                    validator: (value) {
                                      final hasError =
                                          value == null || value.length < 6;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            controller.passwordError.value =
                                                hasError
                                                ? 'auth.passwordTooShort'.tr
                                                : '';
                                          });
                                      return hasError ? '' : null;
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
                                            text: 'auth.agreeTerms'.tr,
                                            style: AppTextTheme
                                                .textTheme
                                                .bodyMedium,
                                            children: [
                                              TextSpan(
                                                text: 'auth.terms'.tr,
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
                                    text: 'auth.signUp'.tr,
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
                            text: 'auth.alreadyHaveAccount'.tr,
                            style: AppTextTheme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'auth.signIn'.tr,
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
