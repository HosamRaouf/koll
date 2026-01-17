import 'dart:convert';

RestaurantRate restaurantRateFromJson(String str) =>
    RestaurantRate.fromJson(json.decode(str));

String restaurantRateToJson(RestaurantRate data) => json.encode(data.toJson());

class RestaurantRate {
  String userName;
  String userImage;
  String restaurantId;
  String userId;
  double rate;
  String feedback;
  String time;

  RestaurantRate({
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rate,
    required this.feedback,
    required this.time,
  });

  factory RestaurantRate.fromJson(Map<String, dynamic> json) => RestaurantRate(
        rate: json["rate"].toDouble(),
        userName: json["userName"],
        userImage: json["userImage"],
        restaurantId: json["restaurantId"],
        userId: json["userId"],
        feedback: json["feedback"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "restaurantId": restaurantId,
        "rate": rate,
        "userId": userId,
        "userName": userName,
        "userImage": userImage,
        "feedback": feedback,
        "time": time,
      };
}
