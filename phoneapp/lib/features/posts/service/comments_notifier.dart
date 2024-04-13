import 'package:MetnaVadq/features/posts/data/models/comment_model.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsNotifierProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, List<CommentModel>, int>((ref, postId) {
  final postController = ref.read(postControllerProvider);
  return CommentsNotifier(postId: postId, postController: postController);
});

class CommentsNotifier extends StateNotifier<List<CommentModel>> {
  int postId;
  PostController postController;

  late int nextPageNum;

  CommentsNotifier({required this.postId, required this.postController})
      : super([]);

  Future<List<CommentModel>> getInitialComments() async {
    nextPageNum = 0;
    state = await postController.getComments(postId, nextPageNum, 20);
    return state;
  }

  Future<List<CommentModel>> getNextComments() async {
    nextPageNum++;
    final newComments =
        await postController.getComments(postId, nextPageNum, 20);
    state = [...state, ...newComments];
    return state;
  }

  Future<bool> addComment(String comment) async {
    final isNewCommentPosted = await postController.addComment(postId, comment);
    state = await getInitialComments();
    return isNewCommentPosted;
  }

}
