import 'dart:io';

import 'package:MetnaVadq/features/search/data/location_marker_model.dart';
import 'package:MetnaVadq/features/search/data/make_post_request_model.dart';
import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:MetnaVadq/features/search/data/search_suggestion_model.dart';
import 'package:MetnaVadq/features/search/service/map_search_repository.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final suggestionsProvider = Provider((ref) {
  final mapboxController = ref.read(mapboxControllerProvider);
  return mapboxController.getSuggestion;
});

final mapboxControllerProvider = Provider((ref) {
  final mapboxRepository = ref.read(mapboxRepositoryProvider);
  return MapboxController(mapboxRepository: mapboxRepository);
});

class MapboxController {
  final MapboxRepository _mapboxRepository;

  MapboxController({required MapboxRepository mapboxRepository}) : _mapboxRepository = mapboxRepository;

  Future<List<SearchSuggestionModel>> getSuggestion(String query) async {
    final response = await _mapboxRepository.getSuggestion(query);
    final suggestions = (response?.data['suggestions'] as List)
        .map((e) => SearchSuggestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return suggestions;
  }

  Future<LatLng?> getPlaceCoordinates(String placeDetails) async {
    final response = await _mapboxRepository.getPlaceCoordinates(placeDetails);
    final coordinates = response?.data['features'][0]['center'] as List;
    return LatLng(coordinates[1] as double, coordinates[0] as double);
  }

  Future<List<PostMarkerModel>> getSearchedPostsResult(LatLng coordinate, int radius) async {
    final response = await _mapboxRepository.getSearchedPostsResult(coordinate, radius);
    final posts = (response?.data as List)
        .map((e) => PostMarkerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return posts;
  }

  Future<List<LocationMarkerModel>> getSearchedLocationsResult(LatLng coordinate, int radius) async {
    final response = await _mapboxRepository.getSearchedLocationsResult(coordinate, radius);
    final locations = (response?.data as List)
        .map((e) => LocationMarkerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return locations;
  }

  Future<bool> makePostRequest(File image, String description, LatLng coordinates) async {
    MakePostRequestModel request = MakePostRequestModel(description: description, latitude: coordinates.latitude, longitude: coordinates.longitude);
    final response = await _mapboxRepository.makePostRequest(image, request);
    return response?.statusCode == 200;
  }

}