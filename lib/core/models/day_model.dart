
// To parse this JSON data, do
//
//     final dayModel = dayModelFromJson(jsonString);

import 'dart:convert';

DayModel dayModelFromJson(String str) => DayModel.fromJson(json.decode(str));

String dayModelToJson(DayModel data) => json.encode(data.toJson());

class DayModel {
  String day;
  String openAt;
  String closeAt;

  DayModel({
    required this.day,
    required this.openAt,
    required this.closeAt,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) => DayModel(
    day: json["day"],
    openAt: json["openAt"],
    closeAt: json["closeAt"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "openAt": openAt,
    "closeAt": closeAt,
  };
}
