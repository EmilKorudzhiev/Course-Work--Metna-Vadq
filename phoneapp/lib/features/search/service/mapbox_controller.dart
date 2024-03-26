import 'package:MetnaVadq/features/search/service/mapbox_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapboxControllerProvider = Provider((ref) {
  final mapboxRepository = ref.read(mapboxRepositoryProvider);
  return MapboxController(mapboxRepository: mapboxRepository);
});

class MapboxController {

  final MapboxRepository _mapboxRepository;

  MapboxController({required MapboxRepository mapboxRepository}) : _mapboxRepository = mapboxRepository;

  void getSuggestion(String query) {
    final response = _mapboxRepository.getSuggestion(query);
    print(response);
  }

}