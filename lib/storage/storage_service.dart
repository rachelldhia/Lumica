import 'package:get_storage/get_storage.dart';

/// Local storage service for NON-SENSITIVE data
///
/// ⚠️ IMPORTANT: For sensitive data (auth tokens, passwords), use SecureStorageService instead!
/// This service stores data in plain text and should only be used for:
/// - User preferences (language, theme)
/// - Cache data
/// - Non-sensitive app state
class StorageService {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // ==================== App Preferences ====================

  /// Save selected language preference
  static Future<void> saveLanguage(String language) async {
    await _box.write(_Keys.selectedLanguage, language);
  }

  /// Get selected language preference
  static String? getLanguage() {
    return _box.read<String>(_Keys.selectedLanguage);
  }

  /// Save theme mode preference (light/dark)
  static Future<void> saveThemeMode(String mode) async {
    await _box.write(_Keys.themeMode, mode);
  }

  /// Get theme mode preference
  static String? getThemeMode() {
    return _box.read<String>(_Keys.themeMode);
  }

  /// Save onboarding completed status
  static Future<void> saveOnboardingCompleted(bool completed) async {
    await _box.write(_Keys.onboardingCompleted, completed);
  }

  /// Check if onboarding is completed
  static bool isOnboardingCompleted() {
    return _box.read<bool>(_Keys.onboardingCompleted) ?? false;
  }

  // ==================== Cache Management ====================

  /// Save last data sync timestamp
  static Future<void> saveLastSyncTime(DateTime time) async {
    await _box.write(_Keys.lastSyncTime, time.toIso8601String());
  }

  /// Get last data sync timestamp
  static DateTime? getLastSyncTime() {
    final timeStr = _box.read<String>(_Keys.lastSyncTime);
    return timeStr != null ? DateTime.tryParse(timeStr) : null;
  }

  /// Clear all cached data (keep preferences)
  static Future<void> clearCache() async {
    final language = getLanguage();
    final themeMode = getThemeMode();
    final onboardingDone = isOnboardingCompleted();

    await _box.erase();

    // Restore preferences
    if (language != null) await saveLanguage(language);
    if (themeMode != null) await saveThemeMode(themeMode);
    await saveOnboardingCompleted(onboardingDone);
  }

  /// Clear all data (including preferences)
  static Future<void> clearAll() async {
    await _box.erase();
  }
}

/// Storage keys (private)
abstract class _Keys {
  // ⚠️ DEPRECATED: Use SecureStorageService for auth tokens
  // static const String token = 'auth_token';

  static const String selectedLanguage = 'selected_language';
  static const String themeMode = 'theme_mode';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
}
