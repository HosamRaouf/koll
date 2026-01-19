import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

Future<void> sendNotification(
  String receiverToken,
  String title,
  String body, {
  required String data,
}) async {
  if (receiverToken.isEmpty) return;

  try {
    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'us-east4')
            .httpsCallable('sendFCMNotification');

    final response = await callable.call(<String, dynamic>{
      'token': receiverToken,
      'title': title,
      'body': body,
      'data': {'payload': data},
    });

    if (response.data['success'] == true) {
      if (kDebugMode) {
        print('✅ Notification sent successfully');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      if (e is FirebaseFunctionsException) {
        print('❌ Firebase Functions Error: [${e.code}] ${e.message}');
        print('❌ Details: ${e.details}');
      } else {
        print('❌ Exception: $e');
      }
    }
  }
}
