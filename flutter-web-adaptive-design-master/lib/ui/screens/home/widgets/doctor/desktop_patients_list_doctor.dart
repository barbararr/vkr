import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/user_model.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_patient_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_search_patient.dart';
import 'package:flutter/material.dart';

import '../api_data_provider.dart';
import '../../../../common/globals.dart' as globals;

class DesktopPatientListPageDoctor extends StatefulWidget {
  const DesktopPatientListPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopPatientListPageDoctor> createState() =>
      _DesktopPatientListPageDoctorState();
}

class _DesktopPatientListPageDoctorState
    extends State<DesktopPatientListPageDoctor> {
  List<UserModel> patients = [];
  List<UserModel> allPatients = [];
  List<UserModel> sortedPatients = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    allPatients = await ApiDataProvider().getPatientsDoctor(globals.user!.id);
    sortedPatients =
        await ApiDataProvider().getSortedPatientsDoctor(globals.user!.id);
    patients = allPatients;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  List<String> categories = ['Все пациенты', 'Срочные', 'Поиск'];

  String selectedCategory = '';

  void patientIdProfile(int index) {
    globals.currentPatientID = allPatients[index].id;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => (const DesktopMainPatientPageDoctor())));
  }

  String getPatientsName(int index) {
    return allPatients[index].lastname +
        " " +
        allPatients[index].firstname +
        " " +
        allPatients[index].fathername;
  }

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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories
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
                              if (selectedCategory == 'Все пациенты') {
                                patients = allPatients;
                              }
                              if (selectedCategory == 'Срочные') {
                                patients = sortedPatients;
                              }
                              if (selectedCategory == 'Поиск') {
                                Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const DesktopSearchPatientPageDoctor(),
                                      transitionDuration:
                                          const Duration(milliseconds: 100),
                                      transitionsBuilder: (_, a, __, c) =>
                                          FadeTransition(opacity: a, child: c),
                                    ));
                              }
                            });
                          }),
                    )
                    .toList()),
            const SizedBox(
              width: 20,
              height: 20,
            ),
            ListView.builder(
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
                                      color: Colors.black.withOpacity(0.6)),
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
