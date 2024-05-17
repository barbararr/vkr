import 'dart:convert';

import 'dart:developer';

import 'package:intl/intl.dart';

DoctorParameterModel doctorParameterModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return DoctorParameterModel.fromJson(user);
}

List<DoctorParameterModel> doctorParameterModelListFromJson(String str) =>
    List<DoctorParameterModel>.from(
        json.decode(str).map((x) => DoctorParameterModel.fromJson(x)));

String doctorParameterModelToJson(DoctorParameterModel data) =>
    json.encode(data.toJson());

class DoctorParameterModel {
  DoctorParameterModel({
    required this.id,
    required this.dataType,
    required this.name,
    required this.moduleId,
  });

  String id;
  String dataType;
  String name;
  String moduleId;
  String value = "";
  List<String> options = [];
  List<String> selectedOptions = [];
  bool isChecked = false;

  factory DoctorParameterModel.fromJson(Map<String, dynamic> json) {
    return DoctorParameterModel(
      id: json["id"],
      dataType: json["dataType"],
      name: json["name"],
      moduleId: json["moduleId"],
    );
  }

  Map<String, String> toJson() => {
        "id": id,
        "dataType": dataType,
        "name": name,
        "moduleId": moduleId,
      };
}
