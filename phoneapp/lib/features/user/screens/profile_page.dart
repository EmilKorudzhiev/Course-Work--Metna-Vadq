import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:MetnaVadq/features/admin/screens/admin_panel_page.dart';
import 'package:MetnaVadq/features/auth/screens/login_page.dart';
import 'package:MetnaVadq/features/auth/service/auth_controller.dart';
import 'package:MetnaVadq/features/posts/data/models/location_model.dart';
import 'package:MetnaVadq/features/posts/data/models/partial_post_model.dart';
import 'package:MetnaVadq/features/posts/screens/individual_location_page.dart';
import 'package:MetnaVadq/features/posts/screens/individual_post_page.dart';
import 'package:MetnaVadq/features/user/screens/edit_profile_page.dart';
import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final int? userId;
  List<PartialPostModel> posts = [];

  ProfilePage(this.userId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProfilePageState(userId);
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  final int? userId;
  bool following = false;

  ProfilePageState(this.userId);

  @override
  Widget build(BuildContext context) {
    final SecureStorageManager secureStorage = ref.read(secureStorageProvider);
    return FutureBuilder(
        future: ref.watch(userControllerProvider).getUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var user = snapshot.data!;
          following = user.followingHim!;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: user.id == null ? false : true,
              title: Text("${user.firstName} ${user.lastName}"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
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
                            backgroundImage: NetworkImage("${AWS.USER_IMAGE_URL}${user.id}/${user.profilePictureUrl}"),
                          );
                        }
                      }),
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  if (userId == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FutureBuilder(
                              future: secureStorage.isUserAdmin(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                var isAdmin = snapshot.data!;
                                if (isAdmin) {
                                  return Container(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext context)
                                        {
                                          return AdminPanelPage();
                                        }));
                                      },
                                      child: const Text("Админ pанел", style: TextStyle(color: Colors.black)),
                                    ),
                                  );
                                } else {
                                  return const SizedBox(width: 0, height: 0);
                                }
                              }),
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return EditProfilePage(
                                              userImageUrl: "${AWS.USER_IMAGE_URL}${user.id}/${user.profilePictureUrl}",
                                              isDefaultImage: user.profilePictureUrl == null ? true : false);
                                        }));
                              },
                              child: const Text("Редактирай", style: TextStyle(color: Colors.black)),
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                ref.read(authProvider.notifier).signOut();
                                Navigator.of(context).pop();
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return const LoginPage();
                                }));
                              },
                              child: const Text("Излез", style: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(userControllerProvider)
                            .followUser(userId!);
                        setState(() {
                          following = !following;
                        });
                      },
                      child: Text(following ? "Отпоследване" : "Последване", style: TextStyle(color: Colors.black)),
                    ),
                  );
                }),
                Container(
                  margin: const EdgeInsets.only(top: 8,bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Text(
                            style: const TextStyle(fontSize: 20),
                            "Последователи: ${user.followersCount}"),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Text(
                            style: const TextStyle(fontSize: 20),
                            "Улови: ${user.catchCount}"),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(child:
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.post_add, color: AppColors.primary,),
                              //text: "Публикации",
                            ),
                            Tab(
                              icon: Icon(Icons.location_on, color: AppColors.primary,),
                              //text: "Локации",
                            ),
                          ],
                          indicatorColor: AppColors.secondary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 2.0,

                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              //TODO fix them to be pageable
                              FutureBuilder(
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
                              ),
                              FutureBuilder(
                                future: ref
                                    .watch(userControllerProvider)
                                    .getUserLocations(userId, 0, 15),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var location = snapshot.data!;
                                  return GridView.builder(
                                      gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                      ),
                                      itemCount: location.length,
                                      itemBuilder: (context, index) {
                                        return SmallLocationCard(location: location[index]);
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        });
  }
}

class SmallPostCard extends StatelessWidget {
  final PartialPostModel post;

  SmallPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return IndividualPostPage(post.id);
          }));
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.tertiary, // Border color
              width: 2.0, // Border width
            ),
          ),
          child: Image.network(
            "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SmallLocationCard extends StatelessWidget {
  final LocationModel location;

  SmallLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return IndividualLocationPage(location.id);
          }));
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.tertiary, // Border color
              width: 2.0, // Border width
            ),
          ),
          child: Image.network(
            "${AWS.LOCATION_IMAGE_URL}${location.id}/${location.imageUrl}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
