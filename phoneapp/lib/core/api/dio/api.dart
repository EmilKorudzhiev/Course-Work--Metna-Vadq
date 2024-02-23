import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<Api>((ref) {
  final secureStorageManager = ref.read(secureStorageProvider);
  return Api(storage: secureStorageManager);
});

class Api {
  Dio dio = Dio();
  final SecureStorageManager _storage;

  Api({required SecureStorageManager storage}) : _storage = storage {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            await refreshToken();
            print("${_storage.getAccessToken()}");
            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] = 'Bearer ${_storage.getAccessToken()}';

            // Repeat the request with the updated header
            return handler.resolve(await dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> refreshToken() async {
    var refreshToken = await _storage.getRefreshToken();
    try {
      print(refreshToken);
      final response = await dio.post(Endpoints.REFRESH_TOKEN_ENDPOINT,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $refreshToken",
          }));
      _storage.setAccessToken(response.data['access_token']);
    } on DioException catch (e) {
      //manage exception if Refresh token expired prompt to log in again
      if ((e.response?.statusCode == 401) &&
          (e.response?.data['message' == 'JWT expired'])) {
        print("Session expired. Please log in again.");
      } else {
        //manage exception
        throw UnimplementedError("You arent logged in.");
      }
    }
  }
}
