import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/loading.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/add_day_modal_sheet.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/remove_day.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/working_hours_screen.dart';

import '../../../../components/showTimePicker.dart';
import '../../../../core/models/day_model.dart';
import '../../../../styles.dart';
import '../../../home_screen/home_screen.dart';
import '../../restaurant_screen.dart';

class DayWidget extends StatefulWidget {
  DayModel day;

  DayWidget({super.key, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

late Future<TimeOfDay?> selectedTime;

class _DayWidgetState extends State<DayWidget> {
  Future<void> updateTime(String openOrClose) async {
    showDialogTimePicker(context, (time) async {
      List<Map<String, dynamic>> workingDays = [];
      for (var element in restaurantData.workingDays) {
        workingDays.add(element.toJson());
      }

      if (openOrClose == 'openAt') {
        workingDays[workingDays
                .indexWhere((element) => element['day'] == widget.day.day)]
            ['openAt'] = time.format(context);
      } else {
        workingDays[workingDays
                .indexWhere((element) => element['day'] == widget.day.day)]
            ['closeAt'] = time.format(context);
      }

      showDialog(
          context: context,
          builder: (context) => const Loading(),
          barrierDismissible: false);
      await restaurantDocument
          .update({'workingDays': workingDays}).then((value) {
        setState(() {
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
              message: 'تم التعديل إلى ${time.format(context)} بنجاح');
          saveMap();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 62.sp, left: 36.sp, right: 36.sp, bottom: 62.sp),
      child: Container(
        width: double.infinity,
        decoration: cardDecoration.copyWith(
            boxShadow: [],
            color: widget.day.openAt == ''
                ? smallFontColor.withOpacity(0.3)
                : primaryColor.withOpacity(0.3),
            border: Border.fromBorderSide(BorderSide(
                color: widget.day.openAt == '' ? warmColor : primaryColor))),
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.day.day,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: Colors.white, fontSize: 60.sp),
                        textAlign: TextAlign.end,
                        textDirection: TextDirection.rtl),
                    widget.day.openAt == ''
                        ? MyInkWell(
                            onTap: () {
                              primaryBottomSheet(
                                  child: AddDay(day: widget.day),
                                  context: context);
                            },
                            radius: 24.sp,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24.sp, horizontal: 40.sp),
                              child: Text(
                                "إضافة",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 48.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                  ].reversed.toList(),
                ),
              ),
              widget.day.openAt != ''
                  ? Row(
                      children: [
                        MyInkWell(
                          radius: 36.r,
                          onTap: () {
                            updateTime('openAt').then((value) {
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24.sp),
                            child: Row(
                              children: [
                                Text('من',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 36.sp),
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.rtl),
                                SizedBox(
                                  width: 24.sp,
                                ),
                                Text(widget.day.openAt,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 42.sp,
                                            fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.rtl),
                              ].reversed.toList(),
                            ),
                          ),
                        ),
                        MyInkWell(
                          radius: 36.r,
                          onTap: () {
                            updateTime('closeAt');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24.sp),
                            child: Row(
                              children: [
                                Text('إلى',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 36.sp),
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.rtl),
                                SizedBox(
                                  width: 24.sp,
                                ),
                                Text(widget.day.closeAt,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 42.sp,
                                            fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.end,
                                    textDirection: TextDirection.rtl),
                              ].reversed.toList(),
                            ),
                          ),
                        ),
                      ].reversed.toList(),
                    )
                  : Container(),
              widget.day.openAt != ''
                  ? MyInkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (my) => RemoveDayAlert(
                                  day: widget.day,
                                  onDelete: () {
                                    List<Map<String, dynamic>> workingDays = [];

                                    for (var element
                                        in restaurantData.workingDays) {
                                      workingDays.add(element.toJson());
                                    }

                                    workingDays.remove(workingDays[
                                        workingDays.indexWhere((element) =>
                                            element['day'] == widget.day.day)]);

                                    if (workingDays.isEmpty) {
                                      showDialog(
                                          context: my,
                                          builder: (my1) => AlertDialog(
                                                backgroundColor:
                                                    backGroundColor,
                                                actions: [
                                                  MyElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(my1);
                                                    },
                                                    text: 'حسناً',
                                                    width: double.infinity,
                                                    enabled: true,
                                                    fontSize: 52.sp,
                                                    gradient: true,
                                                    textColor: Colors.white,
                                                    color: Colors.transparent,
                                                  )
                                                ],
                                                content: SizedBox(
                                                  height: 0.2.sw,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(24.sp),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text('لا يمكن !',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                    fontSize:
                                                                        72.sp,
                                                                    color:
                                                                        primaryColor),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl),
                                                        Text(
                                                            'يوجد يوم واحد في أيام العمل الخاصة بك، لا يمكن الحذف',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayMedium!
                                                                .copyWith(
                                                                    fontSize:
                                                                        36.sp,
                                                                    color:
                                                                        smallFontColor),
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => const Loading(),
                                          barrierDismissible: false);
                                      restaurantDocument.update({
                                        'workingDays': workingDays
                                      }).then((value) {
                                        restaurantData.workingDays.clear();

                                        for (var element in workingDays) {
                                          restaurantData.workingDays
                                              .add(DayModel.fromJson(element));
                                        }
                                        restaurant['workingDays'] = workingDays;
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            ScaleTransition5(const HomeScreen(
                                              isKitchen: false,
                                            )),
                                            (route) => false);
                                        Navigator.push(
                                            context,
                                            ScaleTransition5(
                                                const RestaurantScreen()));
                                        Navigator.push(
                                            context,
                                            ScaleTransition5(
                                                const WorkingHoursScreen()));
                                        showSnackBar(
                                            context: context,
                                            message:
                                                'تم إزالة يوم ${widget.day.day} بنجاح');
                                        saveMap();
                                      });
                                    }
                                  },
                                ));
                      },
                      radius: 24.sp,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 24.sp, horizontal: 40.sp),
                        child: Text(
                          'إزالة',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                        ),
                      ),
                    )
                  : Container()
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }
}
