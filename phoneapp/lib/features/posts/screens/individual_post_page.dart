import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndividualPostPage extends ConsumerWidget {
  const IndividualPostPage(this.postId, {super.key});

  final postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context,rootNavigator:true).pop(),
              ),
              //TODO post text here idk what tho
              title: const Text('Post'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Text("Post here"),
                Text("ID: $postId"),
              ],
            ));
  }
}
