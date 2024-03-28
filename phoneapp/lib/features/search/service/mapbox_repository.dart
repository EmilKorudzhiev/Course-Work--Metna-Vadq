import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapboxRepositoryProvider = Provider<MapboxRepository>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return MapboxRepository(api: api, storage: secureStorage);
});

class MapboxRepository {
  final DioClient _api;
  final SecureStorageManager _storage;

  MapboxRepository({required DioClient api, required SecureStorageManager storage})
      : _api = api,
        _storage = storage;

  Future<Response?> getSuggestion(String query) async {
    try {
      final response = await _api.dio.get(
        "https://api.mapbox.com/search/searchbox/v1/suggest",
        queryParameters: {
          "q": query,
          "access_token":
              "pk.eyJ1IjoiZW1rb2V4ZSIsImEiOiJjbHRsbnowZWYxODhmMnBxdnptZTU4ZDE3In0.Xc_w_0i9kPbpEG8DA42CYg",
          "session_token": await _storage.getRefreshToken(),
          "limit": 5,
        },
      );
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

}
