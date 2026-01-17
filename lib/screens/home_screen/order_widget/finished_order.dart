import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/core/models/menu_models/item_model.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/core/models/user_models/user_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/order_widget/order_driver.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../styles.dart';
import 'rate.dart';

class FinishedOrder extends StatefulWidget {
  OrderModel order;
  FinishedOrder({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<FinishedOrder> createState() => _FinishedOrderState();
}

class _FinishedOrderState extends State<FinishedOrder> {
  @override
  Widget build(BuildContext context) {
    int total = 0;
    int userIndex =
        users.indexWhere((element) => element.id == widget.order.userId);
    UserModel user = users[userIndex];

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
              Padding(
                padding: EdgeInsets.all(12.0.sp),
                child: MyInkWell(
                  onTap: () {},
                  radius: 28.r,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.sp, left: 20.sp, right: 20.sp, bottom: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 0.05.sw,
                              child: Text(
                                'طلب بإسم',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 30.sp,
                                        color: smallFontColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 0.08.sw,
                              child: Text(
                                user.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: 48.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 35.sp,
                        ),
                        SizedBox(
                            width: 0.06.sh,
                            height: 0.06.sh,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.sp),
                                child: user.imageUrl == 'assets/images/user.png'
                                    ? Image.asset(user.imageUrl,
                                        fit: BoxFit.cover)
                                    : CachedAvatar(
                                        imageUrl: user.imageUrl,
                                      )))
                      ],
                    ),
                  ),
                ),
              ),
              const StyledDivider(
                thickness: 1,
                lineStyle: DividerLineStyle.solid,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              MyInkWell(
                                onTap: () {
                                  launchUrlString(
                                      "https://maps.google.com/?q=${widget.order.location.long},${widget.order.location.lat}");
                                },
                                radius: 10.r,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Text(
                                    "عرض العنوان",
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 36.sp,
                                            color: Colors.blue,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24.sp,
                              ),
                              Text(
                                widget.order.location.name,
                                textAlign: TextAlign.end,
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
                        SizedBox(
                          width: 60.sp,
                        ),
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 40.sp,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 60.sp),
                          child: MyInkWell(
                            onTap: () {
                              launchUrlString(
                                  "tel://${widget.order.phoneNumber}");
                            },
                            radius: 10.sp,
                            child: Text(
                              textAlign: TextAlign.end,
                              widget.order.phoneNumber.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 40.sp,
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 40.sp,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const StyledDivider(
                      thickness: 1,
                      lineStyle: DividerLineStyle.solid,
                    ),
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
                      String itemCategory =
                          widget.order.items[index].categoryId;
                      SizeModel itemSize = widget.order.items[index].size;
                      String size = itemSize.name;
                      int price = itemSize.price.round();
                      total = total + price;
                      int categoryIndex = restaurantData.menu.indexWhere(
                          (element) => element.name == itemCategory);
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
                                    '$itemCategory - ${item.name} ($size)',
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
                    const StyledDivider(
                      thickness: 1,
                      lineStyle: DividerLineStyle.solid,
                    ),
                  ],
                ),
              ),

              widget.order.note == ''
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 70.sp),
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
              widget.order.rate.toJson().isNotEmpty
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
