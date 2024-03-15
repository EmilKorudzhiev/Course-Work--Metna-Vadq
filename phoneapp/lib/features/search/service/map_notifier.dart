import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapNotifierProvider = StateNotifierProvider<MapNotifier, List<PostMarkerModel>>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<List<PostMarkerModel>> {
  MapNotifier() : super([]);

  void addPostMarker(PostMarkerModel postMarker) {
    state = [...state, postMarker];
  }

  void newMarkers(List<PostMarkerModel> newMarkers) {
    state = newMarkers;
  }

  void removeMarkers() {
    state = [];
  }

}