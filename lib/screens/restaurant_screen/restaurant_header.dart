import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/restaurant_screen/restaurant_title_and_rate.dart';

import '../../../styles.dart';
import '../../core/models/restaurant_model.dart';

class RestaurantHeader extends StatelessWidget {
  final bool opened;
  final bool isWeb;
  final RestaurantModel restaurant;

  const RestaurantHeader(
      {super.key,
      required this.restaurant,
      required this.opened,
      required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 24.sp : 42.sp, vertical: isWeb ? 24.sp : 42.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status Badge
                Container(
                  decoration: cardDecoration.copyWith(
                      boxShadow: [], color: opened ? Colors.green : Colors.red),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 16.sp : 24.sp,
                        vertical: isWeb ? 8.sp : 12.sp),
                    child: Text(
                      opened ? 'مفتوح الآن' : "مغلق الآن",
                      style: TextStyling.subtitle.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: isWeb ? 24.sp : 36.sp),
                    ),
                  ),
                ),

                // Restaurant Info
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: RestaurantTitleAndRate(
                            restaurantRating: restaurantData.rating,
                            restaurant: restaurantData,
                            primaryColor: primaryColor,
                            isHeader: true),
                      ),
                      SizedBox(width: 20.sp),
                      SizedBox(
                        width: isWeb ? 80.sp : 120.sp,
                        height: isWeb ? 80.sp : 120.sp,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedAvatar(imageUrl: restaurant.image),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.sp),
          ],
        ),
      ),
    );
  }
}
