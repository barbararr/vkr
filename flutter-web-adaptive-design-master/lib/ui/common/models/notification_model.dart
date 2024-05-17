import 'dart:convert';

import 'dart:developer';

NotificationModel notificationModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return NotificationModel.fromJson(user);
}

List<NotificationModel> notificationModelListFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.text,
    required this.datetime,
    required this.userId,
  });

  String id;
  String text;
  String datetime;
  String userId;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json["id"],
        text: json["text"],
        datetime: json["datetime"],
        userId: json["userId"]);
  }

  Map<String, String> toJson() => {
        "id": id,
        "text": text,
      };
}
