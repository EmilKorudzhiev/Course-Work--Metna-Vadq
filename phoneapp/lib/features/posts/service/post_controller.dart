import 'package:MetnaVadq/features/posts/data/models/comment_model.dart';
import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/service/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return PostController(postRepository: postRepository);
});

class PostController {
  final PostRepository _postRepository;

  PostController({required PostRepository postRepository}): _postRepository = postRepository;

  Future<List<FullPostModel>> getPosts(int pageNum, int pageSize) async {
    final response = await _postRepository.getPosts(pageNum, pageSize);
    List<FullPostModel> posts = (response?.data as List)
        .map((el) => FullPostModel.fromJson(el))
        .toList();

    print(posts.toString());

    return posts;
  }

  Future<FullPostModel> getPost(int postId) async {
    final response = await _postRepository.getPost(postId);
    FullPostModel post = FullPostModel.fromJson(response?.data);

    return post;
  }

  Future<List<CommentModel>> getComments(int postId, int pageNum, int pageSize) async {
    final response = await _postRepository.getComments(postId, pageNum, pageSize);
    List<CommentModel> comments = (response?.data as List)
        .map((el) => CommentModel.fromJson(el))
        .toList();
    return comments;
  }

  Future<bool> likePost(int postId) async {
    final response = await _postRepository.likePost(postId);
    if (response?.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addComment(int postId, String comment) async {
    final response = await _postRepository.addComment(postId, comment);
    if (response?.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

}