import 'package:get_storage/get_storage.dart';
import 'package:lumica_app/features/auth/data/models/user_model.dart';

class ProfileLocalDataSource {
  final GetStorage _box = GetStorage();
  final String _key = 'cached_profile';

  /// Cache user profile
  Future<void> cacheProfile(UserModel user) async {
    await _box.write(_key, user.toJson());
  }

  /// Get cached profile
  UserModel? getLastProfile() {
    final json = _box.read<Map<String, dynamic>>(_key);
    if (json != null) {
      return UserModel.fromJson(json);
    }
    return null;
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _box.remove(_key);
  }
}
