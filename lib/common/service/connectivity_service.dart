import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static Future<bool> hasInternetConnection() async {
    // First check if we have wifi/mobile data connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Then verify if we can actually reach the internet
    return await InternetConnectionChecker.instance.hasConnection;
  }
}
