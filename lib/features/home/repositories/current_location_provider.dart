import 'dart:developer';

import 'package:craft_silicon/features/home/model/locatin_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentLoaderProvider = StateProvider((ref) => true);

final currentLocationStateProvider =
    StateNotifierProvider<CurrentLocationState, PickUpLocationModel>(
        (ref) => CurrentLocationState(ref));

class CurrentLocationState extends StateNotifier<PickUpLocationModel> {
  final Ref ref;

  CurrentLocationState(this.ref, [PickUpLocationModel? state])
      : super(state ?? PickUpLocationModel()) {
    _initializeLocation();
  }

  /// Initialize location when the provider is created
  Future<void> _initializeLocation() async {
    ref.read(currentLoaderProvider.notifier).state = true; // Start loading
    await getPhonePosition(); // Fetch the phone position
    ref.read(currentLoaderProvider.notifier).state = false; // End loading
  }

  /// Get the current phone position using Geolocator
  Future<void> getPhonePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      log("placemark ${placemarks[0].toJson()}");

            log("placemark ${position.latitude}");

      PickUpLocationModel locations = PickUpLocationModel(
        phonePosition: position,
        userAddress: placemarks[0].administrativeArea,
      );

      state = locations; // Update the state with the new location
    }
  }
}

// import 'dart:developer';

// import 'package:craft_silicon/features/home/model/locatin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:geocoding/geocoding.dart';

// part 'current_location_provider.g.dart';

// @Riverpod(keepAlive: true)
// class CurrentLocationProvider extends _$CurrentLocationProvider {
//   @override
//   Future<PickUpLocationModel?> build() async {
//     return await _getCurrentLocation();
//   }

//   Future<PickUpLocationModel?> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       debugPrint('Location services are disabled.');
//       return null;
//     }

//     // Check for location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         debugPrint('Location permissions are denied');
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       debugPrint('Location permissions are permanently denied');
//       return null;
//     }

//     // Get current position
//     try {
//       final LocationSettings locationSettings = LocationSettings(
//         accuracy: LocationAccuracy.best,
//       );

//       Position position = await Geolocator.getCurrentPosition(
//           locationSettings: locationSettings);

//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);

//       log("placemark ${placemarks[0].toJson()}");

//       log("placemark ${position.latitude}");
//       log("placemark ${position.longitude}");

//       PickUpLocationModel locations = PickUpLocationModel(
//         phonePosition: position,
//         userAddress: placemarks[0].administrativeArea,
//       );

//       return  locations;
//     } catch (e) {
//       debugPrint('Error getting location: $e');
//       return null;
//     }
//   }

//   // Method to refresh location
//   Future<void> refreshLocation() async {
//     state = AsyncValue.loading();
//     state = await AsyncValue.guard(_getCurrentLocation);
//   }
// }
