import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/features/auth/service/auth_controller.dart';
import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:MetnaVadq/features/posts/screens/feed_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<FullPostModel> postList = [];

    return SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Metna-vadq'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        ref.read(authProvider.notifier).signOut();
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                  // TODO make it infinity scrollable and pull to refresh
                  Container(
                    child: Expanded(
                      child: FutureBuilder(
                        future: ref.watch(postControllerProvider).getPosts(0, 20),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var posts = snapshot.data!;
                          return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return PostCard(post: posts[index]);
                              });
                        },
                      ),
                    ),
                  ),
                ],
              )),
        );
  }

  Future<void> _refresh() async {
    print("Refresh works!");
  }
}

class PostCard extends StatelessWidget {
  final FullPostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.0, left: 10.0),
            child: Row(
              children: [
                AppWidgets.buildCircularProfilePicture(
                    "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}", 40),
                Expanded(
                  child: ListTile(
                    title: Text(
                      "${post.user.firstName} ${post.user.lastName}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
            height: 400.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              post.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.grey,
                onPressed: () {
                  // Handle liking logic here
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                color: Colors.grey,
                onPressed: () {
                  // Handle commenting logic here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
