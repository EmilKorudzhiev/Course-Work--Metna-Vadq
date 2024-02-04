

import 'dart:convert';

import 'package:MetnaVadq/api/auth/auth.dart';
import 'package:MetnaVadq/utils/constants.dart';
import 'package:MetnaVadq/utils/models/post/full_post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class PostApiRequests {

  final dio = Dio();
  final api = AuthApi();

  Future<Response> getPostsRequest() async {
    Response response = await dio.get("${Constants.URL}/fish-catch");
    return response;
  }
  Future<List<Post>> getPosts() async {
    Response? response = await api.makeRequestWithTokenRefresh(getPostsRequest);
    print("DA");
    print((jsonDecode(response?.data) as List)
        .map((postJson) => Post.fromJson(postJson))
        .toList().toString());
    return (jsonDecode(response?.data) as List)
        .map((postJson) => Post.fromJson(postJson))
        .toList();
  }


}