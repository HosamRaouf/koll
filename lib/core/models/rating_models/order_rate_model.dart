import 'dart:convert';

OrderRateModel orderRateModelFromJson(String str) => OrderRateModel.fromJson(json.decode(str));

String orderRateModelToJson(OrderRateModel data) => json.encode(data.toJson());

class OrderRateModel {
  String restaurantId;
  String orderId;
  String userId;
  int rate;
  String feedback;
  String time;

  OrderRateModel({
    required this.restaurantId,
    required this.userId,
    required this.orderId,
    required this.rate,
    required this.feedback,
    required this.time,
  });

  factory OrderRateModel.fromJson(Map<String, dynamic> json) => OrderRateModel(
    restaurantId: json["restaurantId"],
    userId: json["userId"],
    orderId: json["orderId"],
    rate: json["rate"],
    feedback: json["feedback"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "restaurantId": restaurantId,
    "userId": userId,
    "orderId": orderId,
    "rate": rate,
    "feedback": feedback,
    "time": time,
  };
}
