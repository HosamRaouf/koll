import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/driver_model.dart';
import '../../../styles.dart';

class DriverTabBar extends StatelessWidget {
  final TabController tabBarController;
  final DriverModel driver;
  const DriverTabBar(
      {super.key, required this.tabBarController, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      // color: Colors.white,
      decoration: cardDecoration.copyWith(
          color: backGroundColor, borderRadius: BorderRadius.circular(0)),
      child: TabBar(
        padding: EdgeInsets.zero,
        dividerHeight: 0,
        indicatorColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        overlayColor: MaterialStateProperty.all(primaryColor),
        onTap: (index) {
          tabBarController.index = index;
        },
        automaticIndicatorColorAdjustment: false,
        controller: tabBarController,
        labelColor: primaryColor,
        unselectedLabelColor: accentColor,
        labelStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
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
        tabs: [
          Tab(
            child: Text('التقييمات (${driver.rates.length})'),
          ),
          Tab(child: Text('الأوردرات (${driver.orders.length})'))
        ],
      ),
    );
  }
}
