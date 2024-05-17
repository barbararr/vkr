import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_last_recomendations.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_recomendation.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_last_records_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_modules_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_statistics_doctor.dart';
import 'package:flutter/material.dart';
import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import 'desktop_existing_modules.dart';

import '../../../../common/globals.dart' as globals;

class DesktopMainPatientPageDoctor extends StatefulWidget {
  const DesktopMainPatientPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopMainPatientPageDoctor> createState() =>
      _DesktopMainPatientPageDoctorState();
}

class _DesktopMainPatientPageDoctorState
    extends State<DesktopMainPatientPageDoctor> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Рекомендации',
    'Назначенные модули',
    'Назначить модуль',
    'Дать рекомендацию',
  ];

  Map<String, String> patientData = {};

  String selectedCategory = '';

  UserModel patient = UserModel(
      id: '',
      username: "",
      firstname: "",
      lastname: "",
      email: "",
      password: "",
      roleId: "",
      fathername: "",
      birthday: "",
      sex: "");

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    patient = (await ApiDataProvider().getUser(globals.currentPatientID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  Map<String, String>? getPatientData() {
    return patient.getData();
  }

  List<TextSpan> createListText() {
    patientData = getPatientData()!;
    List<TextSpan> list = [];
    for (var v in patientData.keys) {
      list.add(TextSpan(
          text: v + ':', style: const TextStyle(fontWeight: FontWeight.bold)));
      list.add(const TextSpan(text: " "));
      list.add(TextSpan(text: patientData[v]));
      list.add(const TextSpan(text: "\n\n"));
    }
    return list;
  }

  TextSpan patientDataToString() {
    var text = TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: createListText());
    print(text);
    return text;
  }

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
                  if (selectedCategory == 'Дать рекомендацию') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopRecomendationPageDoctor())));
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
            //Spacer(),
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
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Card(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                            text: patientDataToString()),
                                      ),
                                    ],
                                  ),
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
