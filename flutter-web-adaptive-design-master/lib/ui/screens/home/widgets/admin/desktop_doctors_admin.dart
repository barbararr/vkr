import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_admin_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_doctor_main_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_user_registration.dart';
import 'package:flutter/material.dart';

import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import '../../../../common/globals.dart' as globals;
import 'desktop_search_user.dart';

class DesktopDoctorsListPageAdmin extends StatefulWidget {
  const DesktopDoctorsListPageAdmin({Key? key}) : super(key: key);

  @override
  State<DesktopDoctorsListPageAdmin> createState() =>
      _DesktopDoctorsListPageAdminState();
}

class _DesktopDoctorsListPageAdminState
    extends State<DesktopDoctorsListPageAdmin> {
  List<UserModel> doctors = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    doctors = await ApiDataProvider().getDoctorsAdmin();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void doctorIdProfile(int index) {
    globals.currentDoctorID = doctors[index].id;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => (const DesktopMainDoctorPageAdmin())));
  }

  String getDoctorsName(int index) {
    return doctors[index].lastname +
        " " +
        doctors[index].firstname +
        " " +
        doctors[index].fathername;
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
                      'Доктора',
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
                        globals.userToSearch = "doctor",
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
              itemCount: doctors.length,
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
                              child: Text(getDoctorsName(index),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                  textAlign: TextAlign.justify),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                  onTap: () => {doctorIdProfile(index)},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
