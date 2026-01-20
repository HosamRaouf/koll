import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/cupertino.dart';
import 'package:kol/core/models/area_poly_marker_model.dart';
import 'package:kol/core/models/user_models/location_model.dart';
import 'package:kol/core/models/user_models/user_model.dart';

import 'core/models/rating_models/restaurant_rate_model.dart';
import "core/models/restaurant_model.dart";

late Map<String, dynamic> restaurant;
RestaurantModel restaurantData = RestaurantModel(
    id: "",
    name: "",
    email: "",
    image: "",
    address: "",
    number: "",
    workingDays: [],
    location: AreaPolyMarkerModel(long: 0, lat: 0),
    bannedUsers: [],
    tokens: [],
    areas: [],
    specials: [],
    rating: "",
    menu: [],
    drivers: [],
    offers: [],
    waitingOrders: [],
    finishedOrders: [],
    vouchers: [],
    rates: [],
    color: "");
List<RestaurantRate> reviews = [];
List<Map<String, dynamic>> allUsers = [];
List<UserModel> users = allUsers.map((e) => UserModel.fromJson(e)).toList();

// ignore: close_sinks
ValueNotifier<List<String>> lateOrders = ValueNotifier([]);

CollectionReference restaurants =
    FirebaseFirestore.instance.collection('restaurants');
late DocumentReference restaurantDocument;

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
