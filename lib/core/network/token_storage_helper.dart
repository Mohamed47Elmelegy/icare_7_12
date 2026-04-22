import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageHelper {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_access_token';

  /// Saves the JWT token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the stored token, returns null if it doesn't exist
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes the token (called on Logout or 401 Unauthenticated)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
