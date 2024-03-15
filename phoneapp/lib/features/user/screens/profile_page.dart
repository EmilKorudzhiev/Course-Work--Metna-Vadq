import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/features/posts/data/models/partial_post_model.dart';
import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  final int? userId;
  List<PartialPostModel> posts = [];

  ProfilePage(this.userId, {super.key});

  //TODO MAKE POST LOADING AND PAGE FETCHING ON THEM

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 16),
      top: true,
      child: FutureBuilder(
          future: ref.watch(userControllerProvider).getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var user = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("${user.firstName} ${user.lastName}"),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Builder(builder: (context) {
                          if (user.profilePictureUrl == null) {
                            return const CircleAvatar(
                              radius: 75,
                              backgroundImage: AssetImage(
                                  "lib/assets/pictures/userProfileDefault.jpg"),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(AWS.USER_IMAGE_URL +
                                  user.profilePictureUrl.toString()),
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: const Text(
                              style: TextStyle(fontSize: 20), "Followers: 12"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                              style: TextStyle(fontSize: 20), "Catches: 231"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: FutureBuilder(
                      future: ref
                          .watch(userControllerProvider)
                          .getUserPosts(userId, 0, 15),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var posts = snapshot.data!;
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                ),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return SmallPostCard(post: posts[index]);
                            });
                      },
                    )),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class SmallPostCard extends StatelessWidget {
  final PartialPostModel post;

  SmallPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        //TODO: Make it navigate to post page
        onTap: () {print("Post Clicked");},
        child: Container(
          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Image.network(
            "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
