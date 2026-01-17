import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/add_offer_screen.dart';

import '../../../components/my_alert_dialog.dart';
import '../../../components/my_inkwell.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../core/models/offer_model.dart';
import '../../../styles.dart';

class OfferWidget extends StatelessWidget {
  Function() onDelete;

  OfferWidget({super.key, required this.offer, required this.onDelete});

  OfferModel offer;
  List<ItemModel> items = [];

  @override
  Widget build(BuildContext context) {
    String description = '';

    for (var meal in offer.meals) {
      int categoryIndex = restaurantData.menu
          .indexWhere((element) => element.id == meal.categoryId);
      CategoryModel category = restaurantData.menu[categoryIndex];
      int itemIndex =
          category.items.indexWhere((element) => element.id == meal.id);
      items.add(category.items[itemIndex]);
      ItemModel item = category.items[itemIndex];
      description = description == ''
          ? '${category.name} ${item.name}'
          : '$description + ${category.name} ${item.name}';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(38.r),
      child: SizedBox(
          height: 0.15.sh,
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                  height: 0.15.sh,
                  width: double.infinity,
                  child: CachedAvatar(
                    imageUrl: offer.image,
                    fit: BoxFit.cover,
                    borderRadius: 38.r,
                  )),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                )),
              ),
              Padding(
                padding: EdgeInsets.all(18.sp),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${offer.price.toString()}EGP',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 0.5.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                offer.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 60.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 0.8.sw,
                                child: Text(
                                  description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: smallFontColor,
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              offer.deliveryFee
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FittedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      '!التوصيل مجانًا',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            color: primaryColor,
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 8.sp,
                                    ),
                                    Icon(
                                      Icons.delivery_dining,
                                      size: 40.sp,
                                      color: primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              MyInkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        ScaleTransition5(AddOfferScreen(
                            offer: offer,
                            addOffer: (newOffer) {
                              offer = newOffer;
                              restaurantData.offers[restaurantData.offers
                                  .indexWhere((element) =>
                                      element.id == offer.id)] = newOffer;
                              restaurant['offers'][restaurant['offers']
                                      .indexWhere((element) =>
                                          element['id'] == offer.id)] =
                                  newOffer.toJson();
                              Navigator.pop(context);
                            })));
                  },
                  radius: 38.r,
                  child: Container()),
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipOval(
                    child: Container(
                      color: warmColor.withOpacity(0.5),
                      padding: EdgeInsets.zero,
                      height: 100.h,
                      width: 100.h,
                      child: IconButton(
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          iconSize: 40.h,
                          splashColor: Colors.red.withOpacity(0.5),
                          highlightColor: Colors.red.withOpacity(0.2),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return MyAlertDialog(
                                      controller: TextEditingController(),
                                      description: '',
                                      textfield: false,
                                      title: "حذف العرض؟",
                                      body: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            offer.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 60.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 0.8.sw,
                                            child: Text(
                                              description,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      color: smallFontColor,
                                                      fontSize: 36.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24.sp,
                                          ),
                                          const Divider(
                                              color: fontColor, indent: 0.5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'المجموع',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: fontColor
                                                            .withOpacity(0.5),
                                                        fontSize: 36.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                              Text(
                                                '${offer.price.toString()} EGP',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: primaryColor,
                                                        fontSize: 42.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ].reversed.toList(),
                                          ),
                                        ],
                                      ),
                                      firstButton: 'حذف',
                                      secondButton: 'إلغاء',
                                      onFirstButtonPressed: () {
                                        onDelete();
                                      },
                                      onSecondButtonPressed: () {},
                                      isFirstButtonRed: true);
                                });
                          },
                          icon: Icon(
                            Iconsax.trash,
                            color: Colors.red,
                            size: 50.h,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
