import 'dart:async';
import 'dart:math';

import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/exceptions/gps_location_exception.dart';
import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:MetnaVadq/features/search/service/location_controller.dart';
import 'package:MetnaVadq/features/search/service/map_notifier.dart';
import 'package:MetnaVadq/features/search/service/mapbox_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

//TODO napravi search

//Fish or Location
final mapLocationTypeProvider = StateProvider<bool>((ref) {
  return false;
});

//GPS radius
final gpsRadiusProvider = Provider<Map<int, String>>((ref) => {
      500: "500m",
      1000: "1km",
      2500: "2.5km",
      5000: "5km",
      10000: "10km",
      25000: "25km",
      50000: "50km",
    });

final gpsRadiusStateProvider = StateProvider<int>((ref) {
  return 5000;
});

// final locationSearchBarProvider = StateProvider<String>((ref) {
//   return "";
// });

class MapSearchPage extends ConsumerWidget {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //Type of search (GPS or Search)
    final gpsMapSearch = ref.watch(isPositionActiveProvider);
    final iconMapSearch = gpsMapSearch ? Icons.gps_fixed : Icons.search;

    //Radius of search with GPS
    var radius = ref.read(gpsRadiusProvider);
    var selectedRadius = ref.watch(gpsRadiusStateProvider);

    //Type of search (Fish or Location)
    final locationMapSearch = ref.watch(mapLocationTypeProvider);
    final iconLocationSearch =
        locationMapSearch ? FontAwesomeIcons.store : FontAwesomeIcons.fishFins;
    print(locationMapSearch);

    //Markers
    final markerPoints = ref.watch(mapNotifierProvider);
    print(markerPoints.toString());

    //GPS location
    var locationProvider = ref.watch(positionProvider);
    var location;
    if (locationProvider.hasError) {
      if (locationProvider.error is GpsLocationException) {
        location = (locationProvider.error as GpsLocationException).message;
      }
    } else {
      location = locationProvider.value;
    }
    print(location);

    //Search bar controller
    //final searchBarController = TextEditingController(text: ref.read(locationSearchBarProvider));
    final searchBarController = TextEditingController();

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
                      ref.read(isPositionActiveProvider.notifier).state =
                          !ref.read(isPositionActiveProvider.notifier).state;
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
                  return Container(
                    child: Builder(builder: (context) {
                      if (location != null && location is! String) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "Търсене на ${locationMapSearch ? "локации" : "улови"} в радиус от "),
                                DropdownButton<int>(
                                  value: selectedRadius,
                                  items: radius.keys
                                      .map((e) => DropdownMenuItem<int>(
                                            value: e,
                                            child: Text(radius[e]!),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    ref
                                        .read(gpsRadiusStateProvider.notifier)
                                        .state = value!;
                                  },
                                ),
                              ],
                            ),
                            //TODO make search button work
                            ElevatedButton(
                              onPressed: () {
                                print("Working");
                              },
                              child: Text('Търси'),
                            ),
                          ],
                        );
                      } else if (location == null) {
                        return const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Text(location.toString());
                      }
                    }),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child:
                        Autocomplete<String>(optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }

                          await ref.read(mapboxControllerProvider).getSuggestion(textEditingValue.text);


                          //TODO make mapbox suggestion display
                          return ['One', 'Two', 'Three', 'Four', 'Five']
                              .where((String option) =>
                                  option.contains(textEditingValue.text))
                              .toList();
                        }, fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          // Implement the text field UI
                          return SearchBar(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            onChanged: (text) {
                              // Update suggestions based on user input
                              // Implement the logic to filter and refresh suggestions
                            },
                            onSubmitted: (text) {
                              // Handle the submission of the selected suggestion
                              // Implement the logic for the selection action
                            },
                          );
                        }),

                        // SearchBar(
                        //   hintText: "Търсене на локация",
                        //   onChanged: (text) {
                        //     ref.read(locationSearchBarProvider.notifier).state = text;
                        //     print(searchBarController.text);
                        //   },
                        //   leading: IconButton(
                        //     onPressed: () {
                        //       //TODO call mapbox geocoding api to convert address to coordinates
                        //       print("Search");
                        //     },
                        //     icon: const Icon(Icons.search),
                        //   ),
                        //   controller: searchBarController,
                        //   backgroundColor: MaterialStateColor.resolveWith(
                        //       (states) => AppColors.secondary),
                        //   padding: MaterialStateProperty.resolveWith(
                        //     (states) => const EdgeInsets.symmetric(
                        //         horizontal: 8.0, vertical: 5.0),
                        //   ),
                        //
                        // ),
                      ),
                      Text("Location Search")
                    ],
                  );
                }
              }),
              //TODO remove debug location button \/
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
                    if (gpsMapSearch && location != null && location is! String)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point:
                                LatLng(location.latitude, location.longitude),
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.gps_fixed,
                              shadows: <Shadow>[
                                Shadow(color: Colors.black, blurRadius: 5.0),
                              ],
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
