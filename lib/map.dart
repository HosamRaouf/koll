import "package:cloud_firestore/cloud_firestore.dart";
import 'package:kol/core/models/user_models/user_model.dart';

import 'core/models/rating_models/restaurant_rate_model.dart';
import "core/models/restaurant_model.dart";

late Map<String, dynamic> restaurant;
late RestaurantModel restaurantData;
List<RestaurantRate> reviews = [];
List<Map<String, dynamic>> allUsers = [];
List<UserModel> users = allUsers.map((e) => UserModel.fromJson(e)).toList();

CollectionReference restaurants =
    FirebaseFirestore.instance.collection('restaurants');
DocumentReference restaurantDocument = restaurants.doc(restaurantData.id);

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
