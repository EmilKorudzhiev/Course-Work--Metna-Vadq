import 'dart:io';
import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/exceptions/gps_location_exception.dart';
import 'package:MetnaVadq/features/posts/service/post_controller.dart';
import 'package:MetnaVadq/features/search/service/location_controller.dart';
import 'package:MetnaVadq/features/search/service/map_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

enum LocationType { store, fishingPlace, event }

extension LocationTypeExtension on LocationType {
  String get type {
    switch (this) {
      case LocationType.store:
        return 'store';
      case LocationType.fishingPlace:
        return 'fishing_place';
      case LocationType.event:
        return 'event';
      default:
        return '';
    }
  }
}

class CreatePostPage extends ConsumerStatefulWidget {
  CreatePostPage({super.key, required this.image, required this.isPost});

  final File image;
  final bool isPost;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostPageState(image: image, isPost: isPost);
}

class _CreatePostPageState extends ConsumerState {
  final File image;
  final bool isPost;

  final TextEditingController textController = TextEditingController();
  String dropdownValue = LocationType.store.type;

  _CreatePostPageState({required this.image, required this.isPost});

  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: isPost
              ? const Center(child: Text('Създаване на улов'))
              : const Center(child: Text('Създаване на локация')),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Image.file(
              image,
              height: 400.0,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            ElevatedButton(
                onPressed: () {
                  saveImage(image);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.secondary)),
                child: const Text('Запази в устройство',
                    style: TextStyle(color: Colors.black))),
            const Divider(),
            Builder(builder: (context) {
              if (isPost == false) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: LocationType.values
                        .map<DropdownMenuItem<String>>((LocationType value) {
                      return DropdownMenuItem<String>(
                        value: value.type,
                        child: Text(value.type),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Описание',
                ),
              ),
            ),
            const Divider(),
            Consumer(builder: (context, watch, child) {
              final locationProvider = ref.watch(positionStreamProvider);
              var location;
              if (locationProvider.hasError) {
                if (locationProvider.error is GpsLocationException) {
                  location =
                      (locationProvider.error as GpsLocationException).message;
                }
              } else {
                location = locationProvider.value;
              }
              print(location);

              if (location == null) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              } else {
                if (location is String) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(location),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          bool isPosted;
                          if (isPost) {
                            isPosted = await ref
                                .read(postControllerProvider)
                                .makePostRequest(
                                image,
                                textController.text,
                                LatLng(
                                    location.latitude, location.longitude));
                          } else {
                            isPosted = await ref
                                .read(postControllerProvider)
                                .makeLocationRequest(
                                image,
                                textController.text,
                                LatLng(
                                    location.latitude, location.longitude),
                                dropdownValue);
                          }

                          if (isPosted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Публикацията беше успешна.')));
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Публикацията НЕ беше успешна. Моля опитайте по-късно.')));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.secondary)),
                        child: const Text('Публикувай',
                            style: TextStyle(color: Colors.black))),
                  );
                }
              }
            }),
          ]),
        ));
  }

  Future<void> saveImage(File image) async {
    final externalDirectory = (await getExternalStorageDirectories())!.first;
    final id = const Uuid().v1();
    final fileName = path.join(externalDirectory.path, '$id.jpg');
    final file = File(fileName);

    print('File path: $fileName');

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    try {
      final imageData = await image.readAsBytes();

      await file.writeAsBytes(imageData);
      print('Image saved at ${file.path}');
    } catch (e) {
      print(e);
    }
  }
}
