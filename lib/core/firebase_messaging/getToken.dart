import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<String?> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Use VAPID key for Web to enable notifications
  String? token = await messaging.getToken(
    vapidKey: kIsWeb
        ? "BNHzL-3mfuabg7qG8Ds1DMwDX_O4EK9rTdPdwbUshhHQqvW0LvA-Vc0l1Hkfo2xZkCg3FpYO-Bk-fcAhrjR_gE0"
        : null, // Replace with your actual VAPID key from Firebase Console
  );

  return token;
}
