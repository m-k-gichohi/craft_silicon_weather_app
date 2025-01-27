import 'package:craft_silicon/features/home/model/five_day_weather_data.dart';
import 'package:craft_silicon/features/home/model/group_weather_data.dart';
import 'package:intl/intl.dart';

List<GroupedWeatherData> groupWeatherData(List<ListElement> weatherList) {
  Map<String, List<ListElement>> tempGrouped = {};

  for (var entry in weatherList) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(entry.dt! * 1000);
    String dateKey = DateFormat('EEEE, MMMM d, yyyy').format(dateTime);

    tempGrouped.putIfAbsent(dateKey.toString(), () => []).add(entry);
  }

  return tempGrouped.entries
      .map((entry) => GroupedWeatherData(date: entry.key, entries: entry.value))
      .toList();
}
