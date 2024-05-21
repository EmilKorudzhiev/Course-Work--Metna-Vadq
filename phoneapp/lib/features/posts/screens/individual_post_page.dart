import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/core/secure_storage/secure_storage_manager.dart';
import 'package:MetnaVadq/features/posts/screens/feed_widgets.dart';
import 'package:MetnaVadq/features/posts/service/comments_notifier.dart';
import 'package:MetnaVadq/features/posts/service/individual_post_notifier.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

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

  final localScrollController = ScrollController();
  final inputController = TextEditingController();

  bool isMapVisible = false;

  @override
  void initState() {
    super.initState();

    localScrollController.addListener(() {
      if (localScrollController.position.pixels ==
          localScrollController.position.maxScrollExtent) {
        ref.read(commentsNotifierProvider(postId).notifier).getNextComments();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    localScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(commentsNotifierProvider(postId).notifier);
    ref.watch(individualPostNotifierProvider(postId).notifier);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Публикация'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: ref
                .read(individualPostNotifierProvider(postId).notifier)
                .getPost(),
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

              final FullPostModel post = snapshot.data;

              return SingleChildScrollView(
                controller: localScrollController,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (post.user.profilePictureUrl == null)
                                      AppWidgets.buildCircularProfilePicture(
                                          "", 40)
                                    else
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
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm')
                                      .format(post.date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Image.network(
                              "${AWS.POST_IMAGE_URL}${post.id}/${post.imageUrl}",
                              fit: BoxFit.cover,
                              height: 400.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.description == ""
                                  ? "Публикацията няма описание."
                                  : post.description!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: Future.wait([
                          ref.read(secureStorageProvider).getUserId(),
                          ref.read(secureStorageProvider).isUserAdmin(),
                        ]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final String userId = snapshot.data?[0];
                          final bool isAdmin = snapshot.data?[1];
                          print("AAAAAAAAA" + isAdmin.toString());

                          if (userId == post.user.id.toString() || isAdmin) {
                            return Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isDeleted = await ref
                                      .read(postControllerProvider)
                                      .deletePost(post.id);

                                  if (isDeleted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Публикацията беше изтрита успешно!')));
                                  }
                                },
                                child: const Text(
                                  'Изтрий публикация',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isMapVisible = !isMapVisible;
                              });
                            },
                            child: Text(
                                isMapVisible
                                    ? 'Покажи коментари'
                                    : 'Покажи карта',
                                style: const TextStyle(color: Colors.black))),
                      ),
                      if (!isMapVisible)
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Коментари',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: ref
                                  .read(
                                      commentsNotifierProvider(postId).notifier)
                                  .getInitialComments(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                return Consumer(
                                  builder: (BuildContext context, WidgetRef ref,
                                      Widget? child) {
                                    final comments = ref.watch(
                                        commentsNotifierProvider(postId));

                                    return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: comments.length + 2,
                                        itemBuilder: (context, index) {
                                          if (index < comments.length) {
                                            var comment = comments[index];
                                            return ListTile(
                                              title: Row(
                                                children: [
                                                  if (post.user
                                                          .profilePictureUrl ==
                                                      null)
                                                    AppWidgets
                                                        .buildCircularProfilePicture(
                                                            "", 30)
                                                  else
                                                    AppWidgets
                                                        .buildCircularProfilePicture(
                                                            "${AWS.USER_IMAGE_URL}${post.user.id}/${post.user.profilePictureUrl}",
                                                            30),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '${post.user.firstName} ${post.user.lastName}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                            'dd/MM/yyyy HH:mm')
                                                        .format(
                                                            comment.createdAt),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(comment.text,
                                                      style: const TextStyle(
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            );
                                          } else {
                                            if (comments.length % 20 == 0 &&
                                                comments.length >= 20) {
                                              return const Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            } else {
                                              return const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    "Няма повече коментари.\nМоже би е време да добавите един?",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        });
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      else
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Карта',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              height: 400,
                              child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter:
                                        LatLng(post.latitude, post.longitude),
                                    initialZoom: 13.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://api.mapbox.com/styles/v1/'
                                          'emkoexe/cltljjg6p00kz01nr7wrj1dcs/'
                                          'tiles/256/{z}/{x}/{y}@2x?'
                                          'access_token=pk.eyJ1IjoiZW1rb2V4ZSIsImEiOiJjbHRsbnowZWYxODhmMnBxdnptZTU4ZDE3In0.Xc_w_0i9kPbpEG8DA42CYg',
                                    ),
                                    MarkerLayer(markers: [
                                      Marker(
                                        width: 80.0,
                                        height: 80.0,
                                        point: LatLng(
                                            post.latitude, post.longitude),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: AppColors.primary,
                                          size: 50,
                                        ),
                                      ),
                                    ]),
                                  ]),
                            ),
                          ],
                        ),
                    ]),
              );
            }),
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      hintText: 'Добави коментар...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    bool isCommentAdded = await ref
                        .read(commentsNotifierProvider(postId).notifier)
                        .addComment(inputController.text);
                    inputController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (isCommentAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Коментарът беше добавен успешно!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Възникна грешка при добавянето на коментар!'),
                        ),
                      );
                    }
                    localScrollController.animateTo(
                      localScrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final like =
                        ref.watch(individualPostNotifierProvider(postId));
                    return IconButton(
                        icon: like.isLiked
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border),
                        onPressed: () {
                          ref
                              .read(individualPostNotifierProvider(postId)
                                  .notifier)
                              .likePost();
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
