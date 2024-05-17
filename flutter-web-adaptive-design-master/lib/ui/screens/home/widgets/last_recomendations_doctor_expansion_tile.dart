import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/recomendation_model.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;
import '../../../common/models/user_model.dart';
import 'api_data_provider.dart';

class LastRecomendationsDoctorExpansionTile extends StatefulWidget {
  const LastRecomendationsDoctorExpansionTile({Key? key}) : super(key: key);

  @override
  State<LastRecomendationsDoctorExpansionTile> createState() =>
      _LastRecomendationsDoctorExpansionTileState();
}

class _LastRecomendationsDoctorExpansionTileState
    extends State<LastRecomendationsDoctorExpansionTile> {
  List<RecommendationModel> recommendations = [];
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _getData();
    print(recommendations.length.toString() + "u");
  }

  void _getData() async {
    recommendations = await ApiDataProvider().getLastRecommendationsDoctor(
        globals.currentPatientID, globals.user!.id);
    buildString();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    print(recommendations.length.toString() + "pop");
  }

  Future<String> getDoctorName(String id) async {
    UserModel doctor = await ApiDataProvider().getUser(id);
    return doctor.lastname + " " + doctor.firstname + " " + doctor.fathername;
  }

  Future<void> buildString() async {
    for (var i = 0; i < recommendations.length; i++) {
      String doctorName = await getDoctorName(recommendations[i].doctorId);

      Map<String, dynamic> recordString = {};
      recordString.addAll({
        "id": recommendations[i].datetime,
        "name": "Рекомендация " +
            recommendations[i].datetime.replaceAll("T", " ") +
            " " +
            doctorName,
        "detail": recommendations[i].recommendation
      });
      records.add(recordString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: records.length,
      itemBuilder: (_, index) {
        final item = records[index];
        return Card(
          key: PageStorageKey(item['id']),
          child: ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            childrenPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            maintainState: true,
            title: Text(item['name']),
            textColor: firstColor,
            iconColor: firstColor,
            children: [
              ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.comment),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.018),
                    foregroundColor: firstColor,
                  ),
                  title: Text(item['detail'])),
            ],
          ),
        );
      },
    );
  }
}
