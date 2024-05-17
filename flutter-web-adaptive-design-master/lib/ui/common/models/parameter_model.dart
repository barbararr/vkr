import 'dart:convert';

import 'dart:developer';

ParameterModel parameterModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;
  return ParameterModel.fromJson(user);
}

List<ParameterModel> parameterModelListFromJson(String str) =>
    List<ParameterModel>.from(
        json.decode(str).map((x) => ParameterModel.fromJson(x)));

String parameterModelToJson(ParameterModel data) => json.encode(data.toJson());

class ParameterModel {
  ParameterModel({
    required this.id,
    required this.dataType,
    required this.name,
    required this.description,
    required this.moduleId,
    required this.value,
  });

  String id;
  String dataType;
  String name;
  String description;
  String moduleId;
  String value;
  List<String> options = [];
  List<String> selectedOptions = [];
  bool isChecked = false;

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      id: json["id"],
      dataType: json["dataType"],
      name: json["name"],
      description: json["description"],
      moduleId: json["moduleId"],
      value: json["value"],
    );
  }

  Map<String, String> toJson() => {
        "id": id,
        "dataType": dataType,
        "name": name,
        "description": description,
        "moduleId": moduleId,
        "value": value,
      };
}
