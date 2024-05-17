import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_modules_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_last_records.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_statistics_patient.dart';
import 'package:flutter/material.dart';

import '../../../../common/globals.dart' as globals;

class DesktopMainPatientPagePatient extends StatefulWidget {
  const DesktopMainPatientPagePatient({Key? key}) : super(key: key);

  @override
  State<DesktopMainPatientPagePatient> createState() =>
      _DesktopMainPatientPagePatientState();
}

class _DesktopMainPatientPagePatientState
    extends State<DesktopMainPatientPagePatient> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Добавить запись'
  ];

  Map<String, String> patientData = {};

  List<String> elementsEnterDoctor = ['Email', 'Password', 'Name'];
  String selectedCategory = '';
  List<String> listOfElements = [];

  Map<String, String>? getPatientData() {
    return globals.user?.getData();
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
                  if (selectedCategory == 'Данные') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopMainPatientPagePatient())));
                  }
                  if (selectedCategory == 'Последние записи') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopPatientLastRecordsPagePatient())));
                  }
                  if (selectedCategory == 'Добавить запись') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopModulesPagePatient())));
                  }
                  if (selectedCategory == 'Статистика') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopStatisticsPatientPagePatient())));
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
      appBar: const PatientAppbar(),
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
