import 'dart:math';

import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:MetnaVadq/features/search/service/location_controller.dart';
import 'package:MetnaVadq/features/search/service/map_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

//Search or GPS
final mapSearchTypeProvider = StateProvider<bool>((ref) {
  return false;
});

//Fish or Location
final mapLocationTypeProvider = StateProvider<bool>((ref) {
  return false;
});

class MapSearchPage extends ConsumerWidget {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final gpsMapSearch = ref.watch(mapSearchTypeProvider);
    final iconMapSearch = gpsMapSearch ? Icons.gps_fixed : Icons.search;

    final locationMapSearch = ref.watch(mapLocationTypeProvider);
    final iconLocationSearch =
        locationMapSearch ? FontAwesomeIcons.store : FontAwesomeIcons.fishFins;
    print(locationMapSearch);

    final markerPoints = ref.watch(mapNotifierProvider);
    print(markerPoints.toString());


    var location = null;
    try {
      final locationProvider = ref.watch(positionProvider);
      location = LatLng(locationProvider.value!.latitude, locationProvider.value!.longitude);
      print(location);
    } catch (e) {
      location = e.toString();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Map Search')),
        ),
        body: SizedBox(
          child: Column(
            children: [
              //TODO button with icon for searching both fish catches and locations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(mapSearchTypeProvider.notifier).state =
                          !ref.read(mapSearchTypeProvider.notifier).state;
                    },
                    icon: Icon(iconMapSearch),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(mapLocationTypeProvider.notifier).state =
                          !ref.read(mapLocationTypeProvider.notifier).state;
                    },
                    icon: Icon(iconLocationSearch),
                  ),
                ],
              ),

              //TODO Make map search
              //TODO create providers and requests
              //TODO make displaying fishcatches blue locations some other color
              //TODo make them button that take them to their page
              Builder(builder: (context) {
                if (gpsMapSearch) {
                  return Column(
                    children: [
                      Text(location.toString()),
                      Text("GPS Search"),
                    ],
                  );
                } else {
                  return Text("Location Search");
                }
              }),
              Builder(builder: (context) {
                if (locationMapSearch) {
                  return Text("Location");
                } else {
                  return Text("Fish");
                }
              }),
              ElevatedButton(
                onPressed: () {
                  var random = Random();
                  double randomLat = 41 + random.nextDouble() * (43.6 - 41);
                  double randomLong = 23 + random.nextDouble() * (28.1 - 22);

                  ref.read(mapNotifierProvider.notifier).addPostMarker(
                      PostMarkerModel(
                          id: 1, latitude: randomLat, longitude: randomLong));
                },
                child: Text('Set location'),
              ),
              // TODO make button work ^^^^

              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                      initialCenter: LatLng(42.64, 25.2),
                      initialZoom: 8,
                      cameraConstraint: CameraConstraint.contain(
                          bounds: LatLngBounds(
                        LatLng(-90, -180),
                        LatLng(90, 180),
                      ))),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.mapbox.com/styles/v1/'
                          'emkoexe/cltljjg6p00kz01nr7wrj1dcs/'
                          'tiles/256/{z}/{x}/{y}@2x?'
                          'access_token=pk.eyJ1IjoiZW1rb2V4ZSIsImEiOiJjbHRsbnowZWYxODhmMnBxdnptZTU4ZDE3In0.Xc_w_0i9kPbpEG8DA42CYg',
                    ),
                    MarkerLayer(
                      markers: markerPoints
                          .map((element) => Marker(
                                point:
                                    LatLng(element.latitude, element.longitude),
                                width: 60,
                                height: 60,
                                child: const Icon(Icons.location_pin),
                              ))
                          .toList(),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
