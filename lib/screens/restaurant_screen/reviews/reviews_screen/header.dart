import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/map.dart';

import '../../../../../components/back_arrow_button.dart';
import '../../../../../styles.dart';

class ReviewsHeader extends StatelessWidget {
  const ReviewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: myGradient,
        image: const DecorationImage(
            image: AssetImage('assets/images/icons2.png'), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.all(42.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 100.h,
                  width: 100.h,
                  child: const BackArrowButton(),
                ),
                SizedBox(
                  width: 42.sp,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      restaurantData.name,
                      textDirection: TextDirection.rtl,
                      style: TextStyling.headline
                          .copyWith(fontSize: 64.sp, color: backGroundColor),
                    ),
                    Text(
                      'التقييمات',
                      textDirection: TextDirection.rtl,
                      style: TextStyling.headline.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 42.sp,
                          color: backGroundColor),
                    )
                  ],
                )
              ].reversed.toList(),
            ),
            Row(
              children: [
                Icon(
                  Iconsax.star1,
                  size: 52.sp,
                  color: Colors.orangeAccent,
                ),
                SizedBox(
                  width: 12.sp,
                ),
                Text(
                  double.parse(restaurantData.rating)
                      .toStringAsFixed(1)
                      .toString(),
                  style: TextStyling.headline.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 42.sp),
                ),
                SizedBox(
                  width: 12.sp,
                ),
                Text(
                  "( ${reviews.length.toString()} )",
                  style: TextStyling.headline.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 32.sp),
                ),
              ].reversed.toList(),
            )
          ].reversed.toList(),
        ),
      ),
    );
  }
}
