

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../styles.dart';

class UserProfileTabBar extends StatelessWidget {
  TabController tabBarController;
int ordersNumber;
int ratesNumber;
  UserProfileTabBar({super.key, required this.tabBarController, required this.ordersNumber, required this.ratesNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      // color: Colors.white,
      decoration: cardDecoration.copyWith(color: backGroundColor, borderRadius: BorderRadius.circular(0)),
      child: Align(
        alignment: Alignment.topCenter,
        child: TabBar(
          indicatorColor: primaryColor,
          overlayColor: MaterialStateProperty.all(primaryColor),
          onTap: (index) {},
          automaticIndicatorColorAdjustment: true,
          controller: tabBarController,
          labelColor: primaryColor,
          unselectedLabelColor: accentColor,
          labelStyle: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
            fontSize: 48.sp,
            color: primaryColor,
          ),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(
              fontSize: 48.sp,
              color: smallFontColor,
              fontWeight: FontWeight.w100),
          tabs: [Tab(child: Text('($ratesNumber) التقييمات')), Tab(child: Text('($ordersNumber) الأوردرات'))],
        ),
      ),
    );
  }
}
