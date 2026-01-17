// ignore_for_file: use_build_context_synchronously

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/my_alert_dialog.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/showLoading.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/home_screen/order_widget/order.dart';
import 'package:kol/screens/users_screen/user_profile/user_profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../components/cachedAvatar.dart';
import '../../../../../core/models/rating_models/restaurant_rate_model.dart';
import '../../../../../styles.dart';

class ReviewWidget extends StatelessWidget {
  RestaurantRate rate;
  bool reportable;

  ReviewWidget({super.key, required this.rate, required this.reportable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Container(
        color: backGroundColor,
        child: Padding(
          padding: EdgeInsets.all(42.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MyInkWell(
                    radius: 28.r,
                    onTap: () async {
                      showLoading(context);
                      await fetchUser(rate.userId).then((value) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            SizeRTLNavigationTransition(
                                UserProfile(user: value)));
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: CachedAvatar(
                                borderRadius: 28.r,
                                imageUrl: rate.userImage,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(
                            width: 24.sp,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                rate.userName,
                                style: TextStyling.headline.copyWith(
                                    fontSize: 48.sp, color: primaryColor),
                                textAlign: TextAlign.right,
                              ),
                              !reportable
                                  ? FittedBox(
                                      child: Row(
                                        children: List.generate(
                                            5,
                                            (index) => Icon(
                                                  Iconsax.star1,
                                                  color: rate.rate >= index + 1
                                                      ? Colors.orange
                                                      : smallFontColor,
                                                  size: 42.sp,
                                                )),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        ].reversed.toList(),
                      ),
                    ),
                  ),
                  reportable
                      ? FittedBox(
                          child: Row(
                            children: List.generate(
                                5,
                                (index) => Icon(
                                      Iconsax.star1,
                                      color: rate.rate >= index + 1
                                          ? Colors.orange
                                          : smallFontColor,
                                      size: 42.sp,
                                    )),
                          ),
                        )
                      : Container()
                ].reversed.toList(),
              ),
              rate.feedback != ''
                  ? Padding(
                      padding: EdgeInsets.all(42.sp),
                      child: Text(
                        rate.feedback,
                        style: TextStyling.subtitle
                            .copyWith(color: Colors.black54, fontSize: 48.sp),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  rate.time,
                  style: TextStyling.smallFont
                      .copyWith(color: smallFontColor, fontSize: 24.sp),
                ),
              ),
              SizedBox(
                height: 24.sp,
              ),
              reportable ? reportButton(context, rate) : Container()
            ],
          ),
        ),
      ),
    );
  }
}

Widget reportButton(BuildContext context, RestaurantRate rate) {
  return Stack(
    alignment: Alignment.center,
    children: [
      MyElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => MyAlertDialog(
                  controller: TextEditingController(),
                  description:
                      "هنبعت التقييم دا للإدارة للمراجعة ولو فيه حاجة مسيئة هيتم حذفه فورًا",
                  textfield: false,
                  title: "تبليغ",
                  body: Padding(
                    padding: EdgeInsets.only(top: 42.sp),
                    child: ReviewWidget(
                      rate: rate,
                      reportable: false,
                    ),
                  ),
                  firstButton: "تبليغ",
                  secondButton: "إلغاء",
                  onFirstButtonPressed: () async {
                    showLoading(context);
                    await reportUser(rate, context);
                    Navigator.pop(context);
                  },
                  onSecondButtonPressed: () {},
                  isFirstButtonRed: true));
        },
        text: "تبليغ",
        width: double.infinity,
        enabled: true,
        fontSize: 42.sp,
        gradient: true,
        textColor: backGroundColor,
      ),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.all(24.sp),
            child: Icon(
              Icons.report,
              color: backGroundColor,
              size: 72.sp,
            ),
          ),
          Container(
            width: 1,
            height: 72.sp,
            color: backGroundColor,
          )
        ],
      )
    ],
  );
}

reportUser(RestaurantRate rate, BuildContext context) async {
  print("Reporting rate📡");
  await launchUrlString(
      'mailto:raoufkoll2@gmail.com?subject=تبليغ من مطعم ${restaurantData.name}&body=${Uri.encodeComponent('${rate.userName} ( ${rate.userId} )\n ${rate.rate} نجوم\n ${rate.feedback}\n ${rate.time}')}');

  showSnackBar(context: context, message: "تم التبليغ، إستنى رد من الإدارة على الgmail");
}
