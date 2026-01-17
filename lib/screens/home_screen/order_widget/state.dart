import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kol/components/my_timer.dart';

import '../../../core/models/order_model.dart';
import '../../../styles.dart';

class OrderState extends StatelessWidget {
  OrderModel order;

  OrderState({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.time,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: kIsWeb ? 16.sp : 28.sp, color: smallFontColor),
              ),
              Row(
                children: [
                  order.acceptedTime.isNotEmpty
                      ? Text(
                          myDateTimeFormat.parse(order.acceptedTime).minute -
                                      myDateTimeFormat
                                          .parse(order.time)
                                          .minute !=
                                  0
                              ? '( ${myDateTimeFormat.parse(order.acceptedTime).difference(myDateTimeFormat.parse(order.time)).inMinutes} دقيقة )'
                              : '( ثواني )',
                          textDirection: TextDirection.rtl,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Colors.redAccent,
                                  fontSize: kIsWeb ? 18.sp : 28.sp,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                        )
                      : MyStopWatch(
                          color: Colors.redAccent,
                          initialTime:
                              intl.DateFormat('EEE, MMM d, yyyy – h:mm aaa')
                                  .parse(order.time),
                        ),
                  SizedBox(
                    width: 12.sp,
                  ),
                  Text(
                    'عند الكاشير',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: kIsWeb ? 18.sp : 28.sp,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    width: 24.sp,
                  ),
                  Icon(
                    FontAwesomeIcons.cashRegister,
                    color: Colors.redAccent,
                    size: kIsWeb ? 24.sp : 32.sp,
                  )
                ],
              ),
            ],
          ),
          order.acceptedTime.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.acceptedTime,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: kIsWeb ? 16.sp : 28.sp,
                              color: smallFontColor),
                    ),
                    Row(
                      children: [
                        order.pickedUpTime.isNotEmpty
                            ? Text(
                                myDateTimeFormat
                                                .parse(order.pickedUpTime)
                                                .minute -
                                            myDateTimeFormat
                                                .parse(order.acceptedTime)
                                                .minute !=
                                        0
                                    ? '( ${myDateTimeFormat.parse(order.pickedUpTime).difference(myDateTimeFormat.parse(order.acceptedTime)).inMinutes} دقيقة )'
                                    : '( ثواني )',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color: Colors.orange,
                                        fontSize: kIsWeb ? 18.sp : 28.sp,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic),
                                textDirection: TextDirection.rtl,
                              )
                            : MyStopWatch(
                                color: Colors.orange,
                                initialTime: intl.DateFormat(
                                        'EEE, MMM d, yyyy – h:mm aaa')
                                    .parse(order.acceptedTime),
                              ),
                        SizedBox(
                          width: 12.sp,
                        ),
                        Text(
                          'عالنار',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: kIsWeb ? 18.sp : 28.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          width: 24.sp,
                        ),
                        Icon(
                          FontAwesomeIcons.fireBurner,
                          color: Colors.orange,
                          size: kIsWeb ? 22.sp : 32.sp,
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          order.pickedUpTime.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.pickedUpTime,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: kIsWeb ? 16.sp : 28.sp,
                              color: smallFontColor),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            order.deliveredTime.isNotEmpty
                                ? Text(
                                    myDateTimeFormat
                                                    .parse(order.deliveredTime)
                                                    .minute -
                                                myDateTimeFormat
                                                    .parse(order.pickedUpTime)
                                                    .minute !=
                                            0
                                        ? '( ${myDateTimeFormat.parse(order.deliveredTime).difference(myDateTimeFormat.parse(order.pickedUpTime)).inMinutes} دقيقة )'
                                        : '( ثواني )',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: Colors.blue,
                                            fontSize: kIsWeb ? 22.sp : 28.sp,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic),
                                    textDirection: TextDirection.rtl,
                                  )
                                : MyStopWatch(
                                    color: Colors.blue,
                                    initialTime: intl.DateFormat(
                                            'EEE, MMM d, yyyy – h:mm aaa')
                                        .parse(order.pickedUpTime),
                                  ),
                            SizedBox(
                              width: 12.sp,
                            ),
                            Text(
                              'في الطريق',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: kIsWeb ? 18.sp : 28.sp,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 24.sp,
                        ),
                        Icon(
                          FontAwesomeIcons.motorcycle,
                          color: Colors.blue,
                          size: kIsWeb ? 22.sp : 32.sp,
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
          order.deliveredTime.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.deliveredTime,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: kIsWeb ? 22.sp : 28.sp,
                              color: smallFontColor),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              myDateTimeFormat
                                              .parse(order.deliveredTime)
                                              .minute -
                                          myDateTimeFormat
                                              .parse(order.time)
                                              .minute !=
                                      0
                                  ? '( ${myDateTimeFormat.parse(order.deliveredTime).difference(myDateTimeFormat.parse(order.time)).inMinutes} دقيقة )'
                                  : '( ثواني )',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      color: Colors.green,
                                      fontSize: kIsWeb ? 22.sp : 28.sp,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(
                              width: 12.sp,
                            ),
                            Text(
                              'خلصان',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: kIsWeb ? 22.sp : 28.sp,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 24.sp,
                        ),
                        Icon(
                          FontAwesomeIcons.check,
                          color: Colors.green,
                          size: kIsWeb ? 22.sp : 32.sp,
                        )
                      ],
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
