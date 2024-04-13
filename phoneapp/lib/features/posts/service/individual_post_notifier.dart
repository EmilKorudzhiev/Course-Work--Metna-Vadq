import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:MetnaVadq/features/user/data/partial_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final individualPostNotifierProvider = StateNotifierProvider.autoDispose
    .family<IndividualPostNotifier, FullPostModel, int>((ref, postId) {
  final postController = ref.read(postControllerProvider);
  return IndividualPostNotifier(postId: postId, postController: postController);
});

class IndividualPostNotifier extends StateNotifier<FullPostModel> {
  int postId;
  PostController postController;

  IndividualPostNotifier({required this.postId, required this.postController})
      : super(FullPostModel(0,
      DateTime.now(),
      0, 0, '', '',
      new PartialUserModel(id: 0, firstName: '', lastName: ''), false));


  Future<FullPostModel> getPost() async {
    state = await postController.getPost(postId);
    return state;
  }

  Future<bool> likePost() async {
    final response = await postController.likePost(postId);
    if (response) {
      state = state.copyWith(isLiked: !state.isLiked);
      return true;
    } else {
      return false;
    }
  }
}