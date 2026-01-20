import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/models/menu_models/category_model.dart';

import '../../../core/models/menu_models/item_model.dart';
import 'package:kol/map.dart';
import 'most_ordered_widget.dart';

class MostOrdered extends StatefulWidget {
  static List<ItemModel> allItems = [];
  static List<Widget> itemWidgets = [];

  static rebuildMostOrdered() {
    itemWidgets.clear();
    allItems.clear();

    for (var element in restaurantData.menu) {
      List<ItemModel> items = element.items;
      items.isNotEmpty
          ? items.forEach((element) {
              allItems.add(element);
            })
          : false;
    }

    allItems.sort((b, a) => a.ordered.compareTo(b.ordered));

    if (allItems.isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        CategoryModel category;
        ItemModel item;
        List<CategoryModel> categories;
        int categoryIndex;

        i < allItems.length
            ? {
                item = allItems[i],
                categories = restaurantData.menu,
                categoryIndex = categories.indexWhere((element) {
                  return element.items
                          .indexWhere((element) => element.id == item.id) >=
                      0;
                }),
                category = restaurantData.menu[categoryIndex],
                if (item.ordered > 2)
                  {
                    itemWidgets.add(MostOrderedWidget(
                      category: category,
                      item: item,
                    ))
                  }
              }
            : {false};
      }
      itemWidgets = itemWidgets.reversed.toList();
    } else {}
  }

  const MostOrdered({super.key});

  @override
  State<MostOrdered> createState() => _MostOrderedState();
}

class _MostOrderedState extends State<MostOrdered> {
  @override
  Widget build(BuildContext context) {
    return MostOrdered.itemWidgets.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 40.sp),
                  child: Text(
                    'الأكثر طلباً',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 40.sp),
                  ),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: MostOrdered.itemWidgets,
                  ),
                ),
                SizedBox(
                  height: 40.sp,
                )
              ],
            ),
          )
        : Container();
  }
}
