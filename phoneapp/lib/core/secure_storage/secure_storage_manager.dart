import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorageManager>((ref) => SecureStorageManager());

class SecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> areTokensSet() async {
    return await _storage.containsKey(key: 'access_token') && await _storage.containsKey(key: 'refresh_token');
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> setIsAdmin(bool isAdmin) async {
    await _storage.write(key: 'is_admin', value: isAdmin.toString());
  }

  Future<bool> isUserAdmin() async {
    return await _storage.read(key: 'is_admin') == 'true';
  }

  Future<void> setUserId(int userId) async {
    await _storage.write(key: 'user_id', value: userId.toString());
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

}