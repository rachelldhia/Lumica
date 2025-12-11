import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/domain/repositories/profile_repository.dart';
import 'package:lumica_app/features/profile/bindings/personal_info_binding.dart';
import 'package:lumica_app/features/profile/pages/personal_info_page.dart';
import 'package:lumica_app/routes/app_routes.dart';
import 'package:lumica_app/storage/storage_service.dart';

class ProfileController extends GetxController {
  // Dependencies
  final ProfileRepository _profileRepository = Get.find();

  // User data
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userLocation = ''.obs;
  final RxString userAvatarUrl = ''.obs;

  // Settings state
  final RxBool notificationsEnabled = true.obs;
  final RxString selectedLanguage = 'English (EN)'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadPreferences();
  }

  // Refresh profile data (public method to be called from other controllers)
  Future<void> refreshProfile() async {
    await _loadUserData();
  }

  // Load user data from Supabase Profile table
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';

      // Fetch profile data from repository
      final result = await _profileRepository.getProfile(user.id);

      result.fold(
        (failure) {
          debugPrint('❌ Failed to load profile for UI: ${failure.message}');
          // Fallback to auth metadata if profile fetch fails
          _loadFromAuthMetadata(user);
        },
        (profile) {
          debugPrint('✅ Profile loaded from Repo: ${profile.username}');
          debugPrint('🖼️ Avatar URL: ${profile.avatarUrl}');

          userName.value =
              profile.username ??
              _formatUsername(user.email?.split('@').first ?? 'User');
          userAvatarUrl.value = profile.avatarUrl ?? '';
          userLocation.value = 'Tokyo, Japan'; // Placeholder until added to DB
        },
      );
    }
  }

  void _loadFromAuthMetadata(User user) {
    String username = user.userMetadata?['name'] as String? ?? '';
    if (username.isEmpty && user.email != null) {
      username = user.email!.split('@').first;
      username = _formatUsername(username);
    }
    userName.value = username.isNotEmpty ? username : 'User';
  }

  // Format username: replace separators with spaces and capitalize
  String _formatUsername(String username) {
    // Replace common separators with spaces
    String formatted = username
        .replaceAll('.', ' ')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    // Capitalize first letter of each word
    return formatted
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  // Load preferences from StorageService
  void _loadPreferences() {
    // Language Handling
    final savedLanguage = StorageService.getLanguage();

    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedLanguage.value == 'English (EN)') {
          Get.updateLocale(const Locale('en', 'EN'));
        } else {
          Get.updateLocale(const Locale('id', 'ID'));
        }
      });
    } else {
      // Auto-detect system language
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale?.languageCode == 'id') {
        selectedLanguage.value = 'Indonesian (ID)';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.updateLocale(const Locale('id', 'ID'));
        });
      } else {
        selectedLanguage.value = 'English (EN)';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.updateLocale(const Locale('en', 'EN'));
        });
      }
    }
  }

  // Navigate to notifications settings
  void navigateToNotifications() {
    AppSnackbar.info(
      'Navigate to notifications settings',
      title: 'Notifications',
    );
  }

  // Navigate to personal information
  void navigateToPersonalInfo() {
    Get.to(
      () => const PersonalInfoPage(),
      binding: PersonalInfoBinding(),
      transition: Transition.rightToLeft,
    );
  }

  // Navigate to language selection
  void navigateToLanguageSelection() {
    // Temp variable for dialog state
    final tempSelectedLanguage = selectedLanguage.value.obs;

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
                'languageDialog.title'.tr,
                style: AppTextTheme.textTheme.titleLarge?.copyWith(
                  // color: AppColors.darkBrown, // Use theme color
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 20.h),

              // English option
              Obx(
                () => _buildLanguageOption(
                  'English (EN)',
                  tempSelectedLanguage.value == 'English (EN)',
                  () => tempSelectedLanguage.value = 'English (EN)',
                ),
              ),

              SizedBox(height: 12.h),

              // Indonesian option
              Obx(
                () => _buildLanguageOption(
                  'Indonesian (ID)',
                  tempSelectedLanguage.value == 'Indonesian (ID)',
                  () => tempSelectedLanguage.value = 'Indonesian (ID)',
                ),
              ),

              SizedBox(height: 24.h),

              // Close button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    _applyLanguage(tempSelectedLanguage.value);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vividOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'common.done'.tr,
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

  Widget _buildLanguageOption(
    String language,
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
                language,
                style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppColors.whiteColor
                      : null, // Use theme color when not selected
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

  void _applyLanguage(String language) async {
    selectedLanguage.value = language;

    // Update locale
    if (language == 'English (EN)') {
      Get.updateLocale(const Locale('en', 'EN'));
    } else {
      Get.updateLocale(const Locale('id', 'ID'));
    }

    // Save preference using StorageService
    await StorageService.saveLanguage(language);
  }

  // Logout with confirmation
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              LoadingUtil.show(message: 'Logging out...');
              try {
                await Supabase.instance.client.auth.signOut();
                LoadingUtil.hide();
                AppSnackbar.success('You have been logged out');
                Get.offAllNamed(AppRoutes.signin);
              } catch (e) {
                LoadingUtil.hide();
                AppSnackbar.error(
                  'Failed to log out. Please try again.',
                  title: 'Error',
                );
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
