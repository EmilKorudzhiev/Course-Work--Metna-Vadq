import 'package:MetnaVadq/features/navigation_bar/notifier//navigation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void onIndexChanged(int index) {
    state = state.copyWith(index: index);
  }
}

final navProvider =
StateNotifierProvider<NavigationNotifier, NavigationState>(
        (ref) => NavigationNotifier());
