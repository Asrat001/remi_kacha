import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();
  static const _dbPasswordKey = 'DB_ENCRYPTION_PASSWORD';

  // Set a password
  static Future<void> saveDbPassword(String password) async {
    await _storage.write(key: _dbPasswordKey, value: password);
  }

  // Get the saved password
  static Future<String?> getDbPassword() async {
    return await _storage.read(key: _dbPasswordKey);
  }

  // Only for development — to clear password
  static Future<void> clearDbPassword() async {
    await _storage.delete(key: _dbPasswordKey);
  }
}
