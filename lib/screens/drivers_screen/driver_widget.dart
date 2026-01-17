import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/screens/drivers_screen/driver_profile/driver_profile.dart';

import '../../core/models/driver_model.dart';
import '../../navigation_animations.dart';
import '../../styles.dart';

class DriverWidget extends StatelessWidget {
  DriverModel driver;
  bool deleteIcon;

  DriverWidget({super.key, 
    required this.driver,
    required this.deleteIcon,
  });
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: cardDecoration,
        child: MyInkWell(
          onTap: () {
            deleteIcon
                ? Navigator.push(
                    context,
                    ScaleTransition5(DriverProfile(
                      driver: driver,
                    )))
                : false;
          },
          radius: 24.r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              driver.image != 'assets/images/user.png'
                  ? SizedBox(
                      height: 200.h,
                      width: 0.375.sw,
                      child: Padding(
                        padding: EdgeInsets.all(8.sp),
                        child: Container(
                            decoration: BoxDecoration(
                                color: warmColor,
                                borderRadius: BorderRadius.circular(24.r)),
                            child: CachedAvatar(
                              imageUrl: driver.image,
                              fit: BoxFit.cover,
                              borderRadius: 24.r,
                            )),
                      ))
                  : Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Container(
                        decoration: BoxDecoration(
                            color: warmColor,
                            borderRadius: BorderRadius.circular(24.r)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: SizedBox(
                              height: 200.h,
                              width: 0.375.sw,
                              child: Padding(
                                  padding: EdgeInsets.all(12.sp),
                                  child: Image.asset(
                                      "assets/images/delivery.png"))),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 0.32.sw,
                      child: Text(
                        driver.name,
                        overflow: TextOverflow.ellipsis,
                        // textAlign: TextAlign.end,
                        maxLines: 1,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 36.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
