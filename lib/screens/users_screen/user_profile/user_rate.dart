import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/core/models/rating_models/order_rate_model.dart';
import 'package:kol/screens/home_screen/order_widget/order_driver.dart';
import 'package:kol/screens/restaurant_screen/category_screen/category_screen.dart';
import 'package:kol/map.dart';

import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../core/models/order_model.dart';
import '../../../navigation_animations.dart';
import '../../../styles.dart';

class UserRate extends StatelessWidget {
  OrderRateModel rate;

  UserRate({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    int index = restaurantData.finishedOrders
        .indexWhere((element) => element.id == rate.orderId);
    OrderModel order = restaurantData.finishedOrders[index];
    return Container(
      width: double.infinity,
      decoration: cardDecoration.copyWith(
          image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/icons2.png")

          ),
          gradient: myGradient, borderRadius: BorderRadius.circular(22.sp)),
      child: Padding(
        padding: EdgeInsets.all(24.sp),
        child: Column(
          children: [
            OrderDriver(order: order, radius: 10.sp,),
            SizedBox(height: 24.sp,),
            Column(
              children: List.generate(order.items.length, (index) {
                int categoryIndex = restaurantData.menu.indexWhere(
                    (element) => element.id == order.items[index].categoryId);
                CategoryModel category = restaurantData.menu[categoryIndex];
                int itemIndex = category.items.indexWhere((element) => element.id == order.items[index].id);
                ItemModel item = category.items[itemIndex];
                return Container(
                  decoration: cardDecoration.copyWith(borderRadius: BorderRadius.circular(10.sp)),
                  child: MyInkWell(
                    radius: 10.sp,
                    onTap: () {
                      Navigator.push(context, ScaleTransition5(CategoryScreen(category: category, chosenItem: item)));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${order.items[index].size.price}EGP',
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                fontSize: 36.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 40.sp),
                                child: Text(
                                  '${category.name} - ${item.name} ( ${order.items[index].size.name} )',
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 36.sp,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                  width: 60.sp,
                                  height: 60.sp,
                                child: Image.asset(item.image))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    rate.rate,
                    (index) => Icon(
                          Iconsax.star1,
                          color: Colors.orange,
                      size: 32.sp,
                        )),
              ),
            ),
            Text(
              rate.feedback,
              textAlign: TextAlign.justify,
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
    );
  }
}
