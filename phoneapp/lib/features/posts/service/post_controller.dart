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

}