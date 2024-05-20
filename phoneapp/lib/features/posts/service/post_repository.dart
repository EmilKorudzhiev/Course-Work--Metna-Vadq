import 'dart:io';

import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:MetnaVadq/features/posts/data/models/make_location_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

import '../data/models/make_post_request_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return PostRepository(api: api, storage: secureStorage);
});

class PostRepository {
  final DioClient _api;
  final SecureStorageManager _storage;

  PostRepository(
      {required DioClient api, required SecureStorageManager storage})
      : _api = api,
        _storage = storage;

  Future<Response?> getPosts(int pageNum, int pageSize) async {
    try {
      pageSize ??= 20;
      final response = await _api.dio.get(Endpoints.GET_POSTS_PAGEABLE_ENDPOINT,
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }),
          queryParameters: {
            'page': pageNum,
            'page-size': pageSize,
          });

      print(response);

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> getPost(int postId) async {
    try {
      final response = await _api.dio.get(
          "${Endpoints.GET_POST_ENDPOINT}/$postId",
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }));

      print(response);

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> getComments(int postId, int pageNum, int pageSize) async {
    try {
      pageSize ??= 20;
      final response = await _api.dio.get(
          "${Endpoints.GET_COMMENTS_PAGEABLE_ENDPOINT}?page-size=$pageSize&page=$pageNum&post-id=$postId",
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }));

      print(response);

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> likePost(int postId) async {
    try {
      final response = await _api.dio.put(
          "${Endpoints.LIKE_POST_ENDPOINT}/$postId",
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }));

      print(response);

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> addComment(int postId, String comment) async {
    try {
      final response = await _api.dio.post(
          Endpoints.GET_COMMENTS_PAGEABLE_ENDPOINT,
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }),
          data: {"fish-catch-id": postId, "text": comment});

      print(response);

      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> makePostRequest(
      File image, MakePostRequestModel request) async {
    try {
      String imageName = image.path.split('/').last;
      final data = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(
            image.path,
            filename: imageName,
            contentType: MediaType.parse('image/jpeg'),
          ),
          "request": MultipartFile.fromString(
            request.toJson(),
            contentType: MediaType.parse('application/json'),
          ),
        },
      );
      final response = await _api.dio.post(
        Endpoints.ADD_POST_ENDPOINT,
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}",
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> makeLocationRequest(
      File image, MakeLocationRequestModel request) async {
    try {
      String imageName = image.path.split('/').last;
      final data = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(
            image.path,
            filename: imageName,
            contentType: MediaType.parse('image/jpeg'),
          ),
          "request": MultipartFile.fromString(
            request.toJson(),
            contentType: MediaType.parse('application/json'),
          ),
        },
      );
      final response = _api.dio.post(
        Endpoints.ADD_LOCATION_ENDPOINT,
        options: Options(
          headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}",
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
  }

  Future<Response?> getLocation(int locationId) async {
    try {
      final response = await _api.dio.get(
          "${Endpoints.GET_LOCATION_ENDPOINT}/$locationId",
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }));
      print(response);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> deletePost(int postId) async {
    try {
      _api.dio.delete("${Endpoints.DELETE_POST_ENDPOINT}/$postId",
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }));
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
  }
}
