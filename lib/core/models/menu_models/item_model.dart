
import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
  String id;
  String firestoreId;
  String name;
  String image;
  String description;
  String time;
  int ordered;
  List<String> images;
  List<SizeModel> prices;

  ItemModel({
    required this.id,
    required this.firestoreId,
    required this.name,
    required this.image,
    required this.description,
    required this.ordered,
    required this.time,
    required this.images,
    required this.prices,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json["id"],
    firestoreId: json["firestoreId"],
    time: json['time'].toString(),
    name: json["name"],
    image: json["image"],
    description: json["description"],
    ordered: json["ordered"],
    images: List<String>.from(json["images"].map((x) => x)),
    prices: List<SizeModel>.from(json["prices"].map((x) => SizeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firestoreId": firestoreId,
    "name": name,
    "time": time.toString(),
    "image": image,
    "description": description,
    "ordered": ordered,
    "images": List<dynamic>.from(images.map((x) => x)),
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
  };
}


class SizeModel {
  String id;
  String name ;
  double price ;


  SizeModel({
    required this.id,
    required this.name,
    required this.price,


  });
  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
    id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString())
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price
  };
}
