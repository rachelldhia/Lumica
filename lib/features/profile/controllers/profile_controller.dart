import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/utils/loading_util.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/features/profile/bindings/personal_info_binding.dart';
import 'package:lumica_app/features/profile/pages/personal_info_page.dart';
import 'package:lumica_app/routes/app_routes.dart';

class ProfileController extends GetxController {
  // User data
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userLocation = ''.obs;

  // Settings state
  final RxBool notificationsEnabled = true.obs;
  final RxString selectedLanguage = 'English (EN)'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadPreferences();
  }

  // Load user data from Supabase
  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';

      // Extract username from email (part before @) or use metadata name
      String username = user.userMetadata?['name'] as String? ?? '';

      if (username.isEmpty && user.email != null) {
        // Get part before @ from email
        username = user.email!.split('@').first;
        // Format username: replace dots/underscores with spaces and capitalize
        username = _formatUsername(username);
      }

      userName.value = username.isNotEmpty ? username : 'User';
    }
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

  // Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Language Handling
    // If key exists, use it. If not, try to match system locale.
    if (prefs.containsKey('selectedLanguage')) {
      selectedLanguage.value =
          prefs.getString('selectedLanguage') ?? 'English (EN)';
      if (selectedLanguage.value == 'English (EN)') {
        Get.updateLocale(const Locale('en', 'EN'));
      } else {
        Get.updateLocale(const Locale('id', 'ID'));
      }
    } else {
      // Auto-detect system language
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale?.languageCode == 'id') {
        selectedLanguage.value = 'Indonesian (ID)';
        Get.updateLocale(const Locale('id', 'ID'));
      } else {
        selectedLanguage.value = 'English (EN)';
        Get.updateLocale(const Locale('en', 'EN'));
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

    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
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
