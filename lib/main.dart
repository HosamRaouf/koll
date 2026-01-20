// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/routes/app_routes.dart';
import 'package:kol/screens/splash_screen/splash_screen.dart';
import 'package:kol/styles.dart';
import 'package:kol/themes.dart';

import 'core/check_internet/noInternetListener.dart';
import 'core/firebase_messaging/platform_notifications/notificator.dart';
import 'core/firebase_messaging/initializeng.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await notificationHandler(message);
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await ScreenUtil.ensureScreenSize();

  await Notificator.instance.initialize();

  // Initialize Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  initNoInternetListener();
  requestPermission(); // Requests permissions and prints FCM Token
  notificationListener(); // Sets up foreground listeners

  // Set the status bar style
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: warmColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kIsWeb ? const Size(1920, 1080) : const Size(1080, 1920),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: Themes().lightTheme,
          home: const SplashScreen(),
          onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
          navigatorKey: NamedNavigatorImpl.navigatorState,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
