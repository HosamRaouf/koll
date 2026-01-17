

import 'package:shared_preferences/shared_preferences.dart';

Future<void> removePreference({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}