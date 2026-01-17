class LocationModel {
  String name;
  String address;
  double long;
  double lat;

  LocationModel(
      {required this.name,
      required this.long,
      required this.address,
      required this.lat});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
      name: json["name"],
      address: json["address"],
      long: json["long"],
      lat: json["lat"]);

  Map<String, dynamic> toJson() =>
      {"name": name, "address": address, "long": long, "lat": lat};
}
