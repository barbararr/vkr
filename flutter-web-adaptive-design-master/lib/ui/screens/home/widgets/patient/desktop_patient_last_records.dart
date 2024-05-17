import 'package:adaptive_design/ui/screens/home/widgets/last_records_expansion_tile.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_appbar.dart';
import 'package:flutter/material.dart';

import 'desktop_main_patient.dart';
import 'desktop_modules_patient.dart';
import 'desktop_statistics_patient.dart';

class DesktopPatientLastRecordsPagePatient extends StatefulWidget {
  const DesktopPatientLastRecordsPagePatient({Key? key}) : super(key: key);

  @override
  State<DesktopPatientLastRecordsPagePatient> createState() =>
      _DesktopPatientLastRecordsPagePatientState();
}

class _DesktopPatientLastRecordsPagePatientState
    extends State<DesktopPatientLastRecordsPagePatient> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Добавить запись'
  ];
  List<String> elementsEnterPatient = [
    'ФИО',
    'Дата рождения',
    'Пол',
    'Вес',
    'Рост'
  ];
  List<String> elementsEnterDoctor = ['Email', 'Password', 'Name'];
  String selectedCategory = '';
  List<String> listOfElements = [];

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
                          children: const [
                            Padding(
                                padding: EdgeInsets.all(12.0),
                                child: LastRecordsExpansionTile()),
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
