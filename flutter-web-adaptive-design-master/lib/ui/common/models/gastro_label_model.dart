import 'dart:convert';

import 'dart:developer';

GastroLabelModel gastroLabelModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;
  return GastroLabelModel.fromJson(user);
}

List<GastroLabelModel> gastroLabelModelListFromJson(String str) =>
    List<GastroLabelModel>.from(
        json.decode(str).map((x) => GastroLabelModel.fromJson(x)));

String gastroLabelModelToJson(GastroLabelModel data) =>
    json.encode(data.toJson());

class GastroLabelModel {
  GastroLabelModel({
    required this.id,
    required this.name,
    required this.isRedFlag,
  });

  String id;
  String name;
  String isRedFlag;

  factory GastroLabelModel.fromJson(Map<String, dynamic> json) {
    return GastroLabelModel(
      id: json["id"],
      name: json["name"],
      isRedFlag: json["isRedFlag"],
    );
  }

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
        "isRedFlag": isRedFlag,
      };
}
