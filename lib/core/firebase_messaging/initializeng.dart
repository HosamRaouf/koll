import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kol/core/firebase_messaging/showNotification.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/drivers_screen/drivers_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/reviews_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../../routes/app_routes.dart';
import '../models/driver_model.dart';

var initializationSettingsAndroid =
    const AndroidInitializationSettings('app_icon');

notificationHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('🔔 Handler received message: ${message.messageId}');
  }

  // Handle late orders logic
  if (message.notification?.body != null) {
    List<String> orders = List.from(lateOrders.value);
    orders.add(message.notification!.body!);
    lateOrders.value = orders;
  }

  // Show system notification (Windows/macOS Notification Center)
  // AwesomeNotifications handles the native browser Notification API on Web
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecond,
      channelKey: 'call_channel',
      title: message.notification?.title,
      body: message.notification?.body,
      notificationLayout: NotificationLayout.Default,
      payload:
          message.data.map((key, value) => MapEntry(key, value.toString())),
    ),
  );

  // Additionally show the in-app toast on Web if desired
  if (kIsWeb) {
    showSuccessNotification(NamedNavigatorImpl.navigatorState.currentContext!,
        title: message.notification?.title ?? "",
        description: message.notification?.body ?? "");
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request FCM permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  // Also request AwesomeNotifications permissions for System Notifications
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

notificationListener() {
  final messageStreamController = BehaviorSubject<RemoteMessage>();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    messageStreamController.sink.add(message);
    notificationHandler(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("Data message opened: ${message.data}");
    switch (message.data["click_action"]) {
      case "order":
        {
          showSuccessNotification(
            NamedNavigatorImpl.navigatorState.currentContext!,
            title: message.notification?.title ?? "",
            description: message.notification?.body ?? "",
          );
        }
        break;
      case "driver":
        {
          await restaurantDocument.collection("drivers").get().then((value) {
            restaurantData.drivers.clear();
            for (var element in value.docs) {
              restaurantData.drivers.add(DriverModel.fromJson(element.data()));
            }
          });
          Navigator.push(NamedNavigatorImpl.navigatorState.currentContext!,
              SizeRTLNavigationTransition(const DriversScreen()));
        }
        break;
      case "review":
        {
          Navigator.push(NamedNavigatorImpl.navigatorState.currentContext!,
              SizeRTLNavigationTransition(const RestaurantScreen()));
          Navigator.push(NamedNavigatorImpl.navigatorState.currentContext!,
              SizeRTLNavigationTransition(ReviewsScreen(index: 0)));
        }
        break;
    }
  });
  FirebaseMessaging.onBackgroundMessage(
      (message) => notificationHandler(message));
}
