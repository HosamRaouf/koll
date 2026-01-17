

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(
      context)
      .showSnackBar(
      SnackBar(
          backgroundColor: Colors.black.withOpacity(0.5),
          content:
          Text(
            message,
            textAlign:
            TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(
                color: Colors.white,
                fontSize: 40.sp),
          )));
}