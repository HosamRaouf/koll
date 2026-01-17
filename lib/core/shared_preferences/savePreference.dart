import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePreference({required String key, required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}