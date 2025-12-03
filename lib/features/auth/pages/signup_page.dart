import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/constants/app_icon.dart';
import 'package:lumica_app/core/constants/app_images.dart';
import 'package:lumica_app/core/widgets/background_circle.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/features/auth/controllers/auth_controller.dart';
import 'package:lumica_app/features/auth/widgets/auth_text_field.dart';
import 'package:lumica_app/features/auth/widgets/error_message_box.dart';
import 'package:lumica_app/routes/app_routes.dart';

class SignUpPage extends GetView<AuthController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundCircle(
            position: CirclePosition.topCenter,
            circleColor: AppColors.amethyst,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      Center(child: Image.asset(AppImages.logo, width: 150.w)),
                      SizedBox(height: 15.h),
                      Center(
                        child: Text(
                          'Sign Up For Free',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Email TextFormField
                      _buildStyledTextFormField(
                        controller: controller.emailController,
                        hintText: 'Enter your email...',
                        prefixIconPath: AppImages.emailDuotone,
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
                          if (value == null || !GetUtils.isEmail(value)) {
                            controller.emailError.value =
                                'Invalid Email Address!!';
                            return '';
                          }
                          controller.emailError.value = '';
                          return null;
                        },
                      ),
                      Obx(() {
                        if (controller.emailError.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.vividOrange.withAlpha(50),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.vividOrange,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.vividOrange,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  controller.emailError.value,
                                  style: TextStyle(
                                    color: AppColors.vividOrange,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 15.h),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Password TextFormField
                      Obx(
                        () => _buildStyledTextFormField(
                          controller: controller.passwordController,
                          hintText: 'Enter your password...',
                          prefixIconPath: AppImages.lock,
                          obscureText: !controller.isPasswordVisible.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.greyText,
                            ),
                            onPressed: controller.isPasswordVisible.toggle,
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
                      Obx(() {
                        if (controller.passwordError.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.vividOrange.withAlpha(50),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.vividOrange,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.vividOrange,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  controller.passwordError.value,
                                  style: TextStyle(
                                    color: AppColors.vividOrange,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 15.h),
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
                                  controller.agreeToTerms.value = newValue!;
                                },
                                activeColor: AppColors.vividOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: 'I Agree with the ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.darkBrown,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.mossGreen,
                                        fontWeight: FontWeight.w600,
                                        decorationColor: AppColors.mossGreen,
                                        decoration: TextDecoration.underline,
                                      ),

                                      // Add recognizer for navigation if needed
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
                              ? controller.signUp
                              : null, // Disable button if terms not agreed
                        ),
                      ),
                      SizedBox(height: 15.h),
                      // Sign In Link
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
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
                                    Get.toNamed(AppRoutes.signin);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
