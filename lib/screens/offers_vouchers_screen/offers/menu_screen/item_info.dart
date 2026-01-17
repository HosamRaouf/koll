import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/my_icon_button.dart';
import '../../../../components/my_scroll_configurations.dart';
import '../../../../core/models/menu_models/category_model.dart';
import '../../../../core/models/menu_models/item_model.dart';
import '../../../../styles.dart';
import '../../../restaurant_screen/category_screen/item_widget.dart';
import 'choose_size.dart';
import 'logic.dart';

class ItemInfo extends StatefulWidget {
  CategoryModel category;
  ItemModel thisItem;
  Function() addMeal;

  ItemInfo(
      {super.key,
      required this.thisItem,
      required this.category,
      required this.addMeal});

  @override
  State<ItemInfo> createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.sp, horizontal: 24.sp),
      child: widget.thisItem.id == ''
          ? Center(
              child: Text(
              'لا يوجد أصناف في قسم ${widget.category.name}',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 40.sp, color: primaryColor),
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 0.7.sw,
                        height: 0.7.sh,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        MyIconButton(
                                            icon: Iconsax.minus,
                                            onTap: () {
                                              setState(() {
                                                quantity == 1
                                                    ? false
                                                    : quantity--;
                                                print(firstCategory.name);
                                              });
                                            },
                                            size: 20.sp),
                                        SizedBox(
                                          width: 24.sp,
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  fontSize: 40.sp),
                                        ),
                                        SizedBox(
                                          width: 24.sp,
                                        ),
                                        MyIconButton(
                                            icon: Iconsax.add,
                                            onTap: () {
                                              setState(() {
                                                quantity == 10
                                                    ? false
                                                    : quantity++;
                                              });
                                            },
                                            size: 20.sp),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 0.45.sw,
                                      child: Text(
                                        itemInfo.name,
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                fontWeight:
                                                    FontWeight.w800,
                                                fontSize: 75.h,
                                                color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  itemInfo.description,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          color: smallFontColor,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 32.h),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 72.sp,
                            ),
                            widget.thisItem.images.isNotEmpty
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(36.sp),
                                    child: ImageSlideshow(
                                      isLoop: true,
                                      indicatorColor: primaryColor,
                                      indicatorBackgroundColor:
                                          backGroundColor,
                                      // initialPage: itemInfo.images.length - 1,
                                      height: 350.h,
                                      children: List.generate(
                                          itemInfo.images.length,
                                          (index) => SizedBox(
                                              height: 0.1.sh,
                                              child: CachedAvatar(
                                                imageUrl: itemInfo
                                                    .images[index],
                                                fit: BoxFit.cover,
                                              ))).reversed.toList(),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 72.sp,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "اختر حجم",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                      color: smallFontColor,
                                      fontSize: 28.sp),
                                ),
                                SizedBox(
                                  height: 12.sp,
                                ),
                                SizedBox(
                                  height: 0.3.sh,
                                  child: MyScrollConfigurations(
                                    horizontal: false,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                            itemInfo.prices.length,
                                            (index) {
                                          SizeModel thisSize =
                                              itemInfo.prices[index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 24.sp),
                                            child: ChooseSize(
                                                onChanged: (size) {
                                                  setState(() {
                                                    choosenSize = size;
                                                  });
                                                },
                                                size: thisSize,
                                                checkBox: thisSize ==
                                                    choosenSize),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 0.1.sh,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            choosenSize.name != ''? Text(
                                    "(${choosenSize.name}) ${firstCategory.name} ${itemInfo.name}  x$quantity ",
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                    color: smallFontColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 32.h),
                              ) : Container(),
                                MyElevatedButton(
                                    onPressed: () {
                                      choosenSize.name != ''
                                          ? {
                                        for (int i = 0; i < quantity; i++)
                                          {widget.addMeal()},
                                        Navigator.pop(context)
                                      }
                                          : {};
                                    },
                                    text: "أضف إلى العرض",
                                    width: 0.7.sw,
                                    enabled: choosenSize.name != '',
                                    fontSize: 40.sp,
                                    color: Colors.transparent,
                                    gradient: true,
                                    textColor: Colors.white),],
                            ),
                            choosenSize.name != ''
                                ?  Text(
                              "EGP${(quantity * choosenSize.price).toStringAsFixed(2)} :الإجمالي",
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                  color: smallFontColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 32.h),
                            ): Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 24.sp,
                ),
                SizedBox(
                  height: double.infinity,
                  child: MyScrollConfigurations(
                    horizontal: false,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(firstCategory.items.length,
                            (itemIndex) {
                          ItemModel item = firstCategory.items[itemIndex];
                          return ItemWidget(
                              name: item.name,
                              image: widget.category.image,
                              map: item,
                              onPressed: (string) {
                                setState(() {
                                  widget.thisItem = firstCategory.items[itemIndex];
                                  itemInfo = widget.thisItem;
                                  thisItem = widget.thisItem;
                                  choosenSize = SizeModel(id: '', name: '', price: 0);
                                  quantity = 1;
                                });
                              },
                              isSelected: thisItem.name == item.name);
                        }),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
