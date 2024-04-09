import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/exceptions/gps_location_exception.dart';
import 'package:MetnaVadq/features/posts/screens/individual_post_page.dart';
import 'package:MetnaVadq/features/search/data/location_marker_model.dart';
import 'package:MetnaVadq/features/search/data/post_marker_model.dart';
import 'package:MetnaVadq/features/search/data/search_suggestion_model.dart';
import 'package:MetnaVadq/features/search/service/location_controller.dart';
import 'package:MetnaVadq/features/search/service/map_search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

//Fish or Location
final mapLocationTypeProvider = StateProvider<bool>((ref) {
  return false;
});

//Current location searched that was inputted via search or GPS
final searchedLocationProvider = StateProvider<LatLng?>((ref) {
  return null;
});

//Search results
final searchedFishCatchesNearbyResultCoordinatesProvider =
    StateProvider<List<PostMarkerModel>>((ref) {
  return [];
});

final searchedLocationsNearbyResultCoordinatesProvider =
    StateProvider<List<LocationMarkerModel>>((ref) {
  return [];
});

//GPS radius
final gpsRadiusOptionsProvider = Provider<Map<int, String>>((ref) => {
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

class MapSearchPage extends ConsumerWidget {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //Type of search (GPS or Search)
    final gpsMapSearch = ref.watch(isPositionActiveProvider);
    final iconMapSearch = gpsMapSearch ? Icons.gps_fixed : Icons.search;

    //Radius of search with GPS
    var radius = ref.read(gpsRadiusOptionsProvider);
    var selectedRadius = ref.watch(gpsRadiusStateProvider);

    //Coordinates of the searched location
    final searchedLocation = ref.watch(searchedLocationProvider);

    //Type of search (Fish or Location)
    final locationMapSearch = ref.watch(mapLocationTypeProvider);
    final iconLocationSearch =
        locationMapSearch ? FontAwesomeIcons.store : FontAwesomeIcons.fishFins;
    print(locationMapSearch);

    //Markers
    final fishCatchMarkerResults =
        ref.watch(searchedFishCatchesNearbyResultCoordinatesProvider);
    final locationMarkerResults =
        ref.watch(searchedLocationsNearbyResultCoordinatesProvider);

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

    MapController mapController = MapController();

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Map Search')),
        ),
        body: SizedBox(
          child: Column(
            children: [
              //TODO button option for searching both fish catches and locations
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

              //TODO make them button that take them to their page
              Builder(builder: (context) {
                if (gpsMapSearch) {
                  return Container(
                    child: Builder(builder: (context) {
                      if (location == null) {
                        return const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (location is String) {
                          return Text(location);
                        } else {
                          return const SizedBox.shrink();
                        }
                        return Text(location);
                      }
                    }),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Autocomplete(
                          optionsBuilder:
                              (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<
                                  SearchSuggestionModel>.empty();
                            }
                            var suggestions = ref.read(suggestionsProvider);
                            return suggestions(textEditingValue.text);
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Material(
                                elevation: 4.0,
                                child: ListView.separated(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final suggestion = options.elementAt(index);
                                    return ListTile(
                                      title: Text(suggestion.name),
                                      subtitle: Builder(builder: (context) {
                                        if (suggestion.address != null) {
                                          return Text(suggestion.address!);
                                        } else if (suggestion.namePreferred !=
                                            null) {
                                          return Text(
                                              suggestion.namePreferred!);
                                        } else {
                                          return Text(
                                              suggestion.placeFormatted);
                                        }
                                      }),
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();

                                        var searchedLocationResult = await ref
                                            .read(mapboxControllerProvider)
                                            .getPlaceCoordinates(
                                                "${suggestion.name} ${suggestion.placeFormatted}");

                                        ref
                                            .read(searchedLocationProvider
                                                .notifier)
                                            .state = searchedLocationResult;
                                        mapController.move(
                                            searchedLocationResult!, 12.5);
                                        onSelected(suggestion);

                                        ref
                                                .watch(
                                                    searchedFishCatchesNearbyResultCoordinatesProvider
                                                        .notifier)
                                                .state =
                                            await ref
                                                .read(mapboxControllerProvider)
                                                .getSearchedPostsResult(
                                                    searchedLocationResult,
                                                    selectedRadius);

                                        ref
                                                .watch(
                                                    searchedLocationsNearbyResultCoordinatesProvider
                                                        .notifier)
                                                .state =
                                            await ref
                                                .read(mapboxControllerProvider)
                                                .getSearchedLocationsResult(
                                                    searchedLocationResult,
                                                    selectedRadius);
                                      },
                                    );
                                  },
                                  itemCount: options.length,
                                ));
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return TextField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                onTap: onFieldSubmitted,
                                decoration: const InputDecoration(
                                  hintText: "Търсене",
                                  border: OutlineInputBorder(),
                                ));
                          },
                          onSelected: (SearchSuggestionModel selection) {
                            print(selection.name);
                          },
                          displayStringForOption:
                              (SearchSuggestionModel option) => option.name,
                        ),
                      ),
                    ],
                  );
                }
              }),

              Column(
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
                          ref.read(gpsRadiusStateProvider.notifier).state =
                              value!;
                        },
                      ),
                    ],
                  ),
                  Builder(builder: (context) {
                    if (gpsMapSearch &&
                        location != null &&
                        location is! String) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //TODO a shared provider with search markers when changing between search modes make the provider null so when the gps is enabled and the provider is null it searches for locations immediately
                          ElevatedButton(
                            onPressed: () async {

                              mapController.move(
                                  LatLng(location.latitude, location.longitude),
                                  12.5);

                              ref
                                      .watch(
                                          searchedFishCatchesNearbyResultCoordinatesProvider
                                              .notifier)
                                      .state =
                                  await ref
                                      .read(mapboxControllerProvider)
                                      .getSearchedPostsResult(
                                          LatLng(location.latitude,
                                              location.longitude),
                                          selectedRadius);

                              ref.watch(
                                  searchedLocationsNearbyResultCoordinatesProvider
                                      .notifier).state =
                                  await ref
                                      .read(mapboxControllerProvider)
                                      .getSearchedLocationsResult(
                                          LatLng(location.latitude,
                                              location.longitude),
                                          selectedRadius);

                              ref.read(searchedLocationProvider.notifier)
                                  .state =
                                  LatLng(location.latitude, location.longitude);
                            },
                            child: const Text('Поднови'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                mapController.move(
                                    LatLng(
                                        location.latitude, location.longitude),
                                    12.5);
                              },
                              child: const Text("Центрирай")),
                        ],
                      );
                    } else if (!gpsMapSearch && searchedLocation != null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                mapController.move(
                                    LatLng(searchedLocation.latitude,
                                        searchedLocation.longitude),
                                    12.5);
                              },
                              child: const Text("Центрирай")),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  })
                ],
              ),

              Expanded(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      initialCenter: searchedLocation != null
                          ? LatLng(searchedLocation.latitude,
                              searchedLocation.longitude)
                          : const LatLng(42.69, 25.22),
                      initialZoom: searchedLocation != null ? 12.5 : 8.0,
                      keepAlive: true,
                      cameraConstraint: CameraConstraint.contain(
                          bounds: LatLngBounds(
                        const LatLng(-90, -180),
                        const LatLng(90, 180),
                      ))),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.mapbox.com/styles/v1/'
                          'emkoexe/cltljjg6p00kz01nr7wrj1dcs/'
                          'tiles/256/{z}/{x}/{y}@2x?'
                          'access_token=pk.eyJ1IjoiZW1rb2V4ZSIsImEiOiJjbHRsbnowZWYxODhmMnBxdnptZTU4ZDE3In0.Xc_w_0i9kPbpEG8DA42CYg',
                    ),
                    if (locationMapSearch)
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 120,
                          size: const Size(45, 45),
                          markers: locationMarkerResults
                              .map((element) => Marker(
                                    point: LatLng(
                                        element.latitude, element.longitude),
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      icon: Builder(
                                        builder: (context) {
                                          if (element.type.toLowerCase() ==
                                              "store") {
                                            return const Icon(
                                              Icons.store,
                                              color: Colors.orange,
                                              size: 30,
                                            );
                                          } else if (element.type
                                                  .toLowerCase() ==
                                              "fishing_place") {
                                            return const Icon(
                                              FontAwesomeIcons.water,
                                              color: AppColors.primary,
                                              size: 30,
                                            );
                                          } else if (element.type
                                                  .toLowerCase() ==
                                              "event") {
                                            return const Icon(
                                              Icons.event,
                                              color: Colors.teal,
                                              size: 30,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.location_pin,
                                              size: 30,
                                            );
                                          }
                                        },
                                      ),
                                      onPressed: () {
                                        //TODO take to the location post page
                                        print(
                                            "Working location ID: ${element.id}" +
                                                locationMarkerResults.length
                                                    .toString());
                                      },
                                    ),
                                  ))
                              .toList(),
                          polygonOptions: const PolygonOptions(
                              borderColor: Colors.blueAccent,
                              color: Colors.black54,
                              borderStrokeWidth: 3),
                          builder: (context, markers) {
                            return FloatingActionButton(
                              onPressed: null,
                              backgroundColor: Colors.blue,
                              child: Text(markers.length.toString()),
                            );
                          },
                        ),
                      ),
                    if (!locationMapSearch)
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 120,
                          size: const Size(45, 45),
                          markers: fishCatchMarkerResults
                              .map((element) => Marker(
                                    point: LatLng(
                                        element.latitude, element.longitude),
                                    width: 50,
                                    height: 50,
                                    child: IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.fishFins,
                                        color: AppColors.primary,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        //TODO take to the fish catch post page
                                        print("Working post ID: ${element.id}${fishCatchMarkerResults.length}");
                                        Navigator.of(context, rootNavigator:true).push( // ensures fullscreen
                                            CupertinoPageRoute(
                                                builder: (BuildContext context) {
                                                  return IndividualPostPage(element.id);
                                                }
                                            ) );

                                      },
                                    ),
                                  ))
                              .toList(),
                          polygonOptions: const PolygonOptions(
                              borderColor: Colors.blueAccent,
                              color: Colors.black54,
                              borderStrokeWidth: 3),
                          builder: (context, markers) {
                            return FloatingActionButton(
                              onPressed: null,
                              backgroundColor: Colors.blue,
                              child: Text(markers.length.toString()),
                            );
                          },
                        ),
                      ),
                    if (gpsMapSearch && location != null && location is! String)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point:
                                LatLng(location.latitude, location.longitude),
                            width: 80,
                            height: 80,
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
                    if (!gpsMapSearch && searchedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(searchedLocation.latitude,
                                searchedLocation.longitude),
                            width: 80,
                            height: 80,
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
