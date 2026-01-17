import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/map.dart';

import '../../../components/my_alert_dialog.dart';
import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../styles.dart';

class OfferItem extends StatefulWidget {
  final String categoryId;
  final String id;
  final SizeModel size;
  final Function() onDelete;

  const OfferItem(
      {super.key,
      required this.categoryId,
      required this.id,
      required this.size,
      required this.onDelete});

  @override
  State<OfferItem> createState() => _OfferItemState();
}

class _OfferItemState extends State<OfferItem> {
  @override
  Widget build(BuildContext context) {
    int categoryIndex = restaurantData.menu
        .indexWhere((element) => element.id == widget.categoryId);
    CategoryModel category = restaurantData.menu[categoryIndex];
    int itemIndex =
        category.items.indexWhere((element) => element.id == widget.id);
    ItemModel item = category.items[itemIndex];

    return Padding(
      padding: EdgeInsets.only(bottom: 24.sp),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(36.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.r),
          child: Padding(
            padding: EdgeInsets.all(24.sp),
            child: SizedBox(
              width: double.infinity,
              height: 0.1.sh,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 175.sp),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 0.6.sw,
                            child: Text(
                              '${category.name} ${item.name} - ${widget.size.name}',
                              textDirection: TextDirection.rtl,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontSize: 52.sp, color: primaryColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.sp),
                            child: SizedBox(
                              width: 0.45.sw,
                              child: Text(
                                item.description,
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 32.sp,
                                        color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: Offset(100.sp, 25.sp),
                        child: SizedBox(
                            width: 0.3.sw, child: Image.asset(category.image)),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 120.h,
                      width: 120.h,
                      child: ClipOval(
                        child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                                padding: EdgeInsets.all(0.sp),
                                color: Colors.red,
                                splashColor: Colors.red.withOpacity(0.5),
                                highlightColor: Colors.red.withOpacity(0.2),
                                onPressed: () {
                                  TextEditingController controller =
                                      TextEditingController();

                                  showDialog(
                                      context: context,
                                      builder: (context) => MyAlertDialog(
                                          controller: controller,
                                          description:
                                              "سيتم حذف x1 ${category.name} ${item.name} (${widget.size.name}) - ${widget.size.price.toStringAsFixed(2).toString()}EGP",
                                          textfield: false,
                                          title: "حذف ${item.name} ؟",
                                          body: Container(),
                                          firstButton: "حذف",
                                          secondButton: "إلغاء",
                                          onFirstButtonPressed: () {
                                            widget.onDelete();
                                          },
                                          onSecondButtonPressed: () {},
                                          isFirstButtonRed: true));
                                },
                                icon: Icon(
                                  Iconsax.trash,
                                  color: Colors.red,
                                  size: 52.sp,
                                ))),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "EGP ${widget.size.price.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w900, fontSize: 40.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
