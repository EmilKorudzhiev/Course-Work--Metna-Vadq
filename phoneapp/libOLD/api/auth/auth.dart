import 'package:MetnaVadq/api/auth/secure_storage_manager.dart';
import 'package:MetnaVadq/utils/constants.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _api = Dio();
  final SecureStorageManager _secureStorage = SecureStorageManager();

  Future<void> login(String email, String password) async {
    final response = await _api.post(Constants.LOGIN_ENDPOINT, data: {
      'email': email,
      'password': password,
    });
    print(response);
    _secureStorage.setTokens(
        response.data['access_token'], response.data['refresh_token']);
  }

  Future<void> register(
      String firstName, String lastName, String email, String password) async {
    final response = await _api.post(Constants.LOGIN_ENDPOINT, data: {
      "first-name": firstName,
      "last-name": lastName,
      "email": email,
      "password": password
    });

    _secureStorage.setTokens(
        response.data['access_token'], response.data['refresh_token']);
  }

  Future<void> refreshToken() async {
    final refreshToken = _secureStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        final response = await _api.post(Constants.REFRESH_TOKEN_ENDPOINT,
            options: Options(headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $refreshToken",
            }));
        _secureStorage.setAccessToken(response.data['access_token']);
      } on DioException catch (e) {
        //manage exception if Refresh token expired prompt to log in again
        if ((e.response?.statusCode == 401) &&
            (e.response?.data['message' == 'JWT expired'])) {
          print("Session expired. Please log in again.");
        }
      }
    } else {
      //manage exception
      print("You arent logged in.");
    }
  }

  Future<dynamic> makeRequestWithTokenRefresh(
      Future<Response> Function() requestFunction) async {
    try {
      final Response response = await requestFunction();
      print(response.toString());
      return response;
    } on DioException catch (e) {
      if ((e.response?.statusCode == 401) &&
          (e.response?.data['message' == 'JWT expired'])) {
        await refreshToken();
        final Response response = await requestFunction();
        return response;
      }
    }
  }
}
