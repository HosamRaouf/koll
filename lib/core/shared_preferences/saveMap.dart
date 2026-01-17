import 'dart:convert';

import 'package:kol/core/shared_preferences/getMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../map.dart';

Future<void> saveMap() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String mapString = jsonEncode(restaurant);
  prefs.setString('restaurant', mapString);
  print(
      "================================================ 📝 Data saved to cache 📝 ==========================================");
  await getMap();
}
