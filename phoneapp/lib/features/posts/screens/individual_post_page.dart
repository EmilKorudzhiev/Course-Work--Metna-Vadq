import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/features/posts/data/models/comment_model.dart';
import 'package:MetnaVadq/features/posts/screens/feed_widgets.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/full_post_model.dart';

class IndividualPostPage extends ConsumerStatefulWidget {
  final int postId;
  const IndividualPostPage(this.postId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndividualPostPageState(postId);
}

class _IndividualPostPageState extends ConsumerState<IndividualPostPage> {
  final int postId;
  _IndividualPostPageState(this.postId);

  final scrollController = ScrollController();
  List<CommentModel> comments = [];
  int pageNum = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("fetching comments");
        fetchComments();
      }
    });
  }

  Future fetchComments() async {
    comments.addAll(await ref.read(postControllerProvider).getComments(postId, pageNum, 20));
  }
  //TODO Fix this because it is not working
  //TODO The problem is that when fetching the page is refreshing when refetching
  @override
  Widget build(BuildContext context) {
    print("da");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metna-vadq'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: ref.read(postControllerProvider).getPost(postId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            FullPostModel post = snapshot.data;

            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppWidgets.buildCircularProfilePicture(
                                "${AWS.USER_IMAGE_URL}${post.user.id}/${post.user.profilePictureUrl}",
                                40),
                            const SizedBox(width: 10),
                            Text(
                              '${post.user.firstName} ${post.user.lastName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        SizedBox(height: 10),
                        Text(
                          post.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Comments Section
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Коментари',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  //TODO
                  FutureBuilder(
                    future: ref.read(postControllerProvider).getComments(postId, 0, 20),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      comments.addAll(snapshot.data);
                      print("size " + comments.length.toString() + "page " + pageNum.toString());
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: comments.length + 1,
                          itemBuilder: (context, index) {
                            if (index < comments.length) {
                              print(comments.length);
                              final comment = comments[index];
                              return ListTile(
                                title: Text(comment.id.toString()),
                                subtitle: Text(comment.text),
                              );
                            } else {
                              return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                          });
                    },
                  )
                ],
              ),
            );
          }),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Handle sending comment
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
