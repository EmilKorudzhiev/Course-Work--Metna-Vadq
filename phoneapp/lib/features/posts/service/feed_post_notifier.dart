import 'dart:async';

import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedPostNotifierProvider =
    StateNotifierProvider<FeedPostNotifier, List<FullPostModel>>((ref) {
  final postController = ref.read(postControllerProvider);
  return FeedPostNotifier(postController);
});

class FeedPostNotifier extends StateNotifier<List<FullPostModel>> {
  final PostController _postController;

  late int nextPageNum;

  FeedPostNotifier(this._postController) : super([]);

  Future<List<FullPostModel>> getInitialPosts() async {
    nextPageNum = 0;
    state = await _postController.getPosts(nextPageNum, 10);
    return state;
  }

  Future<List<FullPostModel>> getNextPosts() async {
    nextPageNum++;
    final newPosts = await _postController.getPosts(nextPageNum, 10);
    state = [...state, ...newPosts];
    return state;
  }

  Future<bool> likePost(int postId) async {
    final response = await _postController.likePost(postId);
    if (response) {
      final postIndex = state.indexWhere((element) => element.id == postId);
      state = [
        ...state.sublist(0, postIndex),
        state[postIndex].copyWith(isLiked: !state[postIndex].isLiked),
        ...state.sublist(postIndex + 1),
      ];
      return true;
    } else {
      return false;
    }
  }

  void updatePost(FullPostModel updatedPost) {
    final postIndex =
        state.indexWhere((element) => element.id == updatedPost.id);
    if (postIndex != -1) {
      state = [
        ...state.sublist(0, postIndex),
        updatedPost,
        ...state.sublist(postIndex + 1),
      ];
    }
  }

  FullPostModel getPostById(int postId) {
    return state.firstWhere((post) => post.id == postId);
  }

  Future<void> deletePost(int postId) async {
    final response = await _postController.deletePost(postId);
    if (response) {
      state = await getInitialPosts();
    }
  }
}
