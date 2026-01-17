import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/map.dart';

import '../../../styles.dart';

class RestaurantTapBar extends StatelessWidget {
  TabController tabBarController;

  double rates = 0;
  double value = 0;

  RestaurantTapBar({super.key, required this.tabBarController});

  @override
  Widget build(BuildContext context) {

    for (var element in restaurantData.rates) {
      rates = rates+element.rate;
    }

    value = rates / restaurantData.rates.length;

    return Container(
      height: 110.h,
      // color: Colors.white,
      decoration: cardDecoration.copyWith(
          color: backGroundColor, borderRadius: BorderRadius.circular(0)),
      child: Align(
        alignment: Alignment.topCenter,
        child: TabBar(
          indicatorColor: primaryColor,
          overlayColor: MaterialStateProperty.all(primaryColor),
          automaticIndicatorColorAdjustment: true,
          controller: tabBarController,
          labelColor: primaryColor,
          unselectedLabelColor: accentColor,

          labelStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 48.sp,
                color: primaryColor,
              ),
          unselectedLabelStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: 48.sp,
              color: smallFontColor,
              fontWeight: FontWeight.w100),
          tabs: [
            Tab(
              height: 120.sp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                restaurantData.rates.isNotEmpty? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(value.toString(),style: TextStyle(fontSize: 30.sp,
                        textBaseline: TextBaseline.ideographic
                    ),),
                    Transform.translate(
                      offset: const Offset(-2,-2),
                      child: Icon(
                        Iconsax.star1,
                        color: Colors.orange,
                        size: 50.sp,
                      ),
                    ),

                  ],
                ) : Container(),
                Text('التقييمات (${restaurantData.rates.length})'),
              ],
            )),
            const Tab(child: Text('المنيو')),
          ],
        ),
      ),
    );
  }
}
