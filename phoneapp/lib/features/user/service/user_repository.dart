import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return UserRepository(api: api, storage: secureStorage);
});

class UserRepository {
  final DioClient _api;
  final SecureStorageManager _storage;

  UserRepository(
      {required DioClient api, required SecureStorageManager storage})
      : _api = api,
        _storage = storage;

  Future<Response?> getUserProfile(int? id) async {
    try {
      var userId;
      if (id == null) {
        userId = "";
      } else {
        userId = id.toString();
      }

      final response = await _api.dio.get(
        "${Endpoints.GET_USER_PROFILE}?userId=$userId",
        options: Options(headers: {
          "Authorization": "Bearer ${await _storage.getAccessToken()}"
        }),
      );

      print(response.toString());

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }

    return null;
  }

  Future<Response?> getUserPosts(int? id, int page, int limit) async {
    try {
      var userId;
      if (id == null) {
        userId = "";
      } else {
        userId = id.toString();
      }

      final response = await _api.dio.get(
        "${Endpoints.GET_USER_POSTS}?userId=?page-size=$limit&page=$page&user-id=$userId",
        options: Options(headers: {
          "Authorization": "Bearer ${await _storage.getAccessToken()}"
        }),
      );

      print(response.toString());

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }

    return null;
  }

  Future<Response?> followUser(int id) async {
    try {
      final response = _api.dio.put(
        "${Endpoints.FOLLOW_USER_ENDPOINT}/$id",
        options: Options(
            headers: {"Authorization": "Bearer ${await _storage.getAccessToken()}"}),
      );
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Response?> updateProfilePicture(String path) async{
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          path,
          contentType: MediaType.parse('image/jpeg'),
        ),
      });

      final response = await _api.dio.post(
        Endpoints.UPDATE_PROFILE_PICTURE_ENDPOINT,
        data: formData,
        options: Options(
            headers: {
              "Authorization": "Bearer ${await _storage.getAccessToken()}",
              "Content-Type": "multipart/form-data"
            }),
      );

      return response;

    } catch (e) {
      print(e);
      throw e;
    }
  }

}
