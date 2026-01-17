import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';
import 'myElevatedButton.dart';
import 'myTextField.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog(
      {Key? key,
      required this.controller,
      required this.description,
      required this.textfield,
      required this.title,
      required this.body,
      required this.firstButton,
      required this.secondButton,
      required this.onFirstButtonPressed,
      required this.onSecondButtonPressed,
      required this.isFirstButtonRed})
      : super(key: key);

  final String title;
  final String description;
  final bool textfield;
  final Widget body;
  final String firstButton;
  final String secondButton;
  final Function() onFirstButtonPressed;
  final Function() onSecondButtonPressed;
  final bool isFirstButtonRed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backGroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28.r))),
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyling.headline.copyWith(
                  fontSize: kIsWeb ? 28 : 52.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: TextStyling.smallFont.copyWith(
                color: Colors.black87,
                fontSize: kIsWeb ? 18 : 34.sp,
              ),
            ),
            if (body is! Container || (body as Container).child != null) ...[
              SizedBox(height: 16.h),
              body,
            ]
          ],
        ),
      ),
      content: textfield
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: kIsWeb ? 450 : double.maxFinite,
                child: MyTextField(
                  descriptionTextField: true,
                  error: "",
                  title: '',
                  isValidatable: true,
                  isExpanding: true,
                  hintText: 'وجّه رسالة للعميل',
                  maxLength: 150,
                  controller: controller,
                  type: 'normal',
                ),
              ),
            )
          : null,
      actionsPadding: EdgeInsets.fromLTRB(24.sp, 0, 24.sp, 24.sp),
      actions: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyElevatedButton(
                fontSize: kIsWeb ? 18 : 36.sp,
                enabled: true,
                width: double.infinity,
                onPressed: () {
                  onFirstButtonPressed();
                  Navigator.of(context).pop();
                },
                text: firstButton,
                gradient: !isFirstButtonRed,
                color: isFirstButtonRed ? paleRed : Colors.transparent,
                textColor: isFirstButtonRed ? Colors.red : Colors.white),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: kIsWeb ? 45 : 100.h,
              child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.clear();
                    onSecondButtonPressed();
                  },
                  child: Text(
                    secondButton,
                    textAlign: TextAlign.center,
                    style: TextStyling.smallFont.copyWith(
                        fontSize: kIsWeb ? 18 : 36.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
