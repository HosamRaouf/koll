import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/no_internet_screen.dart';
import '../styles.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetCheck(
      child: PopScope(
        canPop: false,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: 0.3.sw,
              height: 0.3.sw,
              decoration: cardDecoration,
              child: Padding(
                padding: EdgeInsets.all(102.sp),
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
