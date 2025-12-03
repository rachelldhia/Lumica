import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/background_circle.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/auth/controllers/auth_controller.dart';
import 'package:lumica_app/features/auth/widgets/auth_text_field.dart';
import 'package:lumica_app/features/auth/widgets/error_message_box.dart';
import 'package:lumica_app/features/auth/widgets/social_login_button.dart';
import 'package:lumica_app/routes/app_routes.dart';

class SignInPage extends GetView<AuthController> {
  const SignInPage({super.key});

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
                        key: controller.signInFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
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
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            // Email Address Label
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Email TextFormField
                            AuthTextField(
                              controller: controller.signInEmailController,
                              hintText: 'kentudbadoag@gmail.com',
                              prefixIconPath: AppImages.emailIcon,
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
                                if (value == null || !GetUtils.isEmail(value)) {
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
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBrown,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Password TextFormField
                            Obx(
                              () => AuthTextField(
                                controller: controller.signInPasswordController,
                                hintText: 'Enter your password...',
                                prefixIconPath: AppImages.lockIcon,
                                obscureText:
                                    !controller.signInPasswordVisible.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.signInPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.greyText,
                                  ),
                                  onPressed:
                                      controller.signInPasswordVisible.toggle,
                                ),
                                onChanged: (value) {
                                  if (value.length >= 6) {
                                    controller.signInPasswordError.value = '';
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
                                message: controller.signInPasswordError.value,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            // Sign In Button
                            PrimaryButton(
                              text: 'Sign In',
                              onPressed: controller.signIn,
                              icon: Image.asset(
                                AppImages.arrowRight,
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
                                  iconPath: AppImages.facebookIcon,
                                  onPressed: controller.signInWithFacebook,
                                ),
                                SizedBox(width: 15.w),
                                SocialLoginButton(
                                  iconPath: AppImages.googleIcon,
                                  onPressed: controller.signInWithGoogle,
                                ),
                                SizedBox(width: 15.w),
                                SocialLoginButton(
                                  iconPath: AppImages.instagramIcon,
                                  onPressed: controller.signInWithInstagram,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const Spacer(),
                        // Don't have an account? Sign Up
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.darkBrown,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.vividOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.signup);
                                  },
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
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.vividOrange,
                              fontWeight: FontWeight.w600,
                            ),
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
