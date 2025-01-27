import 'package:intl/intl.dart';

class DateTimeHelpers {
  static DateTime intDateConvert(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return dateTime;
  }

  static String extractDate(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime.toLocal());
  }

  static String extractTime(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);
    var formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime.toLocal());
  }

  static String extractTimeWithAmPm(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);
    var formatter = DateFormat('h:mm a');
    return formatter.format(dateTime.toLocal()).toLowerCase();
  }

  static String formatTimestamp(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);
    return getCustomFormat(dateTime);
  }

  static DateTime getdate(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);
    return dateTime;
  }

  static String getCustomFormat(DateTime dateTime) {
    var formatter = DateFormat('EEE d : h:mm a');
    return formatter.format(dateTime.toLocal()).toLowerCase();
  }

  static String getFullDateTime(int timestamp) {
    DateTime dateTime = intDateConvert(timestamp);

    var formatter = DateFormat('EEEE dd MMM, h:mm a');
    return formatter.format(dateTime.toLocal());
  }
}
