import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data using platform-specific encryption
///
/// Uses Keychain on iOS, EncryptedSharedPreferences on Android
/// All data is encrypted at rest
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ==================== Auth Tokens ====================

  /// Save authentication token securely
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _Keys.authToken, value: token);
  }

  /// Retrieve authentication token
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: _Keys.authToken);
  }

  /// Delete authentication token
  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: _Keys.authToken);
  }

  // ==================== Refresh Tokens ====================

  /// Save refresh token securely
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _Keys.refreshToken, value: token);
  }

  /// Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _Keys.refreshToken);
  }

  /// Delete refresh token
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _Keys.refreshToken);
  }

  // ==================== User Credentials (Optional) ====================

  /// Save user email (if remember me is enabled)
  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _Keys.userEmail, value: email);
  }

  /// Retrieve saved user email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _Keys.userEmail);
  }

  /// Delete saved user email
  static Future<void> deleteUserEmail() async {
    await _storage.delete(key: _Keys.userEmail);
  }

  // ==================== Biometric Preference ====================

  /// Save biometric authentication preference
  static Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _Keys.biometricEnabled,
      value: enabled.toString(),
    );
  }

  /// Check if biometric authentication is enabled
  static Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _Keys.biometricEnabled);
    return value == 'true';
  }

  /// Delete biometric preference
  static Future<void> deleteBiometricPreference() async {
    await _storage.delete(key: _Keys.biometricEnabled);
  }

  // ==================== User API Key ====================

  /// Get user's custom API key (for Gemini)
  static Future<String?> getUserApiKey() async {
    return await _storage.read(key: _Keys.userApiKey);
  }

  /// Save user's custom API key (for Gemini)
  static Future<void> saveUserApiKey(String apiKey) async {
    await _storage.write(key: _Keys.userApiKey, value: apiKey);
  }

  /// Delete user's custom API key
  static Future<void> deleteUserApiKey() async {
    await _storage.delete(key: _Keys.userApiKey);
  }

  // ==================== Clear All ====================

  /// Clear all secure data (use on logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if secure storage is available on this device
  static Future<bool> isAvailable() async {
    try {
      await _storage.read(key: 'test');
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Storage keys (private)
abstract class _Keys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userEmail = 'user_email';
  static const String biometricEnabled = 'biometric_enabled';
  static const String userApiKey = 'user_api_key';
}
