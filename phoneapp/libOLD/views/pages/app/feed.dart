import 'package:flutter/material.dart';
import 'package:MetnaVadq/views/widgets/app_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = FutureProvider<List<Post>>((ref) async {
  return [
    Post('User1', 'https://placekitten.com/200/200', 'This is a cute kitten!'),
    Post(
        'User2', 'https://placekitten.com/201/201', 'Another adorable kitten.'),
    Post('User1', 'https://placekitten.com/202/202', 'dsfdsfdsfdsfdsf.'),
    // Add more posts as needed
  ];
});

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Metna-vadq'),
              centerTitle: true,
            ),
            body: postsAsyncValue.when(
                data: (posts) {
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: posts[index]);
                      });
                },
                error: (error, stackTrace) => Center(
                      child: Text('Error: $error'),
                    ),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))));
  }
}

class Post {
  final String username;
  final String imageUrl;
  final String description;

  Post(this.username, this.imageUrl, this.description);
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

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
                AppWidgets.buildCircularProfilePicture(post.imageUrl, 40),
                Expanded(
                  child: ListTile(
                    title: Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            post.imageUrl,
            height: 400.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              post.description,
              style: TextStyle(
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
