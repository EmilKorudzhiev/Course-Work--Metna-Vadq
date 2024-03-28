import 'dart:async';

import 'package:MetnaVadq/features/exceptions/gps_location_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final isPositionActiveProvider = StateProvider<bool>((ref) {
  return false;
});

final positionProvider = StreamProvider.autoDispose<Position?>((ref) {
  if (!ref.watch(isPositionActiveProvider)) {
    return const Stream.empty();
  } else {
    final locationController = ref.watch(locationControllerProvider);
    return Stream.periodic(const Duration(seconds: 1), (i) {
      return locationController.getCurrentPosition();
    }).asyncMap((event) async {
      return await event;
    });
  }
});

final locationControllerProvider = Provider((ref) {
  return const LocationController();
});

class LocationController {
  const LocationController();

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw GpsLocationException('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw GpsLocationException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw GpsLocationException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
