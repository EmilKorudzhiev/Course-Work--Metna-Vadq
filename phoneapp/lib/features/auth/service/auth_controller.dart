import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:MetnaVadq/features/auth/models/login_request.dart';
import 'package:MetnaVadq/features/auth/models/register_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthController>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return AuthController(api: api, secureStorage: secureStorage);
});

class AuthController with ChangeNotifier {
  final DioClient _api;
  final SecureStorageManager _secureStorage;

  AuthController({required DioClient api, required SecureStorageManager secureStorage}) : _api = api, _secureStorage = secureStorage;

  Future<bool> isLoggedIn() async {
    if(await _secureStorage.areTokensSet()){
      return true;
    }
    return false;
  }

  Future<void> logIn(LoginRequest loginRequest) async {
    try {
    final response = await _api.dio.post(Endpoints.LOGIN_ENDPOINT, data: {
      'email': loginRequest.email,
      'password': loginRequest.password,
    });
    print(response);
    _secureStorage.setTokens(
        response.data['access_token'], response.data['refresh_token']);
    _secureStorage.setIsAdmin(response.data['is_admin']);
    } on DioException catch (e) {
      /// TODO make it show snackbar when handling errors
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("fadsd")));
      throw e;
    }
    notifyListeners();
  }

  void signOut() {
    _secureStorage.clearTokens();
    notifyListeners();
  }

  Future<void> refreshToken() async {
    final refreshToken = _secureStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        final response = await _api.dio.post(Endpoints.REFRESH_TOKEN_ENDPOINT,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $refreshToken",
            }));
        _secureStorage.setAccessToken(response.data['access_token']);
      } on DioException catch (e) {
        //TODO manage exception if Refresh token expired prompt to log in again
        if ((e.response?.statusCode == 401) &&
            (e.response?.data['message' == 'JWT expired'])) {
          print("Session expired. Please log in again.");
        }
      }
    } else {
      //TODO manage exception
      print("You arent logged in.");
    }
  }

  Future<void> register(RegisterRequest registerRequest) async {
    try {
      final response = await _api.dio.post(Endpoints.REGISTER_ENDPOINT, data: {
        'first-name': registerRequest.firstName,
        'last-name': registerRequest.lastName,
        'email': registerRequest.email,
        'password': registerRequest.password,
      });
      print(response);
      _secureStorage.setTokens(
          response.data['access_token'], response.data['refresh_token']);
      _secureStorage.setIsAdmin(response.data['is_admin']);
    } on DioException catch (e) {
      throw e;
    }
    notifyListeners();
  }
}