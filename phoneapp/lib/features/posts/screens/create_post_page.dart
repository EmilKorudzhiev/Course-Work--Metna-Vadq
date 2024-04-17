import 'dart:io';
import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/exceptions/gps_location_exception.dart';
import 'package:MetnaVadq/features/search/service/location_controller.dart';
import 'package:MetnaVadq/features/search/service/map_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class CreatePostPage extends ConsumerWidget {
  CreatePostPage({super.key, required this.image});

  final File image;

  final TextEditingController textController = TextEditingController();

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

  @override
  Widget build(context, ref) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Center(child: Text('Metna-vadq')),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Image.file(image),
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
                          bool isPosted = await ref.read(mapboxControllerProvider).makePostRequest(
                              image,
                              textController.text,
                              LatLng(location.value!.latitude,
                                  location.value!.longitude));
                          if (isPosted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Публикацията беше успешна.')));
                            Navigator.of(context).pop();
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
}
