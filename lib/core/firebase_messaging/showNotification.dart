import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/styles.dart';

showSuccessNotification(BuildContext context,
    {required String title, required String description}) {
  ElegantNotification.success(
    displayCloseButton: false,
    toastDuration: const Duration(milliseconds: 5000),
    animationDuration: const Duration(milliseconds: 1000),
    width: 0.3.sw,
    position: Alignment.topRight,
    animation: AnimationType.fromRight,
    title: Text(
      title,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.headline.copyWith(fontSize: 32.sp),
    ),
    description: Text(
      description,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.subtitle.copyWith(fontSize: 24.sp),
    ),
    onDismiss: () {},
  ).show(context);
}

void showInfoNotification(BuildContext context,
    {required String title, required String description}) {
  ElegantNotification.info(
    displayCloseButton: false,
    toastDuration: const Duration(milliseconds: 5000),
    animationDuration: const Duration(milliseconds: 1000),
    width: 0.3.sw,
    position: Alignment.topRight,
    animation: AnimationType.fromRight,
    title: Text(
      title,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.headline.copyWith(fontSize: 32.sp),
    ),
    description: Text(
      description,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyling.subtitle.copyWith(fontSize: 24.sp),
    ),
    onDismiss: () {},
  ).show(context);
}
