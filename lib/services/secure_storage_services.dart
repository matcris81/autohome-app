import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // Save the token with the appropriate accessibility option
  Future<void> saveString(String key, String value) async {
    await _storage.write(
        key: key,
        value: value,
        iOptions: const IOSOptions(
            accessibility: KeychainAccessibility.first_unlock));
  }

  // Retrieve the token
  Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }
}
