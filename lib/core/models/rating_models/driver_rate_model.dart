import 'dart:convert';

DriverRateModel driverRateModelFromJson(String str) =>
    DriverRateModel.fromJson(json.decode(str));

String driverRateModelToJson(DriverRateModel data) =>
    json.encode(data.toJson());

class DriverRateModel {
  String restaurantId;
  String driverId;
  String userId;
  int rate;
  String feedback;
  String time;

  DriverRateModel({
    required this.restaurantId,
    required this.userId,
    required this.driverId,
    required this.rate,
    required this.feedback,
    required this.time,
  });

  factory DriverRateModel.fromJson(Map<String, dynamic> json) =>
      DriverRateModel(
        restaurantId: json["restaurantId"],
        userId: json["userId"],
        driverId: json["orderId"],
        rate: json["rate"],
        feedback: json["feedback"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "restaurantId": restaurantId,
        "userId": userId,
        "orderId": driverId,
        "rate": rate,
        "feedback": feedback,
        "time": time,
      };
}
