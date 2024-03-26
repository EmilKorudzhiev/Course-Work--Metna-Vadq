import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<DioClient>((ref) {
  final secureStorageManager = ref.read(secureStorageProvider);
  return DioClient(storage: secureStorageManager);
});

class DioClient {
  Dio dio = Dio();
  final SecureStorageManager _storage;

  DioClient({required SecureStorageManager storage}) : _storage = storage {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {

            await refreshToken();

            e.requestOptions.headers['Authorization'] = 'Bearer ${await _storage.getAccessToken()}';

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
