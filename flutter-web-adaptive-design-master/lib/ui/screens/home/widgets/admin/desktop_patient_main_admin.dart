import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_add_doctor_to_user.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_admin_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_user_changing.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_recomendation.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_last_records_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_modules_doctor.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import 'desktop_patients_admin.dart';

import '../../../../common/globals.dart' as globals;

class DesktopMainPatientPageAdmin extends StatefulWidget {
  const DesktopMainPatientPageAdmin({Key? key}) : super(key: key);

  @override
  State<DesktopMainPatientPageAdmin> createState() =>
      _DesktopMainPatientPageAdminState();
}

class _DesktopMainPatientPageAdminState
    extends State<DesktopMainPatientPageAdmin> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
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
      fathername: "",
      password: "",
      roleId: "",
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
                            (const DesktopMainPatientPageAdmin())));
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
                });
              }),
        )
        .toList();
  }

  void deletePatient() async {
    if (!(await ApiDataProvider().deleteUser(globals.currentPatientID))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Произошла ошибка!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Пользователь удалён')));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DesktopPatientListPageAdmin(),
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppbar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Container(
                      child: RaisedButton(
                        child: const Text(
                          'Прикрепить к врачу',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  (const DesktopAddDoctorToPatient())))
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: thirdColor,
                      ),
                      width: MediaQuery.of(context).size.width / 5,
                      height: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Container(
                      child: RaisedButton(
                        child: const Text(
                          'Редактировать',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => {
                          globals.userToChange = globals.currentPatientID,
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  (const UserChangingAdmin())))
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: thirdColor,
                      ),
                      width: MediaQuery.of(context).size.width / 5,
                      height: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Container(
                      child: RaisedButton(
                        child: const Text(
                          'Удалить',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () => {deletePatient()},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: thirdColor,
                      ),
                      width: MediaQuery.of(context).size.width / 5,
                      height: 30,
                    ),
                  ),
                ],
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
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
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
      ),
    );
  }
}
