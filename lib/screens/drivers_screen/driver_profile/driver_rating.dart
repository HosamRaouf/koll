import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/core/models/user_models/user_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/order_widget/order.dart';
import 'package:kol/screens/users_screen/users_screen.dart';

import '../../../components/my_inkwell.dart';
import '../../../core/models/rating_models/driver_rate_model.dart';
import '../../../navigation_animations.dart';
import '../../../styles.dart';
import '../../users_screen/user_profile/user_profile_screen.dart';

class DriverRating extends StatelessWidget {
  DriverRateModel rating;
  DriverRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int index =
        users.indexWhere((element) => element.firestoreId == rating.userId);
    return FutureBuilder(
        future: fetchUser(rating.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else {
            UserModel user = snapshot.data;
            return Container(
              decoration: cardDecoration.copyWith(
                  color: primaryColor,
                  gradient: myGradient,
                  borderRadius: BorderRadius.circular(42.sp)),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(18.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: cardDecoration,
                      child: MyInkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(ScaleTransition5(UserProfile(user: user)));
                        },
                        radius: 28.sp,
                        child: Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  user.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                          fontSize: 48.sp, color: primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 28.sp,
                              ),
                              ClipOval(
                                child: SizedBox(
                                    width: 120.sp,
                                    height: 120.sp,
                                    child: CachedAvatar(
                                      fit: BoxFit.cover,
                                      imageUrl: user.imageUrl,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          rating.rate,
                          (index) => Icon(
                                Iconsax.star1,
                                color: Colors.orange,
                                size: 52.sp,
                              )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(28.sp),
                      child: Text(
                        rating.feedback,
                        style: TextStyling.headline.copyWith(
                            color: Colors.white,
                            fontSize: 52.sp,
                            fontWeight: FontWeight.w400),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(24.sp),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          rating.time,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: smallFontColor,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
