import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/menu_screen/categories_tabbar.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/menu_screen/item_info.dart';

import 'logic.dart';

class MenuScreen extends StatefulWidget {
  Function() onAddMeal;
  MenuScreen({super.key, required this.onAddMeal});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabBarController = TabController(
        length: restaurantData.menu.length,
        vsync: this,
        initialIndex: restaurantData.menu.length - 1);

    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) => Scaffold(
              body: BlankScreen(
                  title: "أضف صنف",
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CategoriesTabBar(
                            tabBarController: tabBarController),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabBarController,
                          children: List.generate(restaurantData.menu.length,
                              (categoryIndex) {
                            getItems(categoryIndex);
                            return ItemInfo(
                              thisItem: thisItem,
                              category: firstCategory,
                              addMeal: () {
                                widget.onAddMeal();
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  )),
            ));
  }
}
