import 'dart:convert';

import 'dart:developer';

import 'parameter_model.dart';

ModuleWithParametersModel moduleWithParametersModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return ModuleWithParametersModel.fromJson(user);
}

List<ModuleWithParametersModel> moduleWithParametersModelListFromJson(
        String str) =>
    List<ModuleWithParametersModel>.from(
        json.decode(str).map((x) => ModuleWithParametersModel.fromJson(x)));

String moduleWithParametersModelToJson(ModuleWithParametersModel data) =>
    json.encode(data.toJson());

class ModuleWithParametersModel {
  ModuleWithParametersModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.dateTime,
    required this.parameterList,
    required this.isRed,
  });

  String id;
  String name;
  int frequency;
  String dateTime;
  List<ParameterModel> parameterList;
  bool isRed;

  factory ModuleWithParametersModel.fromJson(Map<String, dynamic> json) {
    return ModuleWithParametersModel(
        id: json["id"],
        name: json["name"],
        frequency: json["frequency"],
        dateTime: json["dateTime"],
        isRed: json["red"],
        parameterList:
            parameterModelListFromJson(jsonEncode(json["parameterList"])));
  }

  String parametersToString() {
    String str = "";
    for (var i = 0; i < parameterList.length; i++) {
      str += parameterList[i].name;
      if (i != parameterList.length - 1) {
        str += ", ";
      }
    }
    return str;
  }

  Map<String, String> toJson() => {
        "id": id,
        "name": name,
      };
}
