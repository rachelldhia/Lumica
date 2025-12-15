import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumica_app/core/utils/permission_helper.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:permission_handler/permission_handler.dart';
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
  // -1 means custom/uploaded, 0-4 means preset, default is 0
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
  final RxBool isLocating = false.obs;

  // Form validation
  final RxString usernameError = ''.obs;
  final RxString passwordError = ''.obs;

  // Available locations (Initial list, can be expanded)
  final RxList<String> locations = [
    'Tokyo, Japan',
    'Jakarta, Indonesia',
    'Seoul, South Korea',
    'Bangkok, Thailand',
    'Singapore',
    'Manila, Philippines',
    'New York, USA',
    'London, UK',
  ].obs;

  // Animation key for forcing animation replay on navigation
  final RxInt animationKey = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Increment animation key to force animation replay
    animationKey.value++;

    // Initialize dependencies
    if (Get.isRegistered<ProfileRepository>()) {
      _profileRepository = Get.find<ProfileRepository>();
    } else {
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
          },
          (userModel) {
            usernameController.text = userModel.username ?? '';

            // Load location
            if (userModel.location != null && userModel.location!.isNotEmpty) {
              selectedLocation.value = userModel.location!;
            }

            // Handle Avatar Display
            if (userModel.avatarUrl != null &&
                userModel.avatarUrl!.isNotEmpty) {
              selectedAvatar.value = userModel.avatarUrl!;

              if (userModel.avatarUrl!.startsWith('preset:')) {
                try {
                  final index = int.parse(userModel.avatarUrl!.split(':')[1]);
                  selectedAvatarIndex.value = index;
                } catch (e) {
                  selectedAvatarIndex.value = 0;
                }
              } else {
                selectedAvatarIndex.value = -1; // Custom/URL
              }
            } else {
              // Default if no avatar
              selectedAvatarIndex.value = 0;
            }
          },
        );
      }
    } catch (e) {
      debugPrint('❌ Unexpected error in _loadUserData: $e');
      AppSnackbar.error('personalInfo.loadFailed'.tr, title: 'common.error'.tr);
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
      // Check permission based on platform/version (simplified)
      // Check SDK version check if possible, or just try both
      // For now, on Android 13+ it's photos, below is storage
      // We'll let PermissionHelper handle the UI
      bool hasPermission = false;

      if (Platform.isAndroid) {
        // Try photos first (Android 13+)
        var status = await Permission.photos.status;
        if (status.isGranted) {
          hasPermission = true;
        } else {
          // If not granted, it might be Android < 13 requiring storage
          // Or Android 13 requiring photos
          // We'll try requesting photos if it's not permanently denied?
          // Actually, easiest is to just rely on PermissionHelper
          // tailored for the likely specific permission
          // Since we don't have device_info, we might assume modern
          if (await Permission.photos.request().isGranted) {
            hasPermission = true;
          } else if (await Permission.storage.request().isGranted) {
            // Fallback for older Android
            hasPermission = true;
          } else {
            // Check if permanently denied
            if (await Permission.photos.isPermanentlyDenied ||
                await Permission.storage.isPermanentlyDenied) {
              await PermissionHelper.requestPermission(
                Permission.photos, // Just trigger the helper dialog
                title: 'Gallery Permission',
                message: 'Access to photos is needed to upload an avatar.',
              );
              return;
            }
          }
        }
      } else {
        // iOS
        hasPermission = await PermissionHelper.requestPermission(
          Permission.photos,
          title: 'Photos Permission',
          message: 'Access to photos is needed to upload an avatar.',
        );
      }

      // If permission flow completed but we don't have permission, stop
      if (!hasPermission) {
        return;
      }

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

        AppSnackbar.success('personalInfo.imageSelected'.tr);
      }
    } catch (e) {
      AppSnackbar.error('personalInfo.imageSelectFailed'.tr);
    }
  }

  // Update location
  void updateLocation(String? location) {
    if (location != null) {
      selectedLocation.value = location;
    }
  }

  // Detect Location
  Future<void> detectLocation() async {
    isLocating.value = true;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.error('Location services are disabled.');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.error('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Get.dialog(
          AlertDialog(
            title: const Text('Location Required'),
            content: const Text(
              'Location permissions are permanently denied. Please enable them in settings to use this feature.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Geolocator.openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();

      // Decode to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city =
            place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
        final country = place.country ?? 'Unknown Country';
        final fullLocation = '$city, $country';

        selectedLocation.value = fullLocation;

        // Add to list if not exists
        if (!locations.contains(fullLocation)) {
          locations.insert(0, fullLocation);
        }

        AppSnackbar.success('Location detected: $fullLocation');
      }
    } catch (e) {
      debugPrint('Error detecting location: $e');
      AppSnackbar.error('Failed to detect location');
    } finally {
      isLocating.value = false;
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
      AppSnackbar.error('auth.unexpectedError'.tr, title: 'common.error'.tr);
      return;
    }

    try {
      isLoading.value = true;
      LoadingUtil.show(message: 'Saving changes...');

      // Timeout for operations to prevent hanging
      const timeout = Duration(seconds: 15);

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No user found');

      // 1. Update Username if changed
      final username = usernameController.text.trim();
      if (username.isNotEmpty) {
        final result = await _profileRepository
            .updateUsername(user.id, username)
            .timeout(timeout);
        if (result.isLeft) {
          throw Exception(result.left.message);
        }
      }

      // 2. Update Password if provided
      final password = passwordController.text;
      if (password.isNotEmpty) {
        await Supabase.instance.client.auth
            .updateUser(UserAttributes(password: password))
            .timeout(timeout);
      }

      // 3. Update Location
      if (selectedLocation.value.isNotEmpty) {
        await _profileRepository
            .updateLocation(user.id, selectedLocation.value)
            .timeout(timeout);
      }

      // 4. Update Avatar
      if (uploadedAvatar.value != null) {
        // CASE A: Custom Upload
        final uploadResult = await _profileRepository
            .uploadAvatar(user.id, uploadedAvatar.value)
            .timeout(timeout);

        await uploadResult.fold(
          (failure) async {
            debugPrint('Avatar upload failed: ${failure.message}');
            AppSnackbar.error('personalInfo.avatarUploadFailed'.tr);
          },
          (url) async {
            await _profileRepository
                .updateAvatarUrl(user.id, url)
                .timeout(timeout);
          },
        );
      } else if (selectedAvatarIndex.value != -1) {
        // CASE B: Preset Avatar selected
        final presetString = 'preset:${selectedAvatarIndex.value}';
        await _profileRepository
            .updateAvatarUrl(user.id, presetString)
            .timeout(timeout);
      }

      // Hide loading BEFORE refreshing profile to UI doesn't feel stuck
      LoadingUtil.hide();

      // Refresh profile data properly
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        // Fire and forget refresh so user isn't blocked?
        // Or wait continuously? Ideally wait, but with short timeout.
        try {
          await profileController.refreshProfile().timeout(
            const Duration(seconds: 5),
          );
        } catch (e) {
          debugPrint(
            '⚠️ Profile refresh timed out or failed, but save was successful.',
          );
        }
      }

      // Proceed back
      Get.back(); // Go back to profile page
      AppSnackbar.success('personalInfo.success'.tr);
    } catch (e) {
      debugPrint('❌ Profile Update Error: $e');
      debugPrint('Stack trace: ${StackTrace.current}');

      // Hide loading FIRST so it doesn't close the snackbar later
      LoadingUtil.hide();

      // If timeout
      if (e is TimeoutException) {
        AppSnackbar.error(
          'Connection timed out. Please check your internet.',
          title: 'common.error'.tr,
        );
      } else {
        AppSnackbar.error(
          'personalInfo.saveFailed'.tr,
          title: 'common.error'.tr,
        );
      }
    } finally {
      isLoading.value = false;
      // LoadingUtil.hide(); // Already handled above
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
