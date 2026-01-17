import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/components/show_snack_bar.dart';

import '../../../components/myTextField.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../styles.dart';

class ItemData extends StatefulWidget {
  String name;
  String description;
  ItemModel element;
  String category;
  Function() onPressed;
  TextEditingController nameController;
  TextEditingController descriptionController;
  Function() onItemDelete;

  ItemData(
      {super.key,
      required this.name,
      required this.description,
      required this.element,
      required this.category,
      required this.onPressed,
      required this.nameController,
      required this.descriptionController,
      required this.onItemDelete});

  @override
  State<ItemData> createState() => _ItemDataState();
}

class _ItemDataState extends State<ItemData> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.name,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 75.h,
                color: primaryColor),
          ),
          SizedBox(
            height: 24.sp,
          ),
          Text(
            widget.description,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: smallFontColor,
                fontWeight: FontWeight.w500,
                fontSize: 32.h),
          ),
          SizedBox(
            height: 72.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.element.ordered} مرات',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 32.h),
              ),
              Text(
                'تم الطلب',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: smallFontColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 32.h),
              ),
            ],
          ),
          SizedBox(
            height: 36.sp,
          ),
          MyElevatedButton(
            onPressed: () {
              setState(() {
                widget.descriptionController.text = widget.description;
                widget.nameController.text = widget.name;
              });
              primaryBottomSheet(
                  child: Padding(
                    padding: EdgeInsets.all(48.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تعديل الاسم والوصف',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 64.sp),
                        ),
                        SizedBox(
                          height: 24.sp,
                        ),
                        MyTextField(
                            descriptionTextField: false,
                            error: "",
                            title: "الإسم",
                            maxLength: 25,
                            isValidatable: true,
                            controller: widget.nameController,
                            type: 'normal',
                            hintText: 'مثال: مارجريتا',
                            isExpanding: false),
                        MyTextField(
                            error: "",
                            descriptionTextField: false,
                            title: "الوصف",
                            maxLength: 100,
                            isValidatable: true,
                            controller: widget.descriptionController,
                            type: 'normal',
                            hintText:
                                'مثال: العجينة الشهية مع الخضراوات والجبن اللذيذ',
                            isExpanding: true),
                        SizedBox(
                          height: 24.sp,
                        ),
                        MyElevatedButton(
                          fontSize: 40.h,
                          onPressed: () async {
                            widget.nameController.text.isEmpty ||
                                    widget.descriptionController.text.isEmpty
                                ? false
                                : Navigator.of(context).pop();
                            await widget.onPressed();
                            showSnackBar(
                                context: context, message: 'تم التعديل');
                          },
                          text: 'تعديل',
                          width: double.infinity,
                          enabled: true,
                          color: Colors.transparent,
                          textColor: Colors.white,
                          gradient: true,
                        ),
                      ],
                    ),
                  ),
                  context: context);
            },
            text: 'تعديل',
            width: double.infinity,
            enabled: true,
            fontSize: 42.sp,
            color: Colors.transparent,
            gradient: true,
            textColor: Colors.white,
          ),
          SizedBox(
            height: 24.sp,
          ),
          MyElevatedButton(
            onPressed: () {
              widget.onItemDelete();
            },
            text: 'حذف',
            width: double.infinity,
            enabled: true,
            fontSize: 42.sp,
            color: paleRed,
            gradient: false,
            textColor: Colors.red,
          )
        ],
      ),
    );
  }
}
