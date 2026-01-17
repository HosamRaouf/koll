class AreaPolyMarkerModel {
  double long;
  double lat;

  AreaPolyMarkerModel({
    required this.long,
    required this.lat,
  });

  factory AreaPolyMarkerModel.fromJson(Map<String, dynamic> json) => AreaPolyMarkerModel(
    long: json["long"]?.toDouble(),
    lat: json["lat"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "long": long,
    "lat": lat,
  };
}