import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/working_hours_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';

import '../../../../components/loading.dart';
import '../../../../components/myElevatedButton.dart';
import '../../../../components/my_inkwell.dart';
import '../../../../components/showTimePicker.dart';
import '../../../../components/show_snack_bar.dart';
import '../../../../core/models/day_model.dart';
import '../../../../styles.dart';
import '../../../home_screen/home_screen.dart';

class AddDay extends StatefulWidget {
  final DayModel day;
  const AddDay({super.key, required this.day});

  @override
  State<AddDay> createState() => _AddDayState();
}

class _AddDayState extends State<AddDay> {
  addDay() {
    if (widget.day.closeAt == '' && widget.day.openAt == '') {
      setState(() {
        error = 'أدخل مواعيد العمل كي تتم إضافة اليوم';
      });
    } else if (widget.day.openAt == '') {
      setState(() {
        error = 'أدخل ميعاد الفتح كي تتم إضافة اليوم';
      });
    } else if (widget.day.closeAt == '') {
      setState(() {
        error = 'أدخل ميعاد الإغلاق كي تتم إضافة اليوم';
      });
    } else {
      List<Map<String, dynamic>> workingDays = [];
      for (var element in restaurantData.workingDays) {
        workingDays.add(element.toJson());
      }
      workingDays.add(widget.day.toJson());
      showDialog(
          context: context,
          builder: (context) => const Loading(),
          barrierDismissible: false);
      restaurantDocument.update({'workingDays': workingDays}).then((value) {
        setState(() {
          error = '';
          restaurantData.workingDays.clear();
          for (var element in workingDays) {
            restaurantData.workingDays.add(DayModel.fromJson(element));
          }
          restaurant['workingDays'] = workingDays;
          Navigator.pushAndRemoveUntil(
              context,
              ScaleTransition5(const HomeScreen(
                isKitchen: false,
              )),
              (route) => false);
          Navigator.push(context, ScaleTransition5(const RestaurantScreen()));
          Navigator.push(context, ScaleTransition5(const WorkingHoursScreen()));
          showSnackBar(
              context: context,
              message: 'تم إضافة يوم ${widget.day.day} بنجاح');
          saveMap();
        });
      });
    }
  }

  String error = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(36.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "أضف يوم ${widget.day.day} إلى أيام العمل",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 72.sp),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(
            height: 40.sp,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "من",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      shadows: [],
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 42.sp),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Container(
                  height: 0.05.sh,
                  decoration: cardDecoration.copyWith(
                    color: warmColor,
                  ),
                  child: MyInkWell(
                    radius: 36.r,
                    onTap: () {
                      showDialogTimePicker(context, (value) {
                        setState(() {
                          widget.day.openAt = value.format(context);
                          error = '';
                        });
                      });
                    },
                    child: Center(
                      child: Text(
                        widget.day.openAt == ''
                            ? 'اختر ساعة'
                            : widget.day.openAt,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 40.sp, color: smallFontColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "إلى",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      shadows: [],
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 42.sp),
                ),
                SizedBox(
                  height: 12.sp,
                ),
                Container(
                  height: 0.05.sh,
                  decoration: cardDecoration.copyWith(
                    color: warmColor,
                  ),
                  child: MyInkWell(
                    radius: 36.r,
                    onTap: () {
                      showDialogTimePicker(context, (value) {
                        setState(() {
                          widget.day.closeAt = value.format(context);
                          error = '';
                        });
                      });
                    },
                    child: Center(
                      child: Text(
                        widget.day.closeAt == ''
                            ? 'اختر ساعة'
                            : widget.day.closeAt,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 40.sp, color: smallFontColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
          SizedBox(
            height: 48.sp,
          ),
          error == ''
              ? Container()
              : Center(
                  child: Padding(
                  padding: EdgeInsets.all(24.sp),
                  child: Text(
                    error,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 40.sp, color: Colors.red),
                  ),
                )),
          MyElevatedButton(
            onPressed: () {
              addDay();
            },
            text: 'إضافة',
            width: double.infinity,
            enabled: true,
            fontSize: 60.sp,
            textColor: Colors.white,
            color: Colors.transparent,
            gradient: true,
          )
        ],
      ),
    );
  }
}
