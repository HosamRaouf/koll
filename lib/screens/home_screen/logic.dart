import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kol/core/firebase_messaging/sendNotification.dart';
import 'package:kol/core/models/driver_model.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/map.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/show_snack_bar.dart';
import '../../core/models/menu_models/item_model.dart';
import '../../core/models/user_models/user_model.dart';
import '../../core/models/voucher_model.dart';

AudioPlayer audioPlayer = AudioPlayer();

List<Widget> orders = [];

declineOrder(OrderModel order, String body) async {
  String orderNumber = order.id.hashCode.toString().substring(0, 3);
  print(
      "================================================ 🛰️ Declining Order $orderNumber 🛰️ ==========================================");
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .delete();
    await restaurants
        .doc(order.restaurantId)
        .collection("orders")
        .doc(order.id)
        .delete();
    sendNotification(order.userFCMToken, "أوردر رقم $orderNumber اترفض☹️", body,
        data: "order");
    print(
        "================================================ ✅ Order $orderNumber declined ✅ ==========================================");
  } catch (e) {
    print(
        "================================================ ❌ Error Declining $orderNumber ❌ ==========================================");
    print(e);
  }
}

acceptOrder(OrderModel order, BuildContext context,
    ValueNotifier<bool> isLoading) async {
  String orderNumber = order.id.hashCode.toString().substring(0, 3);
  print(
      "================================================ 🛰️ Accepting Order $orderNumber 🛰️ ==========================================");
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .update({
      "state": "عالنار",
      "acceptedTime": DateFormat('EEE, MMM d, yyyy – h:mm aaa')
          .format(DateTime.now())
          .toString()
    });
    await restaurantDocument.collection("orders").doc(order.id).update({
      "state": "عالنار",
      "acceptedTime": DateFormat('EEE, MMM d, yyyy – h:mm aaa')
          .format(DateTime.now())
          .toString()
    });
    print(
        "================================================ ✅ Order $orderNumber Accepted ✅ ==========================================");
    isLoading.value = false;
    sendNotification(order.userFCMToken, "أوردرك عالنار!🔥",
        "أوردر رقم ${orderNumber} دلوقتي بيتسوّى على نار هادية عشان يطلع طعمه حلو",
        data: "order");

    order.acceptedTime = DateFormat('EEE, MMM d, yyyy – h:mm aaa')
        .format(DateTime.now())
        .toString();
    order.state = 'عالنار';
  } catch (e) {
    print(
        "================================================ ❌ Error accepting $orderNumber ❌ ==========================================");
    print(e);
  }
}

readyOrder(OrderModel order, ValueNotifier<bool> isLoading) async {
  String orderNumber = order.id.hashCode.toString().substring(0, 3);
  print(
      "================================================ 🛰️ Making Order $orderNumber Ready 🛰️ ==========================================");
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .update({
      "state": "جاهز",
    });
    await restaurantDocument.collection("orders").doc(order.id).update({
      "state": "جاهز",
    });
    print(
        "================================================ ✅ Order $orderNumber Ready ✅ ==========================================");
    isLoading.value = false;
    order.state = 'جاهز';
  } catch (e) {
    print(
        "================================================ ❌ Error making $orderNumber ready ❌ ==========================================");
    print(e);
  }
}

assignDriver(
  OrderModel order,
  DriverModel driver,
  ValueNotifier<bool> isLoading,
) async {
  String orderNumber = order.id.hashCode.toString().substring(0, 3);
  print(
      "================================================ 🛰️ Assigning ${driver.name} to Order $orderNumber 🛰️ ==========================================");
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .update({
      "state": "في الطريق",
      "pickedUpTime": DateFormat('EEE, MMM d, yyyy – h:mm aaa')
          .format(DateTime.now())
          .toString(),
      "driverId": driver.firestoreId,
      "driverName": driver.name,
      "driverImage": driver.image,
      "driverPhoneNumber": driver.phoneNumber,
    });
    await restaurantDocument.collection("orders").doc(order.id).update({
      "state": "في الطريق",
      "pickedUpTime": DateFormat('EEE, MMM d, yyyy – h:mm aaa')
          .format(DateTime.now())
          .toString(),
      "driverId": driver.firestoreId,
      "driverName": driver.name,
      "driverImage": driver.image,
      "driverPhoneNumber": driver.phoneNumber,
    });
    print(
        "================================================ ✅ ${driver.name} assigned to Order $orderNumber ✅ ==========================================");
    isLoading.value = false;
    sendNotification(
        order.userFCMToken,
        "أوردر رقم $orderNumber جايلك في الطريق🛣️",
        "${driver.name} في الطريق ليك، تقدر تتواصل معاه من خلال التطبيق",
        data: "order");
    order.pickedUpTime = DateFormat('EEE, MMM d, yyyy – h:mm aaa')
        .format(DateTime.now())
        .toString();
    order.state = 'في الطريق';
    order.driverId = driver.firestoreId;
    order.driverName = driver.name;
    order.driverImage = driver.image;
    order.driverPhoneNumber = driver.phoneNumber;
  } catch (e) {
    print(
        "================================================ ❌ Error assigning ${driver.name} to Order $orderNumber ❌ ==========================================");
    print(e);
  }
}

orderComplete(OrderModel order, ValueNotifier<bool> isLoading) async {
  String orderNumber = order.id.hashCode.toString().substring(0, 3);
  print(
      "================================================ 🛰️ Completing Order $orderNumber 🛰️ ==========================================");
  try {
    await restaurantDocument.collection("orders").doc(order.id).delete();

    order.state = "خلصان";
    order.deliveredTime = DateFormat('EEE, MMM d, yyyy – h:mm aaa')
        .format(DateTime.now())
        .toString();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .update({
      "state": "خلصان",
      "deliveredTime": DateFormat('EEE, MMM d, yyyy – h:mm aaa')
          .format(DateTime.now())
          .toString()
    });
    isLoading.value = false;
    List finishedOrders = [];

    if (restaurantData.finishedOrders.isNotEmpty) {
      for (var element in restaurantData.finishedOrders) {
        finishedOrders.add(element.toJson());
      }
    }

    finishedOrders.add(order.toJson());

    await restaurantDocument.update({"finishedOrders": finishedOrders});

    restaurantData.finishedOrders.add(order);

    users[users.indexWhere((element) => element.firestoreId == order.userId)]
        .finishedOrders
        .add(order);
    List userFinishedOrders = [];
    users[users.indexWhere((element) => element.firestoreId == order.userId)]
        .finishedOrders
        .forEach((element) {
      userFinishedOrders.add(element.toJson());
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .collection("orders")
        .doc(order.id)
        .delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(order.userId)
        .update({"finishedOrders": userFinishedOrders});

    print(
        "================================================ ✅ Order $orderNumber completed ✅ ==========================================");
    sendNotification(order.userFCMToken, "بالهنا والشفا✅",
        "متنساش تعرّفنا ايه هو تقييمك للأرودر، متحمسين جدًا عشان نعرف رأيك",
        data: "finishedOrder");
  } catch (e) {
    print(
        "================================================ ❌ Error completing Order $orderNumber ❌ ==========================================");
    print(e);
  }
}

copyOrder(OrderModel order, BuildContext context, UserModel user) {
  String name = user.name;
  String address =
      "https://maps.google.com/?q=${order.location.lat},${order.location.long}";
  int phoneNumber = int.parse(order.phoneNumber);
  List<OrderItemModel> items = order.items;
  int deliveryFee = order.deliveryFee.round();

  String orders = '';
  int cost = 0;

  VoucherModel voucher = order.voucher;

  for (var orderItem in items) {
    String id = orderItem.id;
    String categoryId = orderItem.categoryId;
    SizeModel size = orderItem.size;
    int price = size.price.round();

    int categoryIndex =
        restaurantData.menu.indexWhere((element) => element.id == categoryId);

    int itemIndex = restaurantData.menu[categoryIndex].items
        .indexWhere((element) => element.id == id);

    ItemModel item = restaurantData.menu[categoryIndex].items[itemIndex];

    CategoryModel category = restaurantData.menu[categoryIndex];

    String order =
        '- ${orderItem.quantity}× ${category.name} ${item.name}  ${item.prices.length == 1 ? "" : "(${size.name})"}  \n ${(orderItem.quantity * price).toStringAsFixed(2)}EGP\n';
    orders = '$orders\n$order';
    cost = cost + (orderItem.quantity * price).round();
  }

  for (var element in order.offers) {
    String order =
        '- ${element.title}\n ${element.price.toStringAsFixed(2)}EGP\n';
    orders = '$orders\n$order';
    cost = cost + element.price;
  }

  double cartItemsTotal = 0;
  for (var element in order.items) {
    cartItemsTotal = (cartItemsTotal + (element.size.price * element.quantity));
  }

  for (var element in order.offers) {
    cartItemsTotal = cartItemsTotal + element.price;
  }

  double cartOrderDeliveryFee = 0;
  cartOrderDeliveryFee = order.deliveryFee.toDouble();

  double total = cartItemsTotal -
      ((order.voucher.discount / 100) * cartItemsTotal) +
      cartOrderDeliveryFee;

  String orderNumber = order.id.hashCode.toString().substring(0, 3);

  String voucherCode = voucher.name.isNotEmpty
      ? '-كود خصم ${((voucher.discount / 100) * cartItemsTotal).toStringAsFixed(2)}EGP : ${voucher.name}'
      : '';

  Clipboard.setData(ClipboardData(
          text: "*========  أوردر رقم $orderNumber  ========*\n\n"
              '👤طلب بإسم : $name \n\n'
              '🚩العنوان: ${order.location.address} \n\n'
              '🚩خرائط جوجل : $address \n\n'
              '📞رقم التليفون : 0$phoneNumber \n\n'
              '🍽️ من مطعم : ${restaurantData.name}\n\n'
              '========= 📋 الطلبات 📋 =========\n$orders \n ${order.note.isEmpty ? "" : "ملحوظة: ${order.note}"} \n\n==============================\n\n'
              "إجمالي الطلبات : ${cartItemsTotal.toStringAsFixed(2)} EGP\n"
              '$voucherCode\n'
              'توصيل : ${deliveryFee.toStringAsFixed(2)} EGP\n\n'
              '💰الإجمالي💰 : ${total.toStringAsFixed(2)} EGP\n\n'
              '${order.time}'))
      .then((value) {
    showSnackBar(
      context: context,
      message: 'تم نسخ معلومات الطلب بنجاح',
    );
  });
}

shareOrder(OrderModel order, UserModel user) async {
  String name = user.name;
  String address =
      "https://maps.google.com/?q=${order.location.lat},${order.location.long}";
  String phoneNumber = order.phoneNumber;
  List<OrderItemModel> items = order.items;
  int deliveryFee = order.deliveryFee;
  String orders = '';
  int cost = deliveryFee;
  VoucherModel voucher = order.voucher;

  for (var element in items) {
    String id = element.id;
    String categoryId = element.categoryId;
    SizeModel size = element.size;
    double price = size.price;

    int categoryIndex =
        restaurantData.menu.indexWhere((element) => element.id == categoryId);

    int itemIndex = restaurantData.menu[categoryIndex].items
        .indexWhere((element) => element.id == id);

    ItemModel item = restaurantData.menu[categoryIndex].items[itemIndex];

    CategoryModel category = restaurantData.menu[categoryIndex];

    String order =
        '- ${element.quantity}× ${category.name} ${item.name} ${item.prices.length == 1 ? "" : "(${size.name})"} \n ${(element.quantity * price).toStringAsFixed(2)}EGP\n';
    orders = '$orders\n$order';
    cost = cost + (element.quantity * price).round();
  }

  for (var element in order.offers) {
    String order =
        '- عرض ${element.title}\n ${element.price.toStringAsFixed(2)}EGP\n';
    orders = '$orders\n$order';
    cost = cost + element.price;
  }

  double cartItemsTotal = 0;
  for (var element in order.items) {
    cartItemsTotal = (cartItemsTotal + (element.size.price * element.quantity));
  }

  for (var element in order.offers) {
    cartItemsTotal = cartItemsTotal + element.price;
  }

  double cartOrderDeliveryFee = 0;
  cartOrderDeliveryFee = order.deliveryFee.toDouble();

  double total = cartItemsTotal -
      ((order.voucher.discount / 100) * cartItemsTotal) +
      cartOrderDeliveryFee;

  String orderNumber = order.id.hashCode.toString().substring(0, 3);

  String voucherCode = voucher.name.isNotEmpty
      ? '-كود خصم ${((voucher.discount / 100) * cartItemsTotal).toStringAsFixed(2)}EGP : ${voucher.name}'
      : '';

  int discount = voucher.name.isNotEmpty ? voucher.discount : 0;

  Share.share(
      subject: "=========== أوردر رقم $orderNumber ===========",
      "*========  أوردر رقم $orderNumber  ========*\n\n"
      '👤 بإسم : $name \n\n'
      '🚩 العنوان: ${order.location.address} \n\n'
      '🚩 خرائط جوجل : $address \n\n'
      '📞 رقم التليفون : $phoneNumber \n\n'
      '🍽️ من مطعم : ${restaurantData.name}\n\n'
      '========= 📋 الطلبات 📋 =========\n$orders \n ${order.note.isEmpty ? "" : "ملحوظة: ${order.note}"} \n\n==============================\n\n'
      "إجمالي الطلبات : ${cartItemsTotal.toStringAsFixed(2)} EGP\n"
      '$voucherCode\n'
      'توصيل : ${deliveryFee.toStringAsFixed(2)} EGP\n\n'
      '💰الإجمالي💰 : ${total.toStringAsFixed(2)} EGP\n\n'
      '${order.time}');
}
