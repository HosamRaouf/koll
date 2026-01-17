
import 'dart:convert';

import 'item_model.dart';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String id;
  String firestoreId;
  String name;
  String image;
  String type;
  String time;
  List<ItemModel> items;

  CategoryModel({
    required this.id,
    required this.firestoreId,
    required this.name,
    required this.image,
    required this.time,
    required this.type,
    required this.items,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    firestoreId: json["firestoreId"],
    name: json["name"],
    image: json["image"],
    time: json['time'].toString(),
    type: json["type"],
    items: List<ItemModel>.from(json["items"].map((x) => ItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firestoreId": firestoreId,
    "name": name,
    "image": image,
    "time": time.toString(),
    "type": type,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}


