import 'dart:convert';

import 'package:kol/core/models/rating_models/restaurant_rate_model.dart';
import 'package:kol/core/models/voucher_model.dart';

import 'area_model.dart';
import 'area_poly_marker_model.dart';
import 'day_model.dart';
import 'driver_model.dart';
import 'menu_models/category_model.dart';
import 'offer_model.dart';
import 'order_model.dart';

RestaurantModel restaurantModelFromJson(String str) =>
    RestaurantModel.fromJson(json.decode(str));

String restaurantModelToJson(RestaurantModel data) =>
    json.encode(data.toJson());

class RestaurantModel {
  String id;
  String name;
  String email;
  String image;
  String address;
  String number;
  String rating;
  List<DayModel> workingDays;
  AreaPolyMarkerModel location;
  List<String> bannedUsers;
  List<String> tokens;
  List<AreaModel> areas;
  List<dynamic> specials;
  List<CategoryModel> menu;
  List<DriverModel> drivers;
  List<OfferModel> offers;
  List<OrderModel> waitingOrders;
  List<OrderModel> finishedOrders;
  List<VoucherModel> vouchers;
  List<RestaurantRate> rates;
  String color;

  RestaurantModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.image,
      required this.address,
      required this.number,
      required this.workingDays,
      required this.location,
      required this.bannedUsers,
      required this.tokens,
      required this.areas,
      required this.specials,
      required this.rating,
      required this.menu,
      required this.drivers,
      required this.offers,
      required this.waitingOrders,
      required this.finishedOrders,
      required this.vouchers,
      required this.rates,
      required this.color});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        address: json["address"],
        color: json["color"],
        rating: json['rating'],
        number: json["number"].toString(),
        bannedUsers: List<String>.from(json["bannedUsers"].map((x) => x)),
        tokens: List<String>.from(json["tokens"].map((x) => x)),
        workingDays: List<DayModel>.from(
            json["workingDays"].map((x) => DayModel.fromJson(x))),
        location: AreaPolyMarkerModel.fromJson(json["location"]),
        areas: List<AreaModel>.from(
            json["areas"].map((x) => AreaModel.fromJson(x))),
        specials: List<dynamic>.from(json["specials"].map((x) => x)),
        menu: List<CategoryModel>.from(
            json["menu"].map((x) => CategoryModel.fromJson(x))),
        drivers: List<DriverModel>.from(
            json["drivers"].map((x) => DriverModel.fromJson(x))),
        offers: List<OfferModel>.from(
            json["offers"].map((x) => OfferModel.fromJson(x))),
        waitingOrders: List<OrderModel>.from(
            json["ordersWaiting"].map((x) => OrderModel.fromJson(x))),
        finishedOrders: List<OrderModel>.from(
            json["finishedOrders"].map((x) => OrderModel.fromJson(x))),
        vouchers: List<VoucherModel>.from(
            json["vouchers"].map((x) => VoucherModel.fromJson(x))),
        rates: List<RestaurantRate>.from(
            json["ratings"].map((x) => RestaurantRate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "address": address,
        "number": number,
        "rating": rating,
        "bannedUsers": bannedUsers,
        "tokens": tokens,
        "color": color,
        "workingDays": List<dynamic>.from(workingDays.map((x) => x)),
        "location": location.toJson(),
        "areas": List<dynamic>.from(areas.map((x) => x)),
        "specials": List<dynamic>.from(specials.map((x) => x)),
        "menu": List<dynamic>.from(menu.map((x) => x)),
        "drivers": List<dynamic>.from(drivers.map((x) => x)),
        "offers": List<dynamic>.from(offers.map((x) => x)),
        "ordersWaiting": List<dynamic>.from(waitingOrders.map((x) => x)),
        "finishedOrders": List<dynamic>.from(finishedOrders.map((x) => x)),
        "vouchers": List<dynamic>.from(vouchers.map((x) => x)),
        "ratings": List<dynamic>.from(rates.map((x) => x)),
      };
}
