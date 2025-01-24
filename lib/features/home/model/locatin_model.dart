import 'package:geolocator/geolocator.dart';

class PickUpLocationModel {
  final Position? phonePosition;
  final String? userAddress;

  // PickUpLocationModel(this.userAddress);
  PickUpLocationModel({this.phonePosition, this.userAddress});
}