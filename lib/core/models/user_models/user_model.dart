// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:kol/core/models/user_models/user_order_data.dart';

import '../order_model.dart';
import '../rating_models/driver_rate_model.dart';
import '../rating_models/order_rate_model.dart';
import '../rating_models/restaurant_rate_model.dart';
import 'location_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String name;
  String email;
  String firestoreId;
  List<String> phoneNumbers;
  String imageUrl;
  List<LocationModel> locations;
  List<UserOrderDataModel> orders;
  List<OrderRateModel> orderrates;
  List<DriverRateModel> driverrates;
  List<RestaurantRate> restaurantrates;
  List<OrderModel> finishedOrders;
  List<String> vouchers;
  List<String> tokens;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.firestoreId,
      required this.phoneNumbers,
      required this.imageUrl,
      required this.locations,
      required this.orders,
      required this.driverrates,
      required this.orderrates,
      required this.restaurantrates,
      required this.finishedOrders,
      required this.vouchers,
      required this.tokens});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phoneNumbers: List<String>.from(json["phoneNumbers"].map((x) => x)),
        firestoreId: json["firestoreId"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        locations: List<LocationModel>.from(
            json["locations"].map((x) => LocationModel.fromJson(x))),
        orders: List<UserOrderDataModel>.from(
            json["orders"].map((x) => UserOrderDataModel.fromJson(x))),
        driverrates: List<DriverRateModel>.from(
            json["driverrates"].map((x) => DriverRateModel.fromJson(x))),
        finishedOrders: List<OrderModel>.from(
            json["finishedOrders"].map((x) => OrderModel.fromJson(x))),
        orderrates: List<OrderRateModel>.from(
            json["orderrates"].map((x) => OrderRateModel.fromJson(x))),
        restaurantrates: List<RestaurantRate>.from(
            json["restaurantrates"].map((x) => RestaurantRate.fromJson(x))),
        vouchers: List<String>.from(json["vouchers"].map((x) => x)),
        tokens: List<String>.from(json["tokens"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "firestoreId": firestoreId,
        "email": email,
        "phoneNumbers": List<dynamic>.from(phoneNumbers.map((x) => x)),
        "imageUrl": imageUrl,
        "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "driverrates": List<dynamic>.from(driverrates.map((x) => x.toJson())),
        "orderrates": List<dynamic>.from(orderrates.map((x) => x.toJson())),
        "finishedOrders":
            List<dynamic>.from(finishedOrders.map((x) => x.toJson())),
        "restaurantrates":
            List<dynamic>.from(restaurantrates.map((x) => x.toJson())),
        "vouchers": List<dynamic>.from(vouchers.map((x) => x)),
        "tokens": List<dynamic>.from(tokens.map((x) => x)),
      };
}
