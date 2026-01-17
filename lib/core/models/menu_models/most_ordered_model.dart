
import 'dart:convert';

MostOrderedModel mostOrderedModelFromJson(String str) => MostOrderedModel.fromJson(json.decode(str));

String mostOrderedModelToJson(MostOrderedModel data) => json.encode(data.toJson());

class MostOrderedModel {
  String categoryName;
  String categoryImage;
  String item;


  MostOrderedModel({
    required this.categoryName,
    required this.categoryImage,
    required this.item,
  });

  factory MostOrderedModel.fromJson(Map<String, dynamic> json) => MostOrderedModel(
    categoryName: json["categoryName"],
    categoryImage: json["categoryImage"],
    item: json["item"],
  );

  Map<String, dynamic> toJson() => {
    "categoryName": categoryName,
    "categoryImage": categoryImage,
    "item": item,
  };
}
