import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../styles.dart';

class InternetCheck extends StatefulWidget {
  final Widget child;
  const InternetCheck({super.key, required this.child});

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  final ValueNotifier<ConnectivityResult> _connectivityResult =
      ValueNotifier<ConnectivityResult>(ConnectivityResult.none);

  bool internet = false;

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult.value = result;
      _connectivityResult.notifyListeners();
      handleConnectivityChange(result);
    });

    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      _connectivityResult.value = result;
      _connectivityResult.notifyListeners();
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
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: _connectivityResult,
          builder: (context, connectivityResult, child) {
            return Stack(
              children: [
                widget.child,
                internet
                    ? Container()
                    : Container(
                        color: Colors.black.withOpacity(0.3),
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Container(
                            decoration:
                                cardDecoration.copyWith(color: Colors.white),
                            height: kIsWeb ? 0.6.sh : 0.7.sw,
                            width: kIsWeb ? 0.6.sh : 0.7.sw,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(kIsWeb ? 22.sp : 40.sp),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Iconsax.warning_2,
                                          color: primaryColor,
                                          size: kIsWeb ? 32.sp : 60.sp,
                                        ),
                                        SizedBox(
                                          width: kIsWeb ? 12.sp : 24.sp,
                                        ),
                                        Text(
                                          'لا يوجد انترنت',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .copyWith(
                                                  fontSize:
                                                      kIsWeb ? 32.sp : 60.sp),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: kIsWeb ? 12.sp : 24.sp,
                                    ),
                                    Text(
                                      'من فضلك تأكد من الاتصال بالانترنت',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontSize: kIsWeb ? 22.sp : 42.sp,
                                              color: smallFontColor),
                                    ),
                                    SizedBox(
                                      height: kIsWeb ? 22.sp : 40.sp,
                                    ),
                                    Center(
                                      child: SizedBox(
                                          width: kIsWeb ? 0.2.sw : 0.4.sw,
                                          height: kIsWeb ? 0.2.sw : 0.4.sw,
                                          child: Image.asset(
                                            'assets/images/nointernetavatar.png',
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ).animate().scale(),
                        ),
                      ),
              ],
            );
          }),
    );
  }
}
