import 'dart:convert';

import 'dart:developer';

ProductModel productModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;
  return ProductModel.fromJson(user);
}

List<ProductModel> productModelListFromJson(String str) =>
    List<ProductModel>.from(
        json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;
  List<String> products = [];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
      };
}
