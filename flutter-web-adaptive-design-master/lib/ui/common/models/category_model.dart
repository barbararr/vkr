import 'dart:convert';

import 'dart:developer';

CategoryModel categoryModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return CategoryModel.fromJson(user);
}

List<CategoryModel> categoryModelListFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;
  List<String> products = [];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
      };
}
