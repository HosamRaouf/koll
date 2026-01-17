import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/models/restaurant_model.dart';
import '../../../../styles.dart';

class RestaurantTitleAndRate extends StatelessWidget {
  final RestaurantModel restaurant;
  final Color primaryColor;
  final bool isHeader;
  final String restaurantRating;

  const RestaurantTitleAndRate(
      {super.key,
      required this.restaurant,
      required this.primaryColor,
      this.isHeader = true,
      required this.restaurantRating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Special Icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    restaurant.specials.length,
                    (index) => Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: SizedBox(
                              height: kIsWeb ? 28.sp : 50.h,
                              width: kIsWeb ? 28.sp : 50.h,
                              child: Image.asset(restaurant.specials[index])),
                        )).reversed.toList(),
              ),
              SizedBox(width: 24.sp),

              // Restaurant Name
              Flexible(
                child: Text(
                  restaurant.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  style: TextStyling.headline.copyWith(
                      fontSize: kIsWeb ? 32.sp : 62.sp, color: primaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.sp),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Address
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      restaurant.address,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      style: TextStyling.subtitle.copyWith(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: kIsWeb ? 18.sp : 36.sp),
                    ),
                  ),
                  SizedBox(width: 12.sp),
                  Icon(
                    Icons.location_on_rounded,
                    size: kIsWeb ? 24.sp : 52.sp,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    double.parse(restaurantRating).toStringAsFixed(1),
                    style: TextStyling.headline.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: kIsWeb ? 18.sp : 42.sp),
                  ),
                  SizedBox(width: 12.sp),
                  Icon(
                    Iconsax.star1,
                    size: kIsWeb ? 24.sp : 52.sp,
                    color: Colors.orangeAccent,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
