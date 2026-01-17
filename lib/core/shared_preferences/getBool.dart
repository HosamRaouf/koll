

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getBooleanValue({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(key) ?? false;
  print('Retrieved boolean value: $value');
  return value;
}