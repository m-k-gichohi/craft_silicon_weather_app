class Helpers {
  static String getWeatherImage(String input) {
    String weather = input.toLowerCase();
    String assetPath = 'assets/icons/';
    switch (weather) {
      case 'thunderstorm':
        return '${assetPath}thunderstorm.jpg';

      case 'drizzle':
      case 'rain':
        return '${assetPath}rainy.jpg';

      case 'snow':
        return '${assetPath}snow.jpg';

      case 'clear':
        return '${assetPath}sunny.jpg';

      case 'clouds':
        return '${assetPath}cloud.jpg';

      case 'mist':
      case 'fog':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'sand':
      case 'ash':
        return '${assetPath}fog.jpg';

      case 'squall':
      case 'tornado':
        return '${assetPath}storm-wind.jpg';

      default:
        return '${assetPath}cloud.jpg';
    }
  }

  static String convertMetersPerSecondToKilometersPerHour(
      double speedInMetersPerSecond) {
    return "${(speedInMetersPerSecond * 3.6).toStringAsFixed(2)} km/hr";
  }
}
