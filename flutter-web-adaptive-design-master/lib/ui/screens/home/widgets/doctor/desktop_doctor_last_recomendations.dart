import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_last_records_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/last_recomendations_doctor_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'desktop_doctor_recomendation.dart';
import 'desktop_existing_modules.dart';
import 'desktop_modules_doctor.dart';
import 'desktop_patient_doctor.dart';
import 'desktop_statistics_doctor.dart';

class DesktopLastRecomendationsPageDoctor extends StatefulWidget {
  const DesktopLastRecomendationsPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopLastRecomendationsPageDoctor> createState() =>
      _DesktopLastRecomendationsPageDoctorState();
}

class _DesktopLastRecomendationsPageDoctorState
    extends State<DesktopLastRecomendationsPageDoctor> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Рекомендации',
    'Назначенные модули',
    'Назначить модуль',
    'Дать рекомендацию',
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
                                child: LastRecomendationsDoctorExpansionTile()),
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
