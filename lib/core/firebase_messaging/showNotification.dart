import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/styles.dart';

showSuccessNotification(BuildContext context,
    {required String title, required String description}) {
  if (kDebugMode) {
    print('🔔 Toast Details - Title: $title, Desc: $description');
  }

  // Fallback for empty content
  String displayTitle = (title.isEmpty) ? "تنبيه جديد" : title;
  String displayDesc =
      (description.isEmpty) ? "لديك طلب جديد في القائمة" : description;

  // Use a fixed width if sw is too small (common on Web initialization)
  double toastWidth = 0.3.sw;
  if (kIsWeb && toastWidth < 300) toastWidth = 400;

  ElegantNotification.success(
    displayCloseButton: true,
    toastDuration: const Duration(milliseconds: 5000),
    animationDuration: const Duration(milliseconds: 1000),
    width: toastWidth,
    position: Alignment.topRight,
    animation: AnimationType.fromRight,
    title: Text(
      displayTitle,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.headline.copyWith(fontSize: kIsWeb ? 24 : 32.sp),
    ),
    description: Text(
      displayDesc,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.subtitle.copyWith(fontSize: kIsWeb ? 18 : 24.sp),
    ),
    onDismiss: () {},
  ).show(context);
}

void showInfoNotification(BuildContext context,
    {required String title, required String description}) {
  double toastWidth = 0.3.sw;
  if (kIsWeb && toastWidth < 300) toastWidth = 400;

  ElegantNotification.info(
    displayCloseButton: true,
    toastDuration: const Duration(milliseconds: 5000),
    animationDuration: const Duration(milliseconds: 1000),
    width: toastWidth,
    position: Alignment.topRight,
    animation: AnimationType.fromRight,
    title: Text(
      title,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.headline.copyWith(fontSize: kIsWeb ? 24 : 32.sp),
    ),
    description: Text(
      description,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.subtitle.copyWith(fontSize: kIsWeb ? 18 : 24.sp),
    ),
    onDismiss: () {},
  ).show(context);
}
