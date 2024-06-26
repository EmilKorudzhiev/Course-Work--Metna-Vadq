import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/features/auth/service/auth_controller.dart';
import 'package:MetnaVadq/features/posts/data/models/full_post_model.dart';
import 'package:MetnaVadq/features/posts/screens/individual_post_page.dart';
import 'package:MetnaVadq/features/posts/service/feed_post_notifier.dart';
import 'package:MetnaVadq/features/posts/service/individual_post_notifier.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:MetnaVadq/features/user/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:MetnaVadq/features/posts/screens/feed_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(feedPostNotifierProvider.notifier).getInitialPosts();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        ref.read(feedPostNotifierProvider.notifier).getNextPosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Metna-vadq'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final posts = ref.watch(feedPostNotifierProvider);

                if (posts.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      return PostCard(post: posts[index]);
                    } else if (index == posts.length - 1 &&
                        posts.length % 10 == 0) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostCard extends ConsumerWidget {
  FullPostModel post;

  PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return ProfilePage(post.user.id);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 10.0),
              child: Row(
                children: [
                  if (post.user.profilePictureUrl == null)
                    AppWidgets.buildCircularProfilePicture("", 40)
                  else
                    AppWidgets.buildCircularProfilePicture(
                        "${AWS.USER_IMAGE_URL}${post.user.id}/${post.user.profilePictureUrl}",
                        40),
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
          ),
          Image.network(
            "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
            height: 400.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              post.description == "" ? "Публикацията няма описание." : post.description!,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Divider(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final postNotifier =
                      ref.watch(feedPostNotifierProvider.notifier);
                  final like = postNotifier.getPostById(post.id);
                  return IconButton(
                    icon: like.isLiked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.grey,
                            size: 30,
                          ),
                    onPressed: () async {
                      await postNotifier.likePost(post.id);
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_sharp,
                  size: 30,
                ),
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return IndividualPostPage(post.id);
                  }));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
