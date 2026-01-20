import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/screens/restaurant_screen/reviews/review.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/reviews_screen.dart';

import '../../../../core/models/restaurant_model.dart';
import '../../../../styles.dart';
import '../../../components/my_flat_button.dart';
import 'package:kol/map.dart';
import '../../../navigation_animations.dart';

class Reviews extends StatelessWidget {
  RestaurantModel restaurant;

  Reviews({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    List sortedReviews = [];
    for (var element in reviews) {
      sortedReviews.add(element);
    }

    sortedReviews.sort((a, b) {
      int cmp = b.rate.compareTo(a.rate);
      if (cmp != 0) return cmp;

      return b.feedback.compareTo(a.feedback);
    });

    return reviews.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 36.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 42.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _title(
                        title: "التقييمات",
                        icon: Iconsax.star1,
                        color: primaryColor),
                    reviews.isEmpty
                        ? Container()
                        : MyFlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  SizeRTLNavigationTransition(ReviewsScreen(
                                    index: 0,
                                  )));
                            },
                            hint: 'عرض الكل',
                            backgroundColor: backGroundColor,
                            fontSize: 36.sp,
                            textColor: primaryColor,
                          )
                  ].reversed.toList(),
                ),
              ),
              sortedReviews.isNotEmpty
                  ? SizedBox(
                      height: 24.sp,
                    )
                  : Container(),
              sortedReviews.isNotEmpty
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                            sortedReviews.length < 5 ? sortedReviews.length : 5,
                            (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 4 ? 42.sp : 21.sp,
                                right: index == 0 ? 42.sp : 21.sp),
                            child: Rating(
                              rate: sortedReviews[index],
                            ),
                          );
                        }).reversed.toList(),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 42.sp,
              ),
            ],
          );
  }
}

Widget _title(
    {required String title, required IconData icon, required Color color}) {
  return Padding(
    padding: EdgeInsets.only(top: 0.sp, bottom: 12.sp, right: 0.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          color: color,
          size: 62.h,
        ),
        SizedBox(
          width: 24.sp,
        ),
        Text(
          title,
          style: TextStyling.subtitle.copyWith(
              fontSize: 52.sp, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
