import 'dart:convert';

import 'package:kol/core/firestore_database/fetch/fetchAll.dart';
import 'package:kol/core/models/restaurant_model.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../map.dart';

Future<Map<String, dynamic>?> getMap() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? mapString = prefs.getString('restaurant');

  if (mapString != null) {
    Map<String, dynamic> map = jsonDecode(mapString);
    restaurant = map;
    restaurantData = RestaurantModel.fromJson(map);
    print(
        "================================================ 📝✅ Data Recovered from Cache ✅📝 ==========================================");
  } else {
    await fetchAllData();
    await saveMap();
  }
  return null;
}
