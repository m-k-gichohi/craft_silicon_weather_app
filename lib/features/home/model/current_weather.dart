import 'package:craft_silicon/features/home/model/main_model.dart';
import 'package:craft_silicon/features/home/model/weather_model.dart';
import 'package:craft_silicon/features/home/model/wind_model.dart';

class CurrentWeatherDataModel {
  Coord? coord;
  List<Weather>? weather;
  String? base;
  Main? main;
  int? visibility;
  Wind? wind;
      CurrentRain? rain;

  Clouds? clouds;
  int? dt;
  Sys? sys;
  int? timezone;
  int? id;
  String? name;
  int? cod;

  CurrentWeatherDataModel({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.rain,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  factory CurrentWeatherDataModel.fromJson(Map<String, dynamic> json) =>
      CurrentWeatherDataModel(
        coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
        weather: json["weather"] == null
            ? []
            : List<Weather>.from(
                json["weather"]!.map((x) => Weather.fromJson(x))),
        base: json["base"],
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        visibility: json["visibility"],
        wind: json["wind"] == null ? null : Wind.fromJson(json["wind"]),
                rain: json["rain"] == null ? null : CurrentRain.fromJson(json["rain"]),

        clouds: json["clouds"] == null ? null : Clouds.fromJson(json["clouds"]),
        dt: json["dt"],
        sys: json["sys"] == null ? null : Sys.fromJson(json["sys"]),
        timezone: json["timezone"],
        id: json["id"],
        name: json["name"],
        cod: json["cod"],
      );
}


class CurrentRain {
    double? the1H;

    CurrentRain({
        this.the1H,
    });

    factory CurrentRain.fromJson(Map<String, dynamic> json) => CurrentRain(
        the1H: json["1h"]?.toDouble(),
    );

  
}

class Clouds {
  int? all;

  Clouds({
    this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class Coord {
  double? lon;
  double? lat;

  Coord({
    this.lon,
    this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}

class Sys {
  int? type;
  int? id;
  String? country;
  int? sunrise;
  int? sunset;

  Sys({
    this.type,
    this.id,
    this.country,
    this.sunrise,
    this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(
        type: json["type"],
        id: json["id"],
        country: json["country"],
        sunrise: json["sunrise"],
        sunset: json["sunset"],
      );
}
