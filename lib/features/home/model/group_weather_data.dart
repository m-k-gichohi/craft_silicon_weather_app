import 'package:craft_silicon/features/home/model/five_day_weather_data.dart';

class GroupedWeatherData {
  final String date;
  final List<ListElement> entries;

  GroupedWeatherData({
    required this.date,
    required this.entries,
  });
}