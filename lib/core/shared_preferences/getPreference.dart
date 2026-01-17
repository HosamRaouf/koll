import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getPreference({required String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedValue = prefs.getString(key) ?? '';
  return storedValue;
}