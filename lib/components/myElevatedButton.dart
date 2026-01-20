import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/show_snack_bar.dart';

import '../styles.dart';

class MyElevatedButton extends StatefulWidget {
  MyElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.gradient,
      this.color,
      this.textColor,
      required this.width,
      required this.enabled,
      required this.fontSize})
      : super(key: key);
  GestureTapCallback onPressed;
  String text;
  bool? gradient = true;
  Color? color = Colors.transparent;
  Color? textColor = Colors.white;
  double width;
  bool enabled;
  double fontSize;

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool internet = false;

  @override
  void initState() {
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      _connectivityResult = result;
      handleConnectivityChange(result);
    });
    super.initState();
  }

  void handleConnectivityChange(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        internet = true;
        break;
      case ConnectivityResult.none:
        // No internet connection
        internet = false;
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
    return Container(
      height: kIsWeb ? 50.sp : 100.h,
      width: widget.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.gradient!
                ? primaryColor.withOpacity(0.25)
                : widget.color!.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
        gradient: !widget.enabled
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black12, Colors.white24],
              )
            : widget.gradient!
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor, accentColor],
                  )
                : const LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                  ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ElevatedButton(
        onPressed: () {
          internet
              ? widget.onPressed()
              : showSnackBar(context: context, message: 'لا يوجد انترنت');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              !widget.gradient! ? widget.color : Colors.transparent,
          shadowColor: !widget.gradient! ? widget.color : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          maxLines: 1,
          widget.text,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: widget.textColor,
              fontWeight: FontWeight.w800,
              fontSize: widget.fontSize),
        ),
      ),
    );
  }
}
