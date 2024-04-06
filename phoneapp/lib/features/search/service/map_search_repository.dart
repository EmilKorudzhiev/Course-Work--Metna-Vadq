import 'package:MetnaVadq/core/api/dio/api.dart';
import 'package:MetnaVadq/core/api/endpoints.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final mapboxRepositoryProvider = Provider<MapboxRepository>((ref) {
  final api = ref.read(apiProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return MapboxRepository(api: api, storage: secureStorage);
});

class MapboxRepository {
  final DioClient _api;
  final SecureStorageManager _storage;

  MapboxRepository(
      {required DioClient api, required SecureStorageManager storage})
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
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      print("ERROR!!!!!!");
      print(e);
    }
    return null;
  }

  Future<Response?> getPlaceCoordinates(String placeDetails) async {
    try {
      print(placeDetails);
      final response = await _api.dio.get(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$placeDetails.json",
        queryParameters: {
          "access_token":
              "pk.eyJ1IjoiZW1rb2V4ZSIsImEiOiJjbHRsbnowZWYxODhmMnBxdnptZTU4ZDE3In0.Xc_w_0i9kPbpEG8DA42CYg",
          "session_token": await _storage.getRefreshToken(),
          "limit": 5,
        },
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

  Future<Response?> getSearchedPlaceResult(LatLng coordinates, int radius) async {
    try {
      final response = await _api.dio.get(
        Endpoints.GET_POSTS_BY_RADIUS_ENDPOINT,
        options: Options(headers: {
          "Authorization": "Bearer ${await _storage.getAccessToken()}"
        }),
        data: {
          "latitude": coordinates.latitude,
          "longitude": coordinates.longitude,
          "distance": radius,
        },
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
}
