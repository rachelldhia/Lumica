import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // --- Auth Token ---
  static Future<void> saveToken(String token) async {
    await _box.write(_Keys.token, token);
  }

  static String? getToken() {
    return _box.read<String>(_Keys.token);
  }

  static Future<void> clearToken() async {
    await _box.remove(_Keys.token);
  }

  // --- Settings ---
  static Future<void> saveLanguage(String language) async {
    await _box.write(_Keys.selectedLanguage, language);
  }

  static String? getLanguage() {
    return _box.read<String>(_Keys.selectedLanguage);
  }
}

abstract class _Keys {
  static const String token = 'auth_token';
  static const String selectedLanguage = 'selected_language';
}
