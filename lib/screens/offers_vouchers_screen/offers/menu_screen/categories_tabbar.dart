
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/menu_models/item_model.dart';
import '../../../../styles.dart';
import '../../../../map.dart';
import 'logic.dart';


class CategoriesTabBar extends StatefulWidget {
  TabController tabBarController;

  CategoriesTabBar({super.key, required this.tabBarController});

  @override
  State<CategoriesTabBar> createState() => _CategoriesTabBarState();
}

class _CategoriesTabBarState extends State<CategoriesTabBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
          splashColor: primaryColor,
          highlightColor: primaryColor,
          primaryColor: primaryColor,
          primaryColorLight: primaryColor,
          focusColor: primaryColor
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.3),blurRadius: 4.0),
          BoxShadow(color: accentColor.withOpacity(0.1),blurRadius: 8.0),
        ]),
        // color: Colors.pink,
        child: Container(
          color: backGroundColor,
          child: TabBar(
            physics: const BouncingScrollPhysics(),
              isScrollable: restaurantData.menu.length-1 > 1,
              indicatorColor: primaryColor,
              splashFactory: InkRipple.splashFactory,
              overlayColor: MaterialStateProperty.all(primaryColor),
              dividerColor: backGroundColor,
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 0.sp),
              tabAlignment: TabAlignment.center,
              onTap: (index) {
          setState(() {
            getItems(index);
            choosenSize = SizeModel(name: '', price: 0, id: '');
            print(index);
          });
              },
              automaticIndicatorColorAdjustment: true,
              controller: widget.tabBarController,
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
              tabs: List.generate(restaurantData.menu.length, (index) => Tab(
                  height: 120.sp,
                  child: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(-2,-2),
                          child: SizedBox(
                              height: 50.sp,
                              width: 50.sp,
                              child: Image.asset(restaurantData.menu[index].image)),
                        ),
                        SizedBox(width: 32.sp,),
                        Text(restaurantData.menu[index].name.toString(),style: TextStyle(fontSize: 60.sp,
                            textBaseline: TextBaseline.ideographic
                        ),),

                      ],
                    ),
                  )),).reversed.toList()
          ),
        ),
      ),
    );
  }
}


