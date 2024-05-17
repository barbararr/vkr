import 'dart:convert';

import 'dart:developer';

RecommendationModel recommendationModelFromJson(String str) {
  log("str " + str);
  final user = jsonDecode(str) as Map<String, dynamic>;

  return RecommendationModel.fromJson(user);
}

List<RecommendationModel> recomendationModelListFromJson(String str) =>
    List<RecommendationModel>.from(
        json.decode(str).map((x) => RecommendationModel.fromJson(x)));

String recomendationModelToJson(RecommendationModel data) =>
    json.encode(data.toJson());

class RecommendationModel {
  RecommendationModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.recommendation,
    required this.datetime,
  });

  String id;
  String doctorId;
  String patientId;
  String recommendation;
  String datetime;

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
        id: json["id"],
        doctorId: json["doctorId"],
        patientId: json["patientId"],
        datetime: json["datetime"],
        recommendation: json["recommendation"]);
  }

  Map<String, String> toJson() => {
        "patientId": patientId,
        "doctorId": doctorId,
        "recommendation": recommendation
      };
}
