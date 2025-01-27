class CitiesDataModel {
  String? name;
  Map<String, String>? localNames;
  double? lat;
  double? lon;
  String? country;
  String? state;

  CitiesDataModel({
    this.name,
    this.lat,
    this.lon,
    this.country,
    this.state,
  });

  factory CitiesDataModel.fromJson(Map<String, dynamic> json) =>
      CitiesDataModel(
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        country: json["country"],
        state: json["state"],
      );
}
