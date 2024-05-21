import 'package:MetnaVadq/features/posts/data/models/location_model.dart';
import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileLocationNotifierProvider = StateNotifierProvider<ProfileLocationNotifier, List<LocationModel>>((ref) {
  final userController = ref.read(userControllerProvider);
  return ProfileLocationNotifier(userController);
});

class ProfileLocationNotifier extends StateNotifier<List<LocationModel>> {
  ProfileLocationNotifier(this._userController) : super([]);
  final UserController _userController;
  late int nextPageNum;

  Future<List<LocationModel>> getInitialPosts(int? id) async {
    nextPageNum = 0;
    state = await _userController.getUserLocations(id, nextPageNum, 21);
    return state;
  }

  Future<List<LocationModel>> getNextPosts(int? id) async {
    nextPageNum++;
    final newPosts = await _userController.getUserLocations(id, nextPageNum, 21);
    state = [...state, ...newPosts];
    return state;
  }
}