import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/existing_modules_expansion_tile.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import 'desktop_patient_doctor.dart';

class DesktopExistingModulesPageDoctor extends StatefulWidget {
  const DesktopExistingModulesPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopExistingModulesPageDoctor> createState() =>
      _DesktopExistingModulesPageDoctorState();
}

class _DesktopExistingModulesPageDoctorState
    extends State<DesktopExistingModulesPageDoctor> {
  List<String> categories = ['Новые', 'Назначенные'];
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
              child: Row(children: [
                Container(
                  child: RaisedButton.icon(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'к пациенту',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ((const DesktopMainPatientPageDoctor())))),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: firstColor,
                  ),
                  width: MediaQuery.of(context).size.width / 5,
                  height: 30,
                ),
              ]),
            ),
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
                                child: ExistingModulesExpansionTile()),
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
