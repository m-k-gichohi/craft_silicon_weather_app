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

      // List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);

      CoordinatesLocationModel locations = CoordinatesLocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        // longitude: placemarks[0].administrativeArea,
      );

      state = locations; // Update the state with the new location
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
