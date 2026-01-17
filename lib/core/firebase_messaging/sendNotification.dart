import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class NotificationService {
  static const _serviceAccountJson = {
    "type": "service_account",
    "project_id": "koll-8ca48",
    "private_key_id": "ecea7890846aa0c55acfd57d03e16650cfcb01d4",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbT7WokyMyu8mT\nNdgGrKLDYd7qTM6lNv1JNiW5QMzNbU0vbceLrCsQsxq0+G3TaAeSz8LSt2wKCJRs\nDe5IhiNSmyQ1sAhsPZUnwStmTRHVy66kSfoVHuMuy8SxHl83XR84nGmIwQzeCjL9\n6aeMnJGBVMh/cbZ/Qn8iSwCU1sx0apUjAcvNHKGUFZOZ2A4azKHUlGdy5bjtb9pi\niCRa1SRlBkRjvU1k/nIGdOxzgNtM3Y3FsGZg1RcnDaqqUpBEgLco0SZSMx2ROfu7\nMj3aM7qkN68IXIyPIcv10BWPdXArFdspqPxLTuv+IlRSSjOmG7zG7MzcuZLQTIon\n0jhbwra3AgMBAAECggEADfU4Gboo0nvpo0HBCY8v94g5skE3McZDNXZY0JEqzBbT\ny3yTD5HoXZFYcprVtUdRpZeSEOxBbkC+z1vh0NcWoJYRxy4Wq7JNz9X+nQHgevWE\nW1PMq7jsE5NmOMFxLuFpwhAzNIJJB5bPZgi+2+u28J0agchJ7Z5Kcl4JjiwkZsfe\nJMAiZ3lac9BN03x1u9ol7mExdi8m7yII/QYjaLnHNuVJosXU3DxmedibtqoqsG0c\nXpivw4BjJUpk83z5HcqhVZbKq0sUPimluZMIyXNwtFvlCn7lVoOgddfj39stGEXI\nV09yjhwFywuJyHw0C6dWJx4qqcaxJDBvn2T77Iy4KQKBgQDTsAOO1pH37ulffeL/\nvZi9V7bva6XEfi/V8dK2pICYyBfWVpYzCwgtSRA43LA0RO2HRJ8FIlU84r3Q3SVA\nq3nnkzbV+vUCnLZq3yR03E5yQE1MuKyVZiO+8ZRyOfTxsdvx1mdqHf0STL7pjp9W\nanlxd6AUQ00evkMuIcrv4kX4WQKBgQC70pbFV+nGIQsR8qOK/iwV5hDqkC41dbwi\nAhmWtJOHQkzRxXWHfQiwN6YTvjME/Y7ntSht8wubZuEOUbf+verdZYoxEkv4DpNo\nCVyfJn8N4Ynu0rFbOEdtewV0/0QFsc0HABacqf6zBzHuxAQH3u3Hcm8tKOKhXalt\nL1vYKQVFjwKBgEecMXfuii6POY8+LL5KyxKyS4YuqkMQVOpRBfEXMRF+DuJJJEJc\nJwX6w2wY69qivp+VzR2VgbQ5F/FB/kokN/bozBIS9TNPBD6fAdwucrMfoYakqm1X\nwhvj6U3C4WOpwTfMSeuR/XxlTegAgVJgbni9+P8hzULrJhrC/72qk/TxAoGAQOdx\n0Hojv6K1h5s4ZpSUuXCKUfRG85Re0cW1//0gqfIAR9EbXxmXAgYI7vOf/857LpjM\ngsolLatshB07Ht2UJrOrAHAZLnwi9iWeCyUrbKmOl6fZP/N/w1ZquVZotCsP9aZT\nKgoYiNcoqyCzX+DqfCyQPKPPRQHvxVpDO7xZJQMCgYEAjJcDbXneUs0Z3+nL8fM9\nF0394PnNoFAnpxFigaXaypey8OQk9cyttaRVO0v7HeD2+MwTDMqBPUHkuj1r/A2n\npjSniyP7pkQehHMlxTnJX5gCK8pGMFCyZmCU46JHz3PnWq7Qn2HpM1j6YHKbqGkj\nIY5XCj+dVRey4kJ/l6vfkes=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-lpot1@koll-8ca48.iam.gserviceaccount.com",
    "client_id": "108177023005886015034",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-lpot1%40koll-8ca48.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  static Future<String> getAccessToken() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final credentials =
        auth.ServiceAccountCredentials.fromJson(_serviceAccountJson);
    final client = await auth.clientViaServiceAccount(credentials, scopes);
    return client.credentials.accessToken.data;
  }
}

Future<void> sendNotification(
  String receiverToken,
  String title,
  String body, {
  required String data,
}) async {
  if (receiverToken.isEmpty) return;

  try {
    final String accessToken = await NotificationService.getAccessToken();
    const String projectId = "koll-8ca48";
    String url =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    // CORS Bypass for Web
    if (kIsWeb) {
      url = 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'message': {
          'token': receiverToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'payload': data,
          },
        }
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent successfully (Web & Mobile)');
    } else {
      print('❌ Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
}
