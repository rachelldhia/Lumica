import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';

class PersonalInfoController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Selected values
  final RxString selectedAvatar = ''.obs;
  final RxInt selectedAvatarIndex = 0.obs;
  final RxString selectedLocation = 'Tokyo, Japan'.obs;
  final RxString selectedGender = 'Female'.obs;

  // Password visibility
  final RxBool isPasswordVisible = false.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  final Rxn<File> uploadedAvatar = Rxn<File>();

  // Loading state
  final RxBool isLoading = false.obs;

  // Form validation
  final RxString usernameError = ''.obs;
  final RxString passwordError = ''.obs;

  // Available locations
  final List<String> locations = [
    'Tokyo, Japan',
    'Jakarta, Indonesia',
    'Seoul, South Korea',
    'Bangkok, Thailand',
    'Singapore',
    'Manila, Philippines',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with current user data
    usernameController.text = 'Liliu';
    passwordController.text = 'password123'; // Store actual password

    // Add listeners for validation
    usernameController.addListener(_validateUsername);
    passwordController.addListener(_validatePassword);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Validation methods
  void _validateUsername() {
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      usernameError.value = 'Username cannot be empty';
    } else if (username.length < 3) {
      usernameError.value = 'Username must be at least 3 characters';
    } else {
      usernameError.value = '';
    }
  }

  void _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'Password cannot be empty';
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Update avatar
  void updateAvatar(int index) {
    selectedAvatarIndex.value = index;
    // Clear uploaded avatar when selecting predefined avatar
    uploadedAvatar.value = null;
  }

  // Upload custom avatar
  Future<void> uploadCustomAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        uploadedAvatar.value = File(pickedFile.path);
        // Set index to -1 to indicate custom avatar is selected
        selectedAvatarIndex.value = -1;

        Get.snackbar(
          'Success',
          'Avatar uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.vividOrange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload avatar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Show location selection dialog
  void showLocationDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Select Location',
                style: AppTextTheme.textTheme.titleLarge?.copyWith(
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 20.h),

              // Location options
              ...locations.map(
                (location) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Obx(
                    () => _buildLocationOption(
                      location,
                      selectedLocation.value == location,
                      () => updateLocation(location),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vividOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: AppTextTheme.textTheme.titleMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption(
    String location,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.vividOrange
              : AppColors.stoneGray.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.vividOrange
                : AppColors.stoneGray.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                location,
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.darkBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.whiteColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  // Update location
  void updateLocation(String? location) {
    if (location != null) {
      selectedLocation.value = location;
    }
  }

  // Update gender
  void updateGender(String gender) {
    selectedGender.value = gender;
  }

  // Save settings
  Future<void> saveSettings() async {
    // Validate all fields
    _validateUsername();
    _validatePassword();

    if (usernameError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fix all errors before saving',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual save logic here
      // - Upload avatar to storage if uploadedAvatar is not null
      // - Update user profile with new username
      // - Update password if changed
      // - Update location and gender preferences

      isLoading.value = false;

      Get.back();
      Get.snackbar(
        'Success',
        'Personal information updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.vividOrange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
