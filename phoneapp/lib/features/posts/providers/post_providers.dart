import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/data/requests/pageable_post_request.dart';
import 'package:MetnaVadq/features/posts/service/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postProvider = Provider<PostService>((ref) => PostService());

final postPageableProvider =
    FutureProvider.family<List<FullPostModel>, PageablePostRequest>(
        (ref, request) async {
  return ref.watch(postProvider).getPosts(request.pageNum, request.pageSize);
});
