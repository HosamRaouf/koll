import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/loading.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';

import '../../../../components/myElevatedButton.dart';
import '../../../../core/models/day_model.dart';
import '../../../../styles.dart';
import 'package:kol/map.dart';
import '../../logic.dart';

class WorkingHoursModalBottomSheet extends StatefulWidget {
  String opensAt;
  String closeAt;

  WorkingHoursModalBottomSheet(
      {super.key, required this.closeAt, required this.opensAt});

  @override
  State<WorkingHoursModalBottomSheet> createState() =>
      _WorkingHoursModalBottomSheetState();
}

class _WorkingHoursModalBottomSheetState
    extends State<WorkingHoursModalBottomSheet> {
  late Future<TimeOfDay?> selectedTime;

  void showDialogTimePicker(
      BuildContext context, Function(TimeOfDay value) onChanged) {
    selectedTime = showTimePicker(
      confirmText: 'تعديل',
      cancelText: 'إلغاء',
      hourLabelText: 'اختر الساعة',
      minuteLabelText: 'ختر الدقيقة',
      errorInvalidText: 'برجاء استخدام الأرقام فقط',
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            textTheme: Theme.of(context).textTheme,
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        onChanged(value);
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  List<DayModel> daysOfWork = [];

  @override
  void initState() {
    for (var element in restaurantData.workingDays) {
      daysOfWork.add(element);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 24.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 24.sp,
          ),
          Text(
            'مواعيد العمل',
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 60.0.sp, color: primaryColor),
          ),
          SizedBox(
            height: 24.sp,
          ),
          Center(
            child: MyScrollConfigurations(
              horizontal: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(days.length, (index) {
                    bool isSelected =
                        daysOfWork.contains(days.reversed.toList()[index])
                            ? true
                            : false;

                    return Padding(
                      padding: EdgeInsets.only(left: 24.sp),
                      child: Container(
                        width: 150.h,
                        height: 95.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withOpacity(0.5)
                              : warmColor,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: isSelected ? primaryColor : Colors.black,
                            // Border color
                            width: 1.0, // Border width
                          ),
                        ),
                        child: MyInkWell(
                          onTap: () {
                            setState(() {
                              isSelected = !isSelected;
                              daysOfWork.contains(
                                      daysModels.reversed.toList()[index])
                                  ? daysOfWork.remove(
                                      daysModels.reversed.toList()[index])
                                  : daysOfWork
                                      .add(daysModels.reversed.toList()[index]);
                            });
                          },
                          radius: 24.sp,
                          child: Center(
                            child: Text(
                              days.reversed.toList()[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.black,
                                      fontSize: 36.sp),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60.sp,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'إلى',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: primaryColor,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: warmColor,
                        borderRadius: BorderRadius.circular(25.r)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            showDialogTimePicker(
                              context,
                              (value) {
                                setState(() {
                                  widget.closeAt = value.format(context);
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.sp, vertical: 32.sp),
                            child: Center(
                                child: Text(
                              widget.closeAt,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 48.sp, color: smallFontColor),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 60.sp,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'من',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: primaryColor,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: warmColor,
                        borderRadius: BorderRadius.circular(25.r)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            showDialogTimePicker(
                              context,
                              (value) {
                                setState(() {
                                  widget.opensAt = value.format(context);
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.sp, vertical: 32.sp),
                            child: Center(
                                child: Text(
                              widget.opensAt,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 48.sp, color: smallFontColor),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 60.sp,
              ),
            ],
          ),
          SizedBox(
            height: 24.sp,
          ),
          MyElevatedButton(
            onPressed: () {
              setState(() {
                restaurantData.workingDays = daysOfWork;
                restaurant['workingDays'] = daysOfWork;

                showDialog(
                    context: context, builder: (context) => const Loading());

                restaurantDocument.update({'workingDays': daysOfWork});

                saveMap();

                print(restaurant['workingDays']);
                print(restaurantData.workingDays);

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                showSnackBar(
                    context: context, message: 'تم تغيير مواعيد العمل بنجاح');
              });
            },
            text: 'حفظ',
            width: double.infinity,
            enabled: true,
            fontSize: 48.sp,
            color: Colors.transparent,
            gradient: true,
            textColor: Colors.white,
          ),
          SizedBox(
            height: 24.sp,
          )
        ],
      ),
    );
  }
}
