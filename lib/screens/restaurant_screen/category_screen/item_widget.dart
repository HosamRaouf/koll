import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/menu_models/item_model.dart';
import '../../../styles.dart';

class ItemWidget extends StatefulWidget {
  String name;
  String image;
  Function(String) onPressed;
  ItemModel map;
  bool isSelected;

  ItemWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.map,
      required this.onPressed,
      required this.isSelected});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // bool pressed = false;

  Gradient myGradient = LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft);

  Gradient white = LinearGradient(
      colors: [Colors.white, backGroundColor],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.sp),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: widget.isSelected ? myGradient : white,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 3,
              blurStyle: BlurStyle.normal,
              offset: const Offset(-3, 3), // changes position of shadow
            ),
          ],
          image: const DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/icons.png")),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onPressed(widget.name);
                Feedback.forTap(context);
              },
              child: Padding(
                padding: EdgeInsets.all(12.0.sp),
                child: Column(
                  children: [
                    SizedBox(
                      height: 24.sp,
                    ),
                    SizedBox(
                        width: 100.h,
                        height: 100.h,
                        child: Image.asset(widget.image)),
                    SizedBox(
                      height: 8.sp,
                    ),
                    SizedBox(
                      width: 170.h,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        style: ArabicTextStyle(
                            arabicFont: ArabicFont.avenirArabic,
                            fontWeight: FontWeight.w500,
                            color: widget.isSelected == true
                                ? Colors.white
                                : primaryColor,
                            fontSize: 32.h),
                      ),
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
