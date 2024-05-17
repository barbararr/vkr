import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_patient_main_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_search_user.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_user_registration.dart';
import 'package:flutter/material.dart';

import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import '../../../../common/globals.dart' as globals;
import 'desktop_admin_appbar.dart';

class DesktopPatientListPageAdmin extends StatefulWidget {
  const DesktopPatientListPageAdmin({Key? key}) : super(key: key);

  @override
  State<DesktopPatientListPageAdmin> createState() =>
      _DesktopPatientListPageAdminState();
}

class _DesktopPatientListPageAdminState
    extends State<DesktopPatientListPageAdmin> {
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

  void patientIdProfile(int index) {
    globals.currentPatientID = patients[index].id;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => (const DesktopMainPatientPageAdmin())));
  }

  String getPatientName(int index) {
    return patients[index].lastname +
        " " +
        patients[index].firstname +
        " " +
        patients[index].fathername;
  }

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
                        'Поиск',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () => {
                        globals.userToSearch = "patient",
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                (const DesktopSearchUserPageAdmin())))
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: thirdColor,
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    height: 30,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    child: RaisedButton(
                      child: const Text(
                        'Добавить',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => (const Registration()))),
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
