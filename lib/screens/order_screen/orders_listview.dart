import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/components/cachedAvatar.dart';

import '../../styles.dart';

class OrdersListView extends StatelessWidget {
  List<List<String>>? orderNames;
  List<String>? imageUrls;

  OrdersListView({Key? key, this.orderNames, this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: List.generate(
            orderNames!.length,
            (index) => Padding(
                  padding: EdgeInsets.only(bottom: 20.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        )
                      ],
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 75.h,
                          height: 75.h,
                          child: CachedAvatar(imageUrl: imageUrls![index]),
                        ),
                        Text(
                          '${orderNames![index][1]}EGP',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: primaryColor, fontSize: 30.sp),
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  orderNames![index][0],
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 30.sp,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 50.sp,
                                ),
                                Icon(
                                  FontAwesomeIcons.cutlery,
                                  size: 40.sp,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
