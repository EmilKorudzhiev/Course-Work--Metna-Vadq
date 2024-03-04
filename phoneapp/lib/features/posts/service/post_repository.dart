import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return PostRepository(api: api, storage: secureStorage);
});

class PostRepository {
  final Api _api;
  final SecureStorageManager _storage;

  PostRepository({required Api api, required SecureStorageManager storage}) : _api = api, _storage = storage;

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
    } catch (e){
      print("ERROR!!!!!!");
      print(e);
    }

    return null;
  }

}
