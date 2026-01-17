import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/my_flat_button.dart';
import 'package:kol/components/showLoading.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/screens/home_screen/order_widget/order.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';

import '../../core/models/order_model.dart';
import '../../map.dart';
import '../../styles.dart';

class FinishedOrdersScreen extends StatefulWidget {
  const FinishedOrdersScreen({super.key});

  @override
  State<FinishedOrdersScreen> createState() => _FinishedOrdersScreenState();
}

class _FinishedOrdersScreenState extends State<FinishedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    List dates = [];

    for (var element in restaurantData.finishedOrders) {
      if (!dates.contains(intl.DateFormat("EEEE - dd,MMMM,yyy")
          .format(myDateTimeFormat.parse(element.deliveredTime)))) {
        dates.add(intl.DateFormat("EEEE - dd,MMMM,yyy")
            .format(myDateTimeFormat.parse(element.deliveredTime)));
      }
    }

    dates.sort((a, b) => intl.DateFormat("EEEE - dd,MMMM,yyy")
        .parse(b)
        .compareTo((intl.DateFormat("EEEE - dd,MMMM,yyy").parse(a))));

    List<Widget> slivers = [];

    for (var date in dates) {
      List<OrderModel> sameDateOrders = [];
      double dayTotal = 0;

      for (var element in restaurantData.finishedOrders) {
        if (intl.DateFormat("EEEE - dd,MMMM,yyy")
                .format(myDateTimeFormat.parse(element.deliveredTime)) ==
            date) {
          if (!sameDateOrders.contains(element)) {
            sameDateOrders.add(element);
          }
        }
      }

      double deliveryFee = 0;

      for (var element in sameDateOrders) {
        double total = 0;
        for (var item in element.items) {
          total = total + (item.quantity * item.size.price);
        }
        for (var offer in element.offers) {
          total = total + offer.price;
        }
        if (element.voucher.name.isNotEmpty) {
          total = total - ((element.voucher.discount / 100) * total);
        }

        dayTotal = dayTotal + total;
        deliveryFee = deliveryFee + element.deliveryFee;
      }

      sameDateOrders.sort((a, b) => myDateTimeFormat
          .parse(a.deliveredTime)
          .compareTo(myDateTimeFormat.parse(b.deliveredTime)));

      slivers.add(AdaptiveHeightSliverPersistentHeader(
          pinned: false,
          child: Container(
            color: warmColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 42.sp, vertical: 42.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyFlatButton(
                      onPressed: () async {
                        showLoading(context);
                        sameDateOrders.forEach((element) {
                          restaurantData.finishedOrders.remove(element);
                        });
                        List finishedOrders = [];
                        restaurantData.finishedOrders.forEach((element) {
                          finishedOrders.add(element.toJson());
                        });
                        await restaurantDocument
                            .update({"finishedOrders": finishedOrders});
                        Navigator.pop(context);
                        showSnackBar(context: context, message: "$date اتصفّر");
                        setState(() {
                          dates.remove(date);
                          sameDateOrders = [];
                        });
                      },
                      hint: "صفّر اليوم",
                      backgroundColor: backGroundColor,
                      fontSize: 36.sp,
                      textColor: primaryColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date.toString(),
                        style: TextStyling.headline.copyWith(fontSize: 42.sp),
                        textAlign: TextAlign.right,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Iconsax.receipt5,
                            color: primaryColor,
                            size: 36.sp,
                          ),
                          SizedBox(
                            width: 42.sp,
                          ),
                          Text(
                            "عدد طلبات اليوم : ${sameDateOrders.length} طلب",
                            style: TextStyling.subtitle
                                .copyWith(fontSize: 36.sp, color: primaryColor),
                            textDirection: TextDirection.rtl,
                          ),
                        ].reversed.toList(),
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.motorcycle,
                            color: primaryColor,
                            size: 36.sp,
                          ),
                          SizedBox(
                            width: 42.sp,
                          ),
                          Text(
                            "إجمالي ضريبة التوصيل : ${deliveryFee.round()} EGP",
                            style: TextStyling.subtitle
                                .copyWith(fontSize: 36.sp, color: primaryColor),
                            textDirection: TextDirection.rtl,
                          ),
                        ].reversed.toList(),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            color: primaryColor,
                            size: 36.sp,
                          ),
                          SizedBox(
                            width: 42.sp,
                          ),
                          Text(
                            "إجمالي اليوم : ${dayTotal.round()} EGP",
                            style: TextStyling.subtitle
                                .copyWith(fontSize: 36.sp, color: primaryColor),
                            textDirection: TextDirection.rtl,
                          ),
                        ].reversed.toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )));

      slivers.add(SliverList.list(
          children: List.generate(
              sameDateOrders.length,
              (index) => Order(
                  order: sameDateOrders[index],
                  onOrderAccepted: () {},
                  onOrderSubmit: (order, driver) {},
                  onOrderCompleted: () {},
                  isDriverOrder: false,
                  user: users[users.indexWhere((element) =>
                      element.firestoreId == sameDateOrders[index].userId)],
                  onDelete: (stng) {}))));
    }

    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: BlankScreen(
                title: 'الأوردرات المنتهية',
                child: Container(
                  color: warmColor,
                  child: CustomScrollView(slivers: slivers),
                )),
          ),
        );
      },
    );
  }
}
