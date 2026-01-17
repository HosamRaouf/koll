import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../components/cachedAvatar.dart';
import '../../components/my_inkwell.dart';
import '../../core/models/rating_models/restaurant_rate_model.dart';
import '../../core/models/user_models/user_model.dart';
import '../../navigation_animations.dart';
import '../../styles.dart';
import '../users_screen/user_profile/user_profile_screen.dart';

class RateWidget extends StatelessWidget {
  UserModel user;
  RestaurantRate rate;
  RateWidget({super.key, required this.user, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.sp, vertical: 14.sp),
      child: Container(
        width: double.infinity,
        decoration: cardDecoration.copyWith(
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/icons.png")),
            gradient: myGradient,
            borderRadius: BorderRadius.circular(52.sp)),
        child: Padding(
          padding: EdgeInsets.all(28.sp),
          child: Column(
            children: [
              Container(
                decoration: cardDecoration,
                child: MyInkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(ScaleTransition5(UserProfile(user: user)));
                  },
                  radius: 32.sp,
                  child: Padding(
                    padding: EdgeInsets.all(18.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color: primaryColor,
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 24.sp,
                        ),
                        ClipOval(
                          child: SizedBox(
                              width: 120.sp,
                              height: 120.sp,
                              child: CachedAvatar(
                                imageUrl: user.imageUrl,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      rate.rate.toInt(),
                      (index) => Icon(
                            Iconsax.star1,
                            color: Colors.orange,
                            size: 52.sp,
                          )),
                ),
              ),
              Text(
                rate.feedback,
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 36.sp, color: Colors.white),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  rate.time,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 28.sp, color: smallFontColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
