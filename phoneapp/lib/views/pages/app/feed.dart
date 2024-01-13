import 'package:flutter/material.dart';
import 'package:MetnaVadq/views/widgets/app_widgets.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Metna-vadq'),
          centerTitle: true,
        ),
        body: PostList(),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  // Dummy data for posts
  List<Post> posts = [
    Post('User1', 'https://placekitten.com/200/200', 'This is a cute kitten!'),
    Post('User2', 'https://placekitten.com/201/201', 'Another adorable kitten.'),
    Post('User1', 'https://placekitten.com/202/202', 'dsfdsfdsfdsfdsf.'),
    // Add more posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
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
