import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/models/menu_models/item_model.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/order_widget/order_driver.dart';
import 'package:kol/screens/home_screen/order_widget/rate.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../../styles.dart';

class UserOrder extends StatefulWidget {
  OrderModel order;
  UserOrder({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<UserOrder> createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
    int total = 0;
    return Padding(
      padding: EdgeInsets.only(bottom: 40.sp),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          decoration: cardDecoration.copyWith(
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 24.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الطلبات',
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 42.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 24.sp,
                    ),
                    Column(
                        children:
                            List.generate(widget.order.items.length, (index) {
                      String itemId = widget.order.items[index].id;
                      String itemCategoryId =
                          widget.order.items[index].categoryId;
                      SizeModel itemSize = widget.order.items[index].size;
                      String size = itemSize.name;
                      int price = itemSize.price.round();
                      total = total + price;
                      int categoryIndex = restaurantData.menu.indexWhere(
                          (element) => element.id == itemCategoryId);
                      CategoryModel category =
                          restaurantData.menu[categoryIndex];
                      int itemIndex = restaurantData.menu[categoryIndex].items
                          .indexWhere((element) => element.id == itemId);
                      ItemModel item =
                          restaurantData.menu[categoryIndex].items[itemIndex];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                                child: Text(
                              '${price}EGP',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontSize: 36.sp),
                            )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 40.sp),
                                  child: Text(
                                    '${category.name} - ${item.name} ($size)',
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
                            )
                          ],
                        ),
                      );
                    })),
                    widget.order.note == ''
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.sp),
                            child: Center(
                              child: Text(
                                ' ملحوظة: ${widget.order.note}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 35.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                    const StyledDivider(
                      thickness: 1,
                      lineStyle: DividerLineStyle.solid,
                    ),
                  ],
                ),
              ),

              widget.order.voucher.name.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Text(
                              '-${widget.order.voucher.discount}%'.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 36.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            'كود خصم ${widget.order.voucher.name}',
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 36.sp,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        '${widget.order.deliveryFee}EGP'.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 36.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'توصيل',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 36.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        widget.order.voucher.name.isNotEmpty
                            ? '${total * (100 - widget.order.voucher.discount) / 100 + widget.order.deliveryFee}EGP'
                            : '${total + widget.order.deliveryFee}EGP',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                fontSize: 48.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      'الإجمالي',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: 48.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const StyledDivider(
                      thickness: 1,
                      lineStyle: DividerLineStyle.solid,
                    ),
                    Text(
                      'الأوردر مع',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: primaryColor, fontSize: 32.sp),
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                    OrderDriver(order: widget.order, radius: 28.r),
                    SizedBox(
                      height: 24.sp,
                    ),
                  ],
                ),
              ),
              // OrderState(
              //   order: widget.order,
              // ),
              widget.order.rate.rate != 0
                  ? Rate(
                      rate: widget.order.rate,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
