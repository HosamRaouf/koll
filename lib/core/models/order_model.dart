// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:kol/core/models/voucher_model.dart';

import 'menu_models/item_model.dart';
import 'offer_model.dart';
import 'rating_models/order_rate_model.dart';
import 'user_models/location_model.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String id;
  String orderNumber;
  String userId;
  String restaurantId;
  LocationModel location;
  String phoneNumber;
  String userFCMToken;
  List<OrderItemModel> items;
  List<OfferModel> offers;
  String note;
  String time;
  String acceptedTime;
  String pickedUpTime;
  String deliveredTime;
  String driverId;
  String driverName;
  String driverPhoneNumber;
  String driverImage;
  int deliveryFee;
  VoucherModel voucher;
  String state;
  OrderRateModel rate;

  OrderModel(
      {required this.id,
      required this.userId,
      required this.restaurantId,
      required this.orderNumber,
      required this.location,
      required this.phoneNumber,
      required this.userFCMToken,
      required this.items,
      required this.offers,
      required this.note,
      required this.time,
      required this.acceptedTime,
      required this.pickedUpTime,
      required this.deliveredTime,
      required this.driverId,
      required this.driverName,
      required this.driverImage,
      required this.driverPhoneNumber,
      required this.deliveryFee,
      required this.voucher,
      required this.state,
      required this.rate});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
      id: json["id"],
      userId: json["userId"],
      orderNumber: json["orderNumber"] ?? "000",
      restaurantId: json["restaurantId"],
      location: LocationModel.fromJson(
        json["location"],
      ),
      phoneNumber: json["phoneNumber"],
      userFCMToken: json["userFCMToken"],
      items: List<OrderItemModel>.from(
          json["items"].map((x) => OrderItemModel.fromJson(x))),
      offers: List<OfferModel>.from(
          json["offers"].map((x) => OfferModel.fromJson(x))),
      note: json["note"],
      time: json["time"],
      acceptedTime: json["acceptedTime"],
      pickedUpTime: json["pickedUpTime"],
      deliveredTime: json["deliveredTime"],
      driverId: json["driverId"],
      driverImage: json["driverImage"],
      driverName: json["driverName"],
      driverPhoneNumber: json["driverPhoneNumber"],
      deliveryFee: json["deliveryFee"],
      voucher: VoucherModel.fromJson(json["voucher"]),
      state: json["state"],
      rate: OrderRateModel.fromJson(json["rate"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "orderNumber": orderNumber,
        "restaurantId": restaurantId,
        "location": location.toJson(),
        "phoneNumber": phoneNumber,
        "userFCMToken": userFCMToken,
        "items": List<Map<String, dynamic>>.generate(
            items.length, (index) => items[index].toJson()),
        "offers": List<Map<String, dynamic>>.generate(
            offers.length, (index) => offers[index].toJson()),
        "note": note,
        "time": time,
        "acceptedTime": acceptedTime,
        "pickedUpTime": pickedUpTime,
        "deliveredTime": deliveredTime,
        "driverId": driverId,
        "driverName": driverName,
        "driverPhoneNumber": driverPhoneNumber,
        "driverImage": driverImage,
        "deliveryFee": deliveryFee,
        "voucher": voucher.toJson(),
        "state": state,
        "rate": rate.toJson()
      };
}

OrderItemModel orderItemModelFromJson(String str) =>
    OrderItemModel.fromJson(json.decode(str));

String orderItemModelToJson(OrderItemModel data) => json.encode(data.toJson());

class OrderItemModel {
  String id;
  String firestoreItemId;
  String firestoreCategoryId;
  String categoryId;
  SizeModel size;
  int quantity;

  OrderItemModel(
      {required this.id,
      required this.firestoreItemId,
      required this.firestoreCategoryId,
      required this.categoryId,
      required this.size,
      required this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
      id: json["id"],
      firestoreCategoryId: json["firestoreCategoryId"],
      firestoreItemId: json["firestoreItemId"],
      categoryId: json["categoryId"],
      size: SizeModel.fromJson(json["size"]),
      quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "firestoreCategoryId": firestoreCategoryId,
        "firestoreItemId": firestoreItemId,
        "categoryId": categoryId,
        "quantity": quantity,
        "size": size.toJson(),
      };
}
