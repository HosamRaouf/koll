import 'dart:convert';

UserOrderDataModel userOrderDataModelFromJson(String str) => UserOrderDataModel.fromJson(json.decode(str));

String userOrderDataModelToJson(UserOrderDataModel data) => json.encode(data.toJson());

class UserOrderDataModel {
  String restaurantId;
  String orderId;

  UserOrderDataModel({
    required this.restaurantId,
    required this.orderId,
  });

  factory UserOrderDataModel.fromJson(Map<String, dynamic> json) => UserOrderDataModel(
    restaurantId: json["restaurantId"],
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "restaurantId": restaurantId,
    "orderId": orderId,
  };
}
