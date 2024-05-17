import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_existing_modules.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../api_data_provider.dart';
import 'desktop_doctor_last_recomendations.dart';
import 'desktop_last_records_doctor.dart';
import 'desktop_modules_doctor.dart';
import 'desktop_patient_doctor.dart';
import '../../../../common/globals.dart' as globals;
import 'desktop_statistics_doctor.dart';

class DesktopRecomendationPageDoctor extends StatefulWidget {
  const DesktopRecomendationPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopRecomendationPageDoctor> createState() =>
      _DesktopRecomendationPageDoctorState();
}

class _DesktopRecomendationPageDoctorState
    extends State<DesktopRecomendationPageDoctor> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Рекомендации',
    'Назначенные модули',
    'Назначить модуль',
    'Дать рекомендацию',
  ];
  String selectedCategory = '';
  List<String> listOfElements = [];
  String recommendation = "";

  List<Widget> getChoiceChips() {
    return categories
        .map(
          (category) => ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedCategory = category;
                  } else {
                    selectedCategory = '';
                  }
                  if (selectedCategory == 'Назначить модуль') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopModulesPageDoctor())));
                  }
                  if (selectedCategory == 'Данные') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopMainPatientPageDoctor())));
                  }
                  if (selectedCategory == 'Последние записи') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopPatientLastRecordsPageDoctor())));
                  }
                  if (selectedCategory == 'Статистика') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopStatisticsDoctorPagePatient())));
                  }
                  if (selectedCategory == 'Рекомендации') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopLastRecomendationsPageDoctor())));
                  }
                  if (selectedCategory == 'Назначенные модули') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopExistingModulesPageDoctor())));
                  }
                });
              }),
        )
        .toList();
  }

  Future<void> sendRecomendationData(String recommendation) async {
    String patientId = globals.currentPatientID;
    String doctorId = globals.user!.id;
    recommendation = recommendation.split('\n').join('\\n');
    String json =
        "{\"patientId\": \"$patientId\", \"doctorId\": \"$doctorId\", \"recommendation\": \"$recommendation\"}";
    print(json);
    if (!(await ApiDataProvider().sendRecommendation(json))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Произошла ошибка!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DoctorAppbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 60,
              height: 60,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: getChoiceChips()),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  minLines: 1,
                                  maxLines: 20,
                                  onChanged: (value) => recommendation = value,
                                  cursorColor: secondColor,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: fourthColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0))),
                                  ),
                                )),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  child: RaisedButton(
                                    child: const Text(
                                      'отправить',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onPressed: () => {
                                      sendRecomendationData(recommendation),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 600),
                                              content:
                                                  Text('Запись добавлена'))),
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              ((const DesktopMainPatientPageDoctor()))))
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: firstColor,
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: 25,
                                ),
                              ),
                            ),
                          ]),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
