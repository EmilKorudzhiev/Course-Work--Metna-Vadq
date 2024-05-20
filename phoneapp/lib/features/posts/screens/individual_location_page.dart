import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/core/aws/aws.dart';
import 'package:MetnaVadq/features/posts/data/models/location_model.dart';
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

class IndividualLocationPage extends ConsumerStatefulWidget {
  final int locationId;
  const IndividualLocationPage(this.locationId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndividualLocationPageState(locationId);
}

class _IndividualLocationPageState
    extends ConsumerState<IndividualLocationPage> {
  final int postId;
  _IndividualLocationPageState(this.postId);

  Map<String, String> translationTable = {
    "STORE": "магазин",
    "FISHING_PLACE": "място за риболов",
    "EVENT": "събитие"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Локация'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: ref.read(postControllerProvider).getLocation(postId),
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

            final LocationModel location = snapshot.data;

            return Column(
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
                                if (location.user.profilePictureUrl == null)
                                  AppWidgets.buildCircularProfilePicture("", 40)
                                else
                                  AppWidgets.buildCircularProfilePicture(
                                      "${AWS.USER_IMAGE_URL}${location.user.id}/${location.user.profilePictureUrl}",
                                      40),
                                const SizedBox(width: 10),
                                Text(
                                  '${location.user.firstName} ${location.user.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(location.date),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          "${AWS.LOCATION_IMAGE_URL}${location.id}/${location.imageUrl}",
                          fit: BoxFit.cover,
                          height: 400.0,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Тип локация: ${translationTable[location.type] ?? location.type}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          location.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ]);
          }),
    );
  }
}
