import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/reviews_screen.dart';

import '../../../../styles.dart';
import '../../../components/cachedAvatar.dart';
import '../../../components/my_inkwell.dart';
import '../../../core/models/rating_models/restaurant_rate_model.dart';
import '../../../navigation_animations.dart';

class Rating extends StatelessWidget {
  RestaurantRate rate;

  Rating({
    super.key,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 90.h, bottom: 24.sp),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: cardDecoration.copyWith(
                gradient: myGradient,
                image: const DecorationImage(
                    image: AssetImage("assets/images/icons2.png"),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                      color: primaryColor, spreadRadius: 1, blurRadius: 4),
                  BoxShadow(color: accentColor),
                ]),
            child: MyInkWell(
              onTap: () {
                // Future.delayed(Duration(milliseconds: 250)).then((value) {
                //   reviewsScrollController.scrollTo(
                //       index: reviews.value
                //           .indexWhere((element) => element.time == rate.time),
                //       duration: Duration(milliseconds: 2000),
                //       curve: Curves.fastEaseInToSlowEaseOut);
                // });
                Navigator.push(
                    context,
                    SizeRTLNavigationTransition(ReviewsScreen(
                      index: 0,
                    )));
              },
              radius: 36.r,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(36.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 62.sp,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                rate.rate.toInt(),
                                (index) => Icon(
                                      Iconsax.star1,
                                      size: 62.sp,
                                      color: Colors.orange,
                                    )),
                          ),
                          SizedBox(
                            height: 24.sp,
                          ),
                          rate.feedback != ''
                              ? SizedBox(
                                  width: 0.4.sw,
                                  child: Text(
                                    rate.feedback,
                                    style: TextStyling.subtitle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: backGroundColor),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                )
                              : Container(),
                          rate.feedback != ''
                              ? SizedBox(
                                  height: 24.sp,
                                )
                              : Container(),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          rate.time,
                          style: TextStyling.smallFont.copyWith(
                              color: backGroundColor.withOpacity(0.7),
                              fontSize: 24.sp),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -12.h),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: cardDecoration.copyWith(
                    color: backGroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: accentColor.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: CachedAvatar(
                              borderRadius: 28.r - 8.sp,
                              fit: BoxFit.cover,
                              imageUrl: rate.userImage,
                            )),
                        SizedBox(
                          width: 12.sp,
                        ),
                        Text(
                          rate.userName,
                          style: TextStyling.headline
                              .copyWith(fontSize: 42.sp, color: primaryColor),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 12.sp,
                        ),
                      ].reversed.toList(),
                    ),
                  ),
                ),
                rate.feedback != ''
                    ? Transform.translate(
                        offset: Offset(-32.sp, 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                                offset: Offset(0, 42.h),
                                child: ClipOval(
                                    child: Container(
                                  width: 36.h,
                                  height: 36.h,
                                  color: backGroundColor,
                                ))),
                            Transform.translate(
                                offset: Offset(0, 77.h),
                                child: ClipOval(
                                    child: Container(
                                  width: 24.h,
                                  height: 24.h,
                                  color: backGroundColor,
                                ))),
                            Transform.translate(
                                offset: Offset(0, 102.h),
                                child: ClipOval(
                                    child: Container(
                                  width: 12.h,
                                  height: 12.h,
                                  color: backGroundColor,
                                )))
                          ]
                              .animate(
                                  autoPlay: true,
                                  onComplete: (controller) {
                                    controller.repeat(reverse: true);
                                  })
                              .fade(
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.fastEaseInToSlowEaseOut),
                        ),
                      )
                    : Container()
              ],
            ),
          )
              .animate(
                autoPlay: true,
                onComplete: (controller) {
                  controller.repeat(
                      reverse: true,
                      period: const Duration(milliseconds: 2000));
                },
                // onInit: (controller) {
                //   controller.animateTo(-1);
                // }
              )
              .slideY(
                  begin: -0.35,
                  end: -0.6,
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeInOut)
        ],
      ),
    );
  }
}
