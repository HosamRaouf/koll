// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

import 'package:kol/core/models/rating_models/driver_rate_model.dart';

import 'order_model.dart';

DriverModel driverModelFromJson(String str) =>
    DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  String id;
  String firestoreId;
  String name;
  String phoneNumber;
  String image;
  List<OrderModel> orders;
  List<DriverRateModel> rates;

  DriverModel({
    required this.id,
    required this.firestoreId,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.orders,
    required this.rates,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        firestoreId: json["firestoreId"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        image: json["image"],
        orders: List<OrderModel>.from(json["orders"].map((x) => x)),
        rates: List<DriverRateModel>.from(
            json["rates"].map((x) => DriverRateModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firestoreId": firestoreId,
        "name": name,
        "phoneNumber": phoneNumber,
        "image": image,
        "orders": List<dynamic>.from(orders.map((x) => x)),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
}
