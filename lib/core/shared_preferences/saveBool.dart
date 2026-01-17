

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveBooleanValue(bool value, {required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
  print('Boolean value saved: $value');
}