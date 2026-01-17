import 'dart:convert';

import 'area_poly_marker_model.dart';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));

String areaModelToJson(AreaModel data) => json.encode(data.toJson());

class AreaModel {
  List<AreaPolyMarkerModel> markers;
  int fee;

  AreaModel({
    required this.markers,
    required this.fee,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    markers: List<AreaPolyMarkerModel>.from(json["markers"].map((x) => AreaPolyMarkerModel.fromJson(x))),
    fee: json["fee"],
  );

  Map<String, dynamic> toJson() => {
    "markers": List<dynamic>.from(markers.map((x) => x.toJson())),
    "fee": fee,
  };
}