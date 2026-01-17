import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/firestore_database/fetch/fetchAll.dart';
import 'package:kol/core/shared_preferences/getBool.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/login_screen/login_screen.dart';
import 'package:kol/screens/no_internet_screen.dart';
import 'package:kol/styles.dart';
import 'package:rive/rive.dart';

import '../../core/firebase_auth/loginusingemailandpassword.dart';
import '../../core/shared_preferences/getPreference.dart';
import '../../navigation_animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
      handleConnectivityChange(result);
    });
    Connectivity().checkConnectivity().then(
        (value) => value == ConnectivityResult.none ? null : _loadMainScreen());
    super.initState();
  }

  void _loadMainScreen() async {
    String? email;
    String? password;
    await getPreference(key: "password").then((value) {
      password = value!;
    });
    await getPreference(key: "email").then((value) {
      email = value!;
    });
    await getBooleanValue(key: 'rememberMe').then((value) {
      print("value $value");
      value == false
          ? {
              Timer(
                  const Duration(seconds: 3),
                  () => Navigator.pushReplacement(
                      context, ScaleTransition5(const LoginScreen())))
            }
          : {
              signInWithEmailPassword(email!, password!, onError: (e) {
                print(e.code);
                Navigator.of(context).pop();
              }, onSuccess: () async {
                await fetchAllData().then((value) {
                  Navigator.of(context)
                      .pushReplacement(ScaleTransition5(const HomeScreen(
                    isKitchen: false,
                  )));
                });
              }, onLoading: () {}, onLoadingComplete: () {})
            };
    });

    print(email);
  }

  void handleConnectivityChange(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        print('Connected to the internet.');
        break;
      case ConnectivityResult.none:
        print('No internet connection.');
        break;
      case ConnectivityResult.bluetooth:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ConnectivityResult.ethernet:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ConnectivityResult.vpn:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ConnectivityResult.other:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return SafeArea(
            child: InternetCheck(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: myGradient,
                    image: const DecorationImage(
                        image: AssetImage("assets/images/icons.png"),
                        fit: BoxFit.cover)),
                child: Center(
                  child: SizedBox(
                      width: 1.sw,
                      child: const RiveAnimation.asset(
                        "assets/riv/logo.riv",
                        artboard: "New Artboard",
                      )),
                ),
              )
                  .animate(
                    delay: const Duration(milliseconds: 100),
                    autoPlay: true,
                  )
                  .shimmer(),
            ],
          ),
        ));
      },
      designSize: const Size(1080, 1920),
    );
  }
}
