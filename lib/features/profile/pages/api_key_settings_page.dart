import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lumica_app/core/config/text_theme.dart';
import 'package:lumica_app/core/config/theme.dart';
import 'package:lumica_app/core/widgets/app_snackbar.dart';
import 'package:lumica_app/core/widgets/base_app_bar.dart';
import 'package:lumica_app/core/widgets/primary_button.dart';
import 'package:lumica_app/storage/secure_storage_service.dart';

/// API Key Settings Page
/// Allows users to configure their own Gemini API key
class ApiKeySettingsPage extends StatefulWidget {
  const ApiKeySettingsPage({super.key});

  @override
  State<ApiKeySettingsPage> createState() => _ApiKeySettingsPageState();
}

class _ApiKeySettingsPageState extends State<ApiKeySettingsPage> {
  final _apiKeyController = TextEditingController();
  final RxBool _isLoading = false.obs;
  final RxBool _hasApiKey = false.obs;
  final RxBool _showApiKey = false.obs;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await SecureStorageService.getUserApiKey();
    if (apiKey != null && apiKey.isNotEmpty) {
      _hasApiKey.value = true;
      _apiKeyController.text = apiKey;
    }
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();

    if (apiKey.isEmpty) {
      AppSnackbar.error('Please enter an API key');
      return;
    }

    // Basic validation - Gemini API keys usually start with 'AIza'
    if (!apiKey.startsWith('AIza')) {
      AppSnackbar.warning(
        'API key format looks unusual. Make sure it\'s correct.',
      );
    }

    _isLoading.value = true;

    try {
      await SecureStorageService.saveUserApiKey(apiKey);
      _hasApiKey.value = true;

      AppSnackbar.success('API key saved successfully!', title: 'Success');

      // Delay navigation to show snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (e) {
      AppSnackbar.error('Failed to save API key', title: 'Error');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _removeApiKey() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Remove API Key?',
          style: AppTextTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBrown,
          ),
        ),
        content: Text(
          'The app will use the default API key. You can add your key again anytime.',
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Remove',
              style: AppTextTheme.textTheme.titleSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SecureStorageService.deleteUserApiKey();
      _hasApiKey.value = false;
      _apiKeyController.clear();

      AppSnackbar.success('API key removed');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const BaseAppBar(title: 'Gemini API Key'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.skyBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.skyBlue,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Why add your own key?',
                            style: AppTextTheme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBrown,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• No usage limits or quota restrictions\n• Full control over your AI interactions\n• Free tier available from Google\n• Your conversations, your API',
                        style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkBrown.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // How to get API key
                Text(
                  'How to get your API key:',
                  style: AppTextTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),

                SizedBox(height: 12.h),

                _buildStep('1', 'Visit aistudio.google.com/apikey'),
                _buildStep('2', 'Sign in with Google account'),
                _buildStep('3', 'Create or copy your API key'),
                _buildStep('4', 'Paste it below'),

                SizedBox(height: 24.h),

                // API Key Input
                Text(
                  'Your API Key',
                  style: AppTextTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBrown,
                  ),
                ),

                SizedBox(height: 8.h),

                Obx(
                  () => TextField(
                    controller: _apiKeyController,
                    obscureText: !_showApiKey.value,
                    style: AppTextTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'AIza...',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showApiKey.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.darkBrown.withValues(alpha: 0.5),
                        ),
                        onPressed: () => _showApiKey.value = !_showApiKey.value,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.stoneGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.stoneGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.vividOrange,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Save Button
                Obx(
                  () => PrimaryButton(
                    text: _isLoading.value ? 'Saving...' : 'Save API Key',
                    onPressed: _isLoading.value ? null : _saveApiKey,
                    width: double.infinity,
                  ),
                ),

                // Remove button (if has API key)
                Obx(
                  () => _hasApiKey.value
                      ? Column(
                          children: [
                            SizedBox(height: 12.h),
                            TextButton(
                              onPressed: _removeApiKey,
                              child: Text(
                                'Remove API Key',
                                style: AppTextTheme.textTheme.titleSmall
                                    ?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: AppColors.vividOrange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: Text(
                text,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBrown.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
