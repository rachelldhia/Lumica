import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/features/profile/controllers/profile_controller.dart';
import 'package:lumica_app/features/profile/widgets/location_selection_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalInfoController extends GetxController {
  // Dependencies
  late final ProfileRepository _profileRepository;

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

  // Loading state (local usage if needed, but we use LoadingUtil mostly)
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
    // Initialize dependencies
    if (Get.isRegistered<ProfileRepository>()) {
      _profileRepository = Get.find<ProfileRepository>();
    } else {
      // Fallback: This should ideally not happen if Binding is correct,
      // but if it does, we should probably throw or lazy put it here.
      // For now, let's assume binding logic in DashboardBinding covers it.
      // But if we are here via a separate route, we might need it.
      debugPrint(
        '⚠️ ProfileRepository not found in GetX. Checking bindings...',
      );
    }

    _loadUserData();

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

  Future<void> _loadUserData() async {
    isLoading.value = true;
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        if (!Get.isRegistered<ProfileRepository>()) {
          throw Exception('ProfileRepository not initialized');
        }

        final result = await _profileRepository.getProfile(user.id);
        result.fold(
          (failure) {
            debugPrint('❌ Failed to load Personal Info: ${failure.message}');
            // Don't show error to user immediately on load to avoid nagging,
            // but log it. Maybe set a local error state UI if needed.
          },
          (userModel) {
            usernameController.text = userModel.username ?? '';
            if (userModel.avatarUrl != null &&
                userModel.avatarUrl!.isNotEmpty) {
              selectedAvatar.value = userModel.avatarUrl!;
              selectedAvatarIndex.value = -1; // Custom
            }
          },
        );
      }
    } catch (e) {
      debugPrint('❌ Unexpected error in _loadUserData: $e');
      AppSnackbar.error('Failed to load profile data', title: 'Error');
    } finally {
      isLoading.value = false;
    }
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
    // Password is optional (only if changing)
    if (password.isNotEmpty && password.length < 6) {
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

        AppSnackbar.success('Image selected successfully');
      }
    } catch (e) {
      AppSnackbar.error('Failed to select image: $e');
    }
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
    // Prevent double submission / spam click
    if (isLoading.value) return;

    // Validate all fields
    _validateUsername();
    _validatePassword();

    if (usernameError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      AppSnackbar.error(
        'Please fix all errors before saving',
        title: 'Validation Error',
      );
      return;
    }

    try {
      isLoading.value = true;
      LoadingUtil.show(message: 'Saving changes...');

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No user found');

      // 1. Update Username if changed
      final username = usernameController.text.trim();
      if (username.isNotEmpty) {
        final result = await _profileRepository.updateUsername(
          user.id,
          username,
        );
        if (result.isLeft) {
          throw Exception(result.left.message);
        }
      }

      // 2. Update Password if provided
      final password = passwordController.text;
      if (password.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: password),
        );
      }

      // 3. Update Avatar if provided
      if (uploadedAvatar.value != null) {
        final uploadResult = await _profileRepository.uploadAvatar(
          user.id,
          uploadedAvatar.value,
        );

        // Handle upload result
        await uploadResult.fold(
          (failure) async {
            // Just log error but don't stop the whole process
            debugPrint('Avatar upload failed: ${failure.message}');
            AppSnackbar.error('Avatar upload failed: ${failure.message}');
          },
          (url) async {
            // If upload success, update the profile record with new URL
            await _profileRepository.updateAvatarUrl(user.id, url);
          },
        );
      }

      LoadingUtil.hide();

      // Refresh profile data in ProfileController to update UI
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        await profileController.refreshProfile(); // Reload user data from DB
      }

      Get.back();
      AppSnackbar.success('Personal information updated successfully');
    } catch (e) {
      debugPrint('❌ Profile Update Error: $e');
      debugPrint('Stack trace: ${StackTrace.current}');

      LoadingUtil.hide();
      AppSnackbar.error(
        'Failed to save settings. ${e.toString().replaceAll('Exception:', '').trim()}',
        title: 'Error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show location selection dialog
  void showLocationDialog() {
    Get.dialog(
      LocationSelectionDialog(
        locations: locations,
        selectedLocation: selectedLocation.value,
        onLocationSelected: (location) {
          updateLocation(location);
        },
      ),
    );
  }
}
