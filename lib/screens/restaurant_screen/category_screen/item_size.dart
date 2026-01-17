import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/models/menu_models/item_model.dart';
import '../../../styles.dart';
import '../../../components/my_alert_dialog.dart';
import 'category_screen.dart';

class ItemSize extends StatefulWidget {
  ItemSize(
      {super.key,
      required this.size,
      required this.price,
      required this.index,
      required this.items,
      required this.element,
      required this.onDelete,
      required this.onSizeEdited});

  String size;
  int price;
  int index;
  SizeModel element;
  List items;
  var onDelete;
  var onSizeEdited;

  @override
  State<ItemSize> createState() => _ItemSizeState();
}

class _ItemSizeState extends State<ItemSize> {
  TextEditingController size = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  void initState() {
    size.text = widget.size;
    price.text = widget.price.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deleteItem() {
      showDialog(
          context: context,
          builder: (context) => MyAlertDialog(
            isFirstButtonRed: true,
                onFirstButtonPressed: () {
                    widget.onDelete();
                },
                onSecondButtonPressed: () {},
                firstButton:
                    CategoryScreen.itemSizes.length == 1 ? 'حذف المنتج' : 'حذف',
                secondButton: 'إلغاء',
                body: CategoryScreen.itemSizes.length == 1
                    ? Text(
                        'لا يمكن حذف جميع الأسعار، يمكنك حذف المنتج بالكامل',
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: accentColor, fontSize: 32.h),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.element.price.toString()}EGP',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    color: primaryColor,
                                    fontSize: 40.h,
                                    fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget.element.name,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(fontSize: 32.h),
                          ),
                        ],
                      ),
                title: CategoryScreen.itemSizes.length == 1
                    ? 'تحذير'
                    : 'حذف الحجم؟',
                description: '',
                textfield: false,
                controller: TextEditingController(),
              ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 8.sp),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            image: const DecorationImage(fit: BoxFit.cover,image: AssetImage("assets/images/icons.png")),
            gradient:  LinearGradient(colors: [primaryColor, accentColor]),
            borderRadius: BorderRadius.circular(24.sp)),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 100.sp,
                        height: 100.sp,
                        child: Material(
                          color: warmColor.withOpacity(0.5),
                          child: IconButton(
                              splashRadius: 40.sp,
                              splashColor: Colors.red.withOpacity(0.5),
                              icon: Icon(
                                Iconsax.trash,
                                color: Colors.red,
                                size: 48.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  deleteItem();
                                });
                              }),
                        ),
                      ),
                    ),
                    SizedBox(width: 24.sp,),
                    ClipOval(
                      child: SizedBox(
                        width: 100.sp,
                        height: 100.sp,
                        child: Material(
                          color: warmColor.withOpacity(0.5),
                          child: IconButton(
                              splashRadius: 40.sp,
                              icon: Icon(
                                Iconsax.edit4,
                                color: Colors.white,
                                size: 48.sp,
                              ),
                              onPressed: () {
               widget.onSizeEdited();
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${widget.price.toString()}EGP',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 40.h,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  widget.size,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 32.h, color: warmColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


