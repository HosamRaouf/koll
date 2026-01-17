import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  return token;
}
