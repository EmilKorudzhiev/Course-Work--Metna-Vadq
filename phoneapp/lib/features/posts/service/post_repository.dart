import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final postRepositoryProvider = Provider<PostRepository>((ref) => PostRepository());


class PostRepository {
  final Dio _api = Dio();
  final SecureStorageManager _storage = SecureStorageManager();
  Future<Response?> getPosts(int pageNum, int pageSize) async {
    try {
      pageSize ??= 20;
      final response = await _api.get(Endpoints.GET_POSTS_PAGEABLE_ENDPOINT,
          options: Options(headers: {
            "Authorization": "Bearer ${await _storage.getAccessToken()}"
          }),
          queryParameters: {
            'page': pageNum,
            'page-size': pageSize,
          });
      print(response.data);
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e){
      print("ERROR!!!!!!");
      print(e);
    }

    return null;
  }

}
