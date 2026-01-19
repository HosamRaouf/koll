import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<String?> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Use VAPID key for Web to enable notifications
  String? token = await messaging.getToken();

  return token;
}
