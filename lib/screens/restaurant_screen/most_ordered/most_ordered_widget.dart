

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/screens/restaurant_screen/category_screen/category_screen.dart';

import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../navigation_animations.dart';
import '../../../styles.dart';


class MostOrderedWidget extends StatefulWidget {

CategoryModel category;
  ItemModel item;

  MostOrderedWidget({super.key, required this.category, required this.item});

  @override
  State<MostOrderedWidget> createState() => _MostOrderedWidgetState();
}

class _MostOrderedWidgetState extends State<MostOrderedWidget> {
  @override
  Widget build(BuildContext context) {
    return               Padding(
      padding: EdgeInsets.only(
          right: 40.sp, bottom: 24.sp),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
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
            ],
            color: warmColor,
            borderRadius:
            BorderRadius.circular(25.r)),
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(25.r),
          child: Material(
            child: InkWell(
              onTap: (){
                setState(() {
                  CategoryScreen.thisItem = widget.item;
                });
                Navigator.of(context).push(ScaleTransition5(
                  CategoryScreen(
                    chosenItem: widget.item,
category: widget.category ,                  ),
                ));
print(widget.item.toJson());
                },
              child: Padding(
                padding:
                EdgeInsets.all(24.sp),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .start,
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: Offset(
                              -100.h, 0),
                          child: SizedBox(
                              width: 0.2.sw,
                              child: Image.asset(
                                  widget.category.image)),
                        ),
                        Transform.translate(
                          offset: Offset(
                              -40.h, 0),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Text(
                                'تم الطلب',
                                style: Theme.of(
                                    context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                    color:
                                    smallFontColor,
                                    fontSize:
                                    24.sp),
                              ),
                              Text(
                                widget.item.ordered.toString(),
                                style: Theme.of(
                                    context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                    color:
                                    primaryColor,
                                    fontSize:
                                    32.sp),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .end,
                      children: [
                        SizedBox(
                          width: 0.35.sw,
                          child: Text(
                            '${widget.category.name} - ${widget.item.name}',
                            textDirection:
                            TextDirection
                                .rtl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                                context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontSize:
                                48.sp,
                                color:
                                primaryColor),
                          ),
                        ),
                        SizedBox(
                          width: 0.45.sw,
                          height: 150.h,
                          child: Text(
                            widget.item.description,
                            textDirection:
                            TextDirection
                                .rtl,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(
                                context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                fontSize:
                                32.sp,
                                color:
                                smallFontColor),
                          ),
                        )
                      ],
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



