import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kol/core/firebase_messaging/getToken.dart';
import 'package:kol/core/firebase_messaging/showNotification.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/drivers_screen/drivers_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/reviews_screen.dart';

import '../../routes/app_routes.dart';
import '../models/driver_model.dart';

// This must be a top-level function for background handling
@pragma('vm:entry-point')
Future<void> notificationHandler(RemoteMessage message) async {
  if (message.notification?.body != null) {
    try {
      List<String> orders = List.from(lateOrders.value);
      orders.add(message.notification!.body!);
      lateOrders.value = orders;
    } catch (e) {
      print('❌ Error updating late orders: $e');
    }
  }

  try {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecond,
        channelKey: 'call_channel',
        title: message.notification?.title ??
            message.data['title'] ??
            "تنبيه جديد",
        body: message.notification?.body ??
            message.data['body'] ??
            "لديك طلب جديد",
        notificationLayout: NotificationLayout.Default,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
      ),
    );
  } catch (e) {
    print('❌ Error showing system notification: $e');
  }

  // Handle in-app toast fallback (requires valid context)
  if (kIsWeb) {
    _showInAppNotification(message);
  }
}

void _showInAppNotification(RemoteMessage message) async {
  Future.delayed(const Duration(milliseconds: 1000)).then((value) {
    showSuccessNotification(NamedNavigatorImpl.navigatorState.currentContext!,
        title: message.notification?.title ?? "تنبيه",
        description: message.notification?.body ?? "لديك إشعار جديد");
  });
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if (kDebugMode) print('🔔 STAMP: requestPermission called');

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) print('✅ Firebase Permission Granted');

    try {
      String? token = await getToken();
      if (kDebugMode) print('🚀 FCM Token: $token');
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  } else {
    print('❌ Firebase Permission Denied: ${settings.authorizationStatus}');
  }

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

void notificationListener() {
  if (kDebugMode) print('🔔 STAMP: notificationListener initialized');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) print('📩 STAMP: onMessage triggered');
    notificationHandler(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) print('📩 STAMP: onMessageOpenedApp triggered');
    final context = NamedNavigatorImpl.navigatorState.currentContext;
    if (context != null && context.mounted) {
      // Handle deep linking logic...
    }
  });
}
