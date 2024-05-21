import 'package:MetnaVadq/features/posts/data/models/partial_post_model.dart';
import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePostNotifierProvider = StateNotifierProvider<ProfilePostNotifier, List<PartialPostModel>>((ref) {
  final userController = ref.read(userControllerProvider);
  return ProfilePostNotifier(userController);
});

class ProfilePostNotifier extends StateNotifier<List<PartialPostModel>> {
  ProfilePostNotifier(this._userController) : super([]);
  final UserController _userController;
  late int nextPageNum;

  Future<List<PartialPostModel>> getInitialPosts(int? id) async {
    nextPageNum = 0;
    state = await _userController.getUserPosts(id, nextPageNum, 21);
    return state;
  }

  Future<List<PartialPostModel>> getNextPosts(int? id) async {
    nextPageNum++;
    final newPosts = await _userController.getUserPosts(id, nextPageNum, 21);
    state = [...state, ...newPosts];
    return state;
  }
}