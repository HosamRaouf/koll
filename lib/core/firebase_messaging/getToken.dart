import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<String?> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Use VAPID key for Web to enable notifications
  String? vapidKey = kDebugMode
      ? "BNHzL-3mfuabg7qG8Ds1DMwDX_O4EK9rTdPdwbUshhHQqvW0LvA-Vc0l1Hkfo2xZkCg3FpYO-Bk-fcAhrjR_gE0"
      : const String.fromEnvironment('FCM_VAPID_KEY');

  if (kIsWeb && vapidKey.isEmpty) {
    if (kDebugMode) {
      print(
          '⚠️ Warning: FCM_VAPID_KEY is not defined. FCM will not work on web.');
    }
    return null;
  }

  int retryCount = 0;
  const maxRetries = 3;

  while (retryCount < maxRetries) {
    try {
      String? token = await messaging.getToken(
        vapidKey: kIsWeb ? vapidKey : null,
      );
      print(token);
      return token;
    } catch (e) {
      if (kIsWeb && e.toString().contains('AbortError')) {
        retryCount++;
        if (kDebugMode) {
          print(
              '⏳ Service Worker not ready, retrying ($retryCount/$maxRetries)...');
        }
        await Future.delayed(Duration(seconds: 2 * retryCount));
      } else {
        rethrow;
      }
    }
  }

  return "";
}
