import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/drivers_screen/drivers_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/reviews_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../../routes/app_routes.dart';
import '../models/driver_model.dart';

var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

notificationHandler(RemoteMessage message) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: -1, // -1 is replaced by a random number
        channelKey: 'call_channel',
        title: message.notification?.title,
        body: message.notification?.body,
        bigPicture: message.data["image"],
        notificationLayout: NotificationLayout.BigPicture,
        customSound: message.data["sound"],
        category: NotificationCategory.Alarm,
        badge: 1,
        duration: const Duration(milliseconds: 650),
        displayOnBackground: true,
        displayOnForeground: true,
        criticalAlert: true,
        roundedBigPicture: true,
        locked: true,
        timeoutAfter: const Duration(milliseconds: 650),
        wakeUpScreen: true,
        payload: {'notificationId': message.messageId}),
  );
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

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
// Handle incoming data message when the app is in the background or terminated
    print("Data message opened: ${message.data}");
    switch (message.data["click_action"]) {
      case "order":
        {}
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

// void loadFCM() async {
//   if (!kIsWeb) {
//     channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       importance: Importance.high,
//       enableVibration: true,
//     );
//
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }

// void listenFCM() async {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: 'launch_background',
//           ),
//         ),
//       );
//     }
//   });
// }
