import 'dart:developer';

import 'package:craft_silicon/features/home/model/locatin_model.dart';
import 'package:craft_silicon/features/home/repositories/get_current_weather_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentLoaderProvider = StateProvider((ref) => true);

final currentLocationStateProvider =
    StateNotifierProvider<CurrentLocationState, CoordinatesLocationModel>(
        (ref) => CurrentLocationState(ref));

class CurrentLocationState extends StateNotifier<CoordinatesLocationModel> {
  final Ref ref;

  CurrentLocationState(this.ref, [CoordinatesLocationModel? state])
      : super(state ?? CoordinatesLocationModel()) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    ref.read(currentLoaderProvider.notifier).state = true;
    await getPhonePosition();
  }

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

      // List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);
      log("message $position");
      CoordinatesLocationModel locations = CoordinatesLocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        // longitude: placemarks[0].administrativeArea,
      );

      state = locations;

      ref.read(currentLoaderProvider.notifier).state = false;
    }
  }

  updateLocationCoordinates({double? lat, double? long}) {
    state = CoordinatesLocationModel(
      latitude: lat,
      longitude: long,
    );

    ref.read(getCurrentWeatherDataProvider.notifier).updateData();
  }
}
