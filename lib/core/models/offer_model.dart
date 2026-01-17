// To parse this JSON data, do
//
//     final offer = offerFromJson(jsonString);

import 'dart:convert';

import 'order_model.dart';

OfferModel offerFromJson(String str) => OfferModel.fromJson(json.decode(str));

String offerToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {


  String id;
  String firestoreId;
  String restaurantFirestoreId;
  String image;
  String title;
  List<OrderItemModel> meals;
  int price;
  bool deliveryFee;

  OfferModel({
    required this.id,
    required this.firestoreId,
    required this.restaurantFirestoreId,
    required this.image,
    required this.title,
    required this.meals,
    required this.price,
    required this.deliveryFee,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
    id: json["id"],
    firestoreId: json["firestoreId"],
    restaurantFirestoreId: json["restaurantFirestoreId"],
    image: json["image"],
    title: json["title"],
    meals: List<OrderItemModel>.from(json["meals"].map((x) => OrderItemModel.fromJson(x))),
    price: json["price"],
    deliveryFee: json["deliveryFee"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firestoreId": firestoreId,
    "restaurantFirestoreId": restaurantFirestoreId,
    "image": image,
    "title": title,
    "meals": List.generate(meals.length, (index) => meals[index].toJson()),
    "price": price,
    "deliveryFee": deliveryFee,
  };
}