import 'dart:io';

import 'package:MetnaVadq/features/posts/data/models/comment_model.dart';
import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/data/models/location_model.dart';
import 'package:MetnaVadq/features/posts/data/models/make_location_request_model.dart';
import 'package:MetnaVadq/features/posts/service/post_repository.dart';
import 'package:MetnaVadq/features/posts/data/models/make_post_request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

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

  Future<bool> makePostRequest(File image, String description, LatLng coordinates) async {
    MakePostRequestModel request = MakePostRequestModel(description: description, latitude: coordinates.latitude, longitude: coordinates.longitude);
    final response = await _postRepository.makePostRequest(image, request);
    return response?.statusCode == 204;
  }

  Future<bool> makeLocationRequest(File image, String text, LatLng latLng, String dropdownValue) async {
    MakeLocationRequestModel request = MakeLocationRequestModel(description: text, type: dropdownValue, latitude: latLng.latitude, longitude: latLng.longitude);
    final response = await _postRepository.makeLocationRequest(image, request);
    return response?.statusCode == 204;
  }

  Future<LocationModel> getLocation(int locationId) async {
    final response = await _postRepository.getLocation(locationId);
    LocationModel location = LocationModel.fromJson(response?.data);
    return location;
  }

  Future<bool> deletePost(int postId) async {
    final response = await _postRepository.deletePost(postId);
    return response?.statusCode == 204;
  }

  Future<bool> deleteLocation(int id) async {
    final response = await _postRepository.deleteLocation(id);
    return response?.statusCode == 204;
  }

}