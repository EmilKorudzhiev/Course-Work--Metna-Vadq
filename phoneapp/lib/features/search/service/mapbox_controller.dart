import 'package:MetnaVadq/features/search/data/search_suggestion_model.dart';
import 'package:MetnaVadq/features/search/service/mapbox_repository.dart';
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
    print(coordinates);
    return LatLng(coordinates[1] as double, coordinates[0] as double);
  }
}