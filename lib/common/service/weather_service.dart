import 'package:craft_silicon/common/helpers/offline/weather_db_helper.dart';

class WeatherService {
  static const String currentWeatherId = 'current_weather';
  static const String forecastId = 'forecast_weather';

  // Save current weather
  static Future<void> saveCurrentWeather(
      Map<String, dynamic> weatherData) async {
    await WeatherDbHelper.saveWeatherData(currentWeatherId, weatherData);
  }

  // Save forecast
  static Future<void> saveForecast(Map<String, dynamic> forecastData) async {
    await WeatherDbHelper.saveWeatherData(forecastId, forecastData);
  }
}
