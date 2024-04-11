import 'package:MetnaVadq/features/user/data/partial_user_model.dart';

class CommentModel {
  final int id;
  final int postId;
  final String text;
  final DateTime createdAt;
  final PartialUserModel user;

  CommentModel({
    required this.id,
    required this.postId,
    required this.text,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      postId: json['fishCatchId'] as int,
      text: json['text'],
      createdAt: DateTime.parse(json['date']),
      user: PartialUserModel.fromJson(json['user']),
    );
  }
}