import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_admin_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import '../../../../common/globals.dart' as globals;

class DesktopAddPatientToDoctor extends StatefulWidget {
  const DesktopAddPatientToDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopAddPatientToDoctor> createState() =>
      _DesktopAddPatientToDoctorState();
}

class _DesktopAddPatientToDoctorState extends State<DesktopAddPatientToDoctor> {
  List<UserModel> patients = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    patients = await ApiDataProvider().getPatientsAdmin();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  Future<void> linkPatientToDoctor(int index) async {
    if (!(await ApiDataProvider()
        .linkPatientDoctor(patients[index].id, globals.currentDoctorID))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ошибка! Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  String getPatientName(int index) {
    return patients[index].lastname +
        " " +
        patients[index].firstname +
        " " +
        patients[index].fathername;
  }

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppbar(),
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    child: RaisedButton(
                      child: const Text(
                        'Прикрепить',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () => {
                        linkPatientToDoctor(selectedIndex!),
                        setState(() {
                          selectedIndex = -1;
                        }),
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 600),
                                content: Text('Пациент прикреплен')))
                      },
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
                              color: selectedIndex == index ? thirdColor : null,
                              child: Center(
                                child: Text(getPatientName(index),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                    textAlign: TextAlign.justify),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                    onTap: () => {
                          setState(() {
                            selectedIndex = index;
                          }),
                        });
              },
            ),
          ],
        ),
      ),
    );
  }
}
