import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../components/my_alert_dialog.dart';
import '../../../../core/models/day_model.dart';
import '../../../../styles.dart';

class RemoveDayAlert extends StatefulWidget {
  DayModel day;
  Function() onDelete;

  RemoveDayAlert({super.key, required this.day, required this.onDelete});

  @override
  State<RemoveDayAlert> createState() => _RemoveDayAlertState();
}

class _RemoveDayAlertState extends State<RemoveDayAlert> {
  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
        controller: TextEditingController(),
        description: '',
        textfield: false,
        title: "إزالة يوم ${widget.day.day} ؟",
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('مواعيد العمل',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: primaryColor, fontSize: 40.sp),
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('من',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: smallFontColor, fontSize: 36.sp),
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl),
                  Text(widget.day.openAt,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 40.sp),
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl),
                ].reversed.toList(),
              ),
              SizedBox(
                height: 24.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('إلى',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: smallFontColor, fontSize: 36.sp),
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl),
                  Text(widget.day.closeAt,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 40.sp),
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl),
                ].reversed.toList(),
              ),
            ],
          ),
        ),
        firstButton: "إزالة",
        secondButton: "إلغاء",
        onFirstButtonPressed: ()  {
          widget.onDelete();
        },
        onSecondButtonPressed: () {},
        isFirstButtonRed: true);
  }
}


