import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class jwt_service {
  static const String _tokenKey = 'jwt_token';

  final _secureStorage = FlutterSecureStorage();

  // Store the JWT token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Retrieve the JWT token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Check if the JWT token exists
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null;
  }

  // Delete the JWT token (e.g., on logout)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
