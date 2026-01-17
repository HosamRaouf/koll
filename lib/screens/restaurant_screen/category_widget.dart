import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/models/menu_models/item_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/restaurant_screen/restaurant_modal_bottom_sheet.dart';

import '../../components/my_alert_dialog.dart';
import '../../navigation_animations.dart';
import '../../styles.dart';
import 'category_screen/category_screen.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget(
      {super.key,
      required this.category,
      required this.onEditSubmit,
      required this.onDelete});

  CategoryModel category;
  Function() onEditSubmit;
  Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.sp, left: 100.h),
      child: InkWell(
          onTap: () => Navigator.of(context).push(ScaleTransition5(
                CategoryScreen(
                  chosenItem: ItemModel(
                    id: "",
                    name: "",
                    firestoreId: "",
                    image: "",
                    description: "",
                    ordered: 0,
                    images: [],
                    prices: [],
                    time: DateTime.now().toString(),
                  ),
                  category: category,
                ),
              )),
          child: Container(
            width: 950.w,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/icons2.png")),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal,
                    offset: const Offset(-3, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.r),
                    bottomLeft: Radius.circular(36.r)),
                gradient: LinearGradient(
                    colors: [accentColor, primaryColor],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.r),
                      bottomLeft: Radius.circular(36.r)),
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/icons2.png")),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 10,
                            blurStyle: BlurStyle.normal,
                            offset: const Offset(
                                -3, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.r),
                            bottomLeft: Radius.circular(36.r)),
                        gradient: LinearGradient(
                            colors: [accentColor, primaryColor],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft)),
                  )
                      .animate(
                        onComplete: (controller) {
                          controller.loop(reverse: true);
                        },
                        autoPlay: true,
                        delay: const Duration(seconds: 2),
                      )
                      .shimmer(
                          duration: const Duration(milliseconds: 750),
                          delay: const Duration(seconds: 2),
                          curve: Curves.easeInOutCubic,
                          color: warmColor.withOpacity(0.5)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: Offset(-70.h, 0),
                      child: SizedBox(
                        height: 150.h,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(category.image)),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 24.sp, horizontal: 96.sp),
                          child: SizedBox(
                            width: 0.37.sw,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                          color: Colors.white, fontSize: 64.sp),
                                )),
                          ),
                        ),
                        PopupMenuButton<String>(
                          iconSize: 65.sp,
                          color: Colors.white,
                          iconColor: Colors.white,
                          enableFeedback: true,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0.sp))),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              padding: EdgeInsets.symmetric(vertical: 12.sp),
                              value: 'option1',
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  primaryBottomSheet(
                                      context: context,
                                      child: RestaurantModalBottomSheet(
                                        edit: true,
                                        map: restaurantData.menu[restaurantData
                                            .menu
                                            .indexWhere((element) =>
                                                element.id == category.id)],
                                        onAdd: () {
                                          CategoryModel element =
                                              restaurantData.menu[restaurantData
                                                  .menu
                                                  .indexWhere((element) =>
                                                      element.id ==
                                                      category.id)];

                                          if (element.name ==
                                                  RestaurantModalBottomSheet
                                                      .controller1.text &&
                                              element.image ==
                                                  'assets/images/${RestaurantModalBottomSheet.type}/${RestaurantModalBottomSheet.index}.png' &&
                                              element.type ==
                                                  RestaurantModalBottomSheet
                                                      .type) {
                                            print('same');
                                            Navigator.pop(context);
                                          } else {
                                            element.name =
                                                RestaurantModalBottomSheet
                                                    .controller1.text;
                                            element.image =
                                                'assets/images/${RestaurantModalBottomSheet.type}/${RestaurantModalBottomSheet.index++}.png';
                                            element.type =
                                                RestaurantModalBottomSheet.type;
                                            restaurant['menu'][
                                                    restaurant['menu']
                                                        .indexWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                category.id)] =
                                                category.toJson();

                                            onEditSubmit();

                                            RestaurantModalBottomSheet
                                                    .controller1.text.isNotEmpty
                                                ? {
                                                    Navigator.of(context).pop(),
                                                  }
                                                : print('empty');
                                          }
                                        },
                                      ),
                                      enableDrag: true,
                                      isDismissible: true);
                                },
                                leading: Padding(
                                  padding: EdgeInsets.only(left: 24.sp),
                                  child: Icon(
                                    Iconsax.edit,
                                    color: primaryColor,
                                    size: 50.sp,
                                  ),
                                ),
                                title: Padding(
                                  padding: EdgeInsets.only(right: 24.sp),
                                  child: Text(
                                    'تعديل',
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            color: primaryColor,
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              padding: EdgeInsets.symmetric(vertical: 12.sp),
                              value: 'option2',
                              child: ListTile(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await showDialog(
                                      context: context,
                                      builder: (context) => MyAlertDialog(
                                            isFirstButtonRed: true,
                                            onFirstButtonPressed: () {
                                              onDelete();
                                            },
                                            onSecondButtonPressed: () {},
                                            firstButton: 'حذف',
                                            secondButton: 'إلغاء',
                                            body: Container(),
                                            title: 'حذف صنف ${category.name}؟',
                                            description:
                                                'عند التأكيد هيتشال الصنف دا بكل اللي فيه من منتجات',
                                            textfield: false,
                                            controller: TextEditingController(),
                                          ));
                                },
                                leading: Padding(
                                  padding: EdgeInsets.only(left: 24.sp),
                                  child: Icon(
                                    Iconsax.box_remove,
                                    color: Colors.red,
                                    size: 50.sp,
                                  ),
                                ),
                                title: Padding(
                                  padding: EdgeInsets.only(right: 24.sp),
                                  child: Text(
                                    'حذف',
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            color: Colors.red,
                                            fontSize: 40.sp,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 24.sp,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
