import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_doctors_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_main_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_patients_list_doctor.dart';
import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import 'api_data_provider.dart';
import '../../../common/globals.dart' as globals;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  String login = '';
  String password = '';

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    globals.logedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: firstColor,
        title: const Text('Вход'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.blueGrey)),
                  child: Image.asset('lib/ui/common/logos/logo2.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                  onChanged: (value) => login = value,
                                  cursorColor: secondColor,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: secondColor,
                                        width: 2.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: 'Username',
                                    labelText: 'Username',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: secondColor,
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: 16.0, color: secondColor),
                                    labelStyle: TextStyle(
                                        fontSize: 16.0, color: secondColor),
                                    errorStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0))),
                                  ))),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (value) => password = value,
                              cursorColor: secondColor,
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: secondColor,
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                hintText: 'Password',
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: secondColor,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: secondColor),
                                labelStyle: TextStyle(
                                    fontSize: 16.0, color: secondColor),
                                errorStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0))),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                child: RaisedButton(
                                  child: const Text(
                                    'Войти',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  onPressed: () {
                                    ApiDataProvider().login(login, password);
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      if (!globals.logedIn) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Проверьте корректность введенных значений!'),
                                          backgroundColor: Colors.red,
                                        ));
                                      } else {
                                        if (globals.user!.roleId ==
                                            globals.doctorRoleId) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ((const DesktopPatientListPageDoctor()))));
                                        } else {
                                          if (globals.user!.roleId ==
                                              globals.patientRoleId) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ((const DesktopMainPatientPagePatient()))));
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ((const DesktopDoctorsListPageAdmin()))));
                                          }
                                        }
                                      }
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: firstColor,
                                ),
                                width: MediaQuery.of(context).size.width / 3,
                                height: 50,
                              ),
                            ),
                          ),
                        ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
