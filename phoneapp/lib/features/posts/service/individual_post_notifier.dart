import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/service/feed_post_notifier.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:MetnaVadq/features/user/data/partial_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final individualPostNotifierProvider = StateNotifierProvider.autoDispose
    .family<IndividualPostNotifier, FullPostModel, int>((ref, postId) {
  final postController = ref.read(postControllerProvider);
  final feedPostNotifier = ref.read(feedPostNotifierProvider.notifier);
  return IndividualPostNotifier(postId: postId, postController: postController, feedPostNotifier: feedPostNotifier);
});

class IndividualPostNotifier extends StateNotifier<FullPostModel> {
  final int postId;
  final PostController postController;
  final FeedPostNotifier feedPostNotifier;

  IndividualPostNotifier({required this.postId, required this.postController, required this.feedPostNotifier})
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
      feedPostNotifier.updatePost(state);
      return true;
    } else {
      return false;
    }
  }
}