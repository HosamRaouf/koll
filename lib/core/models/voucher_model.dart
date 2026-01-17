import 'dart:convert';

VoucherModel voucherModelFromJson(String str) => VoucherModel.fromJson(json.decode(str));

String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
  String id;
  String firestoreId;
  String name;
  int discount;
  int limit;
  String time;

  VoucherModel({
    required this.id,
    required this.firestoreId,
    required this.name,
    required this.discount,
    required this.limit,
    required this.time,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
    id: json["id"],
    firestoreId: json["firestoreId"],
    name: json["name"],
    discount: json["discount"],
    limit: json["limit"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firestoreId" : firestoreId,
    "name": name,
    "discount": discount,
    "limit": limit,
    "time": time,
  };
}
