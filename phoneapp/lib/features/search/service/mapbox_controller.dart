import 'package:MetnaVadq/features/search/data/search_suggestion_model.dart';
import 'package:MetnaVadq/features/search/service/mapbox_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapboxControllerProvider = Provider((ref) {
  final mapboxRepository = ref.read(mapboxRepositoryProvider);
  return MapboxController(mapboxRepository: mapboxRepository);
});

class MapboxController {
  final MapboxRepository _mapboxRepository;

  MapboxController({required MapboxRepository mapboxRepository}) : _mapboxRepository = mapboxRepository;

  Future<void> getSuggestion(String query) async {
    final response = await _mapboxRepository.getSuggestion(query);
    final suggestions = (response?.data['suggestions'] as List)
        .map((e) => SearchSuggestionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    suggestions.forEach((element){print(element.toString());});
  }

}