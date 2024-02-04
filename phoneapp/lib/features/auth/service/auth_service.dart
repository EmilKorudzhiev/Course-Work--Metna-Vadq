import 'package:MetnaVadq/assets/constants.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/features/auth/models/login_request.dart';
import 'package:MetnaVadq/features/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final Dio _api = Dio();
  final SecureStorageManager _secureStorage = SecureStorageManager();

  Future<bool> isLoggedIn() async {
    if(await _secureStorage.areTokensSet()){
      return true;
    }
    return false;
  }

  Future<void> logIn(LoginRequest loginRequest) async {
    try {
    final response = await _api.post(Endpoints.LOGIN_ENDPOINT, data: {
      'email': loginRequest.email,
      'password': loginRequest.password,
    });
    print(response);
    _secureStorage.setTokens(
        response.data['access_token'], response.data['refresh_token']);
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



}