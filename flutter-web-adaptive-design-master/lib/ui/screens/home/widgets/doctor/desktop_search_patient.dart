import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/user_model.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_patient_doctor.dart';
import 'package:flutter/material.dart';

import '../api_data_provider.dart';
import '../../../../common/globals.dart' as globals;

class DesktopSearchPatientPageDoctor extends StatefulWidget {
  const DesktopSearchPatientPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopSearchPatientPageDoctor> createState() =>
      _DesktopSearchPatientPageDoctorState();
}

class _DesktopSearchPatientPageDoctorState
    extends State<DesktopSearchPatientPageDoctor> {
  List<UserModel> patients = [];
  List<UserModel> sortedPatients = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    if (globals.searchInfo != '') {
      print(globals.searchInfo);
      patients = await ApiDataProvider()
          .serchPatient(globals.searchInfo, globals.patientRoleId);
      globals.searchInfo = "";
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void patientIdProfile(int index) {
    globals.currentPatientID = patients[index].id;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => (const DesktopMainPatientPageDoctor())));
  }

  String getPatientsName(int index) {
    return patients[index].lastname +
        " " +
        patients[index].firstname +
        " " +
        patients[index].fathername;
  }

  List<String> categories = ['Поиск'];

  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DoctorAppbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    child: const Text(
                      'Пациенты',
                      style: TextStyle(color: firstColor, fontSize: 22),
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 30,
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    globals.searchInfo = value;
                  }),
                  cursorColor: secondColor,
                  decoration: const InputDecoration(
                    hintText: "Введите текст",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: fourthColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor),
                        borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 25,
                backgroundColor: secondColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const DesktopSearchPatientPageDoctor(),
                        transitionDuration: const Duration(milliseconds: 100),
                        transitionsBuilder: (_, a, __, c) =>
                            FadeTransition(opacity: a, child: c),
                      )),
                ),
              ),
            ]),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            patients.isEmpty
                ? Text("пустой запрос или такого пользователя нет")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: patients.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        child: Row(children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.2),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 50,
                                child: Card(
                                  child: Center(
                                    child: Text(getPatientsName(index),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        textAlign: TextAlign.justify),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                        onTap: () => patientIdProfile(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
