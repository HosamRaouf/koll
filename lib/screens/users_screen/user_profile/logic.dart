import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/firebase_messaging/sendNotification.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/screens/users_screen/user_profile/user_order.dart';

import '../../../core/models/user_models/user_model.dart';
import '../../../core/models/user_models/user_order_data.dart';
import '../../../core/models/voucher_model.dart';
import '../../../map.dart';

List<Widget> userOrders = [];

buildOrders(UserModel user) {
  userOrders.clear();
  List<UserOrderDataModel> orderData = user.orders;
  int orderIndex;
  OrderModel order;
  for (var data in orderData) {
    data.restaurantId == restaurantData.id
        ? {
            orderIndex = restaurantData.finishedOrders
                .indexWhere((element) => element.id == data.orderId),
            order = restaurantData.finishedOrders[orderIndex],
            orderIndex >= 0
                ? userOrders.add(Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.sp, vertical: 0.sp),
                    child: UserOrder(order: order),
                  ))
                : false
          }
        : false;
  }
}

sendVoucher(String token, VoucherModel voucher) {
  sendNotification(token, "مطعم ${restaurantData.name} بيمسّي عليك😉",
      "استخدم دلوقتي كود خصم ${voucher.name} واحصل على خصم ${voucher.discount}%",
      data: "voucher");
}
