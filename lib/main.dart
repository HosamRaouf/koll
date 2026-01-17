import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/routes/app_routes.dart';
import 'package:kol/screens/splash_screen/splash_screen.dart';
import 'package:kol/styles.dart';
import 'package:kol/themes.dart';

import 'core/check_internet/noInternetListener.dart';
import 'core/firebase_messaging/initializeng.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await ScreenUtil.ensureScreenSize();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'call_channel',
            channelName: 'Basic notifications',
            importance: NotificationImportance.Max,
            playSound: true,
            channelDescription: 'Notification channel for basic tests',
            enableVibration: true,
            enableLights: true,
            defaultColor: primaryColor,
            ledColor: primaryColor)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: false);
  initNoInternetListener();
  requestPermission();
  notificationListener();

  // Set the status bar style
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: warmColor, // Transparent status bar
    statusBarIconBrightness:
        Brightness.dark, // Dark icons for light backgrounds
    statusBarBrightness: Brightness.light, // For iOS
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
