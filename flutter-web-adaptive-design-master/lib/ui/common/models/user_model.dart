import 'dart:convert';

import 'dart:developer';

import 'package:intl/intl.dart';

UserModel userModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;
  return UserModel.fromJson(user);
}

List<UserModel> userModelListFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.fathername,
    required this.email,
    required this.password,
    required this.roleId,
    required this.birthday,
    required this.sex,
  });

  String id = "";
  String username;
  String firstname;
  String lastname;
  String email;
  String birthday;
  String sex;
  String password;
  String fathername;
  String roleId;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      fathername: json["fathername"],
      email: json["email"],
      password: json["passwordHash"],
      roleId: json["roleId"],
      birthday: json["birthday"],
      sex: json["sex"],
    );
  }

  Map<String, String> toJson() => {
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "fathername": fathername,
        "email": email,
        "password": password,
        "roleId": roleId,
        "birthday": birthday,
        "sex": sex,
      };

  Map<String, String> getData() => {
        "имя": firstname,
        "фамилия": lastname,
        "отчество": fathername,
        "почта": email,
        "дата рождения": birthday,
        "пол": sex,
      };
}
