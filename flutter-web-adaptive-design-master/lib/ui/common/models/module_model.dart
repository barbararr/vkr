import 'dart:convert';

import 'dart:developer';

import 'package:flutter/material.dart';

import 'doctor_parameter_model.dart';
import 'parameter_model.dart';

ModuleModel moduleModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return ModuleModel.fromJson(user);
}

List<ModuleModel> moduleModelListFromJson(String str) => List<ModuleModel>.from(
    json.decode(str).map((x) => ModuleModel.fromJson(x)));

String moduleModelToJson(ModuleModel data) => json.encode(data.toJson());

class ModuleModel {
  ModuleModel({
    required this.id,
    required this.questionaryId,
    required this.name,
    required this.frequency,
    required this.parameterList,
  });

  String id;
  String name;
  String questionaryId;
  int frequency;
  List<ParameterModel> parameterList;
  List<DoctorParameterModel> doctorParameterList = [];
  List<Row> rows = [];

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
        id: json["id"],
        questionaryId: json["questionaryId"],
        name: json["name"],
        frequency: json["frequency"],
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
