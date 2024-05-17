import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_doctors_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_patients_admin.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import 'dart:developer';
import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import '../date_formatter.dart';
import '../../../../common/globals.dart' as globals;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  List<String> patientData = [];

  Map<String, String> userData = {
    'username': '',
    'firstname': '',
    'lastname': '',
    'email': '',
    'birthday': '',
    'sex': '',
    'password': '',
    'fathername': '',
    'roleId': '',
  };

  List<String> categories = ['Доктор', 'Пациент'];
  List<String> elementsEnterPatient = [
    'username',
    'firstname',
    'lastname',
    'email',
    'birthday',
    'sex',
    'password',
    'fathername',
  ];

  List<String> elementsEnterDoctor = [
    'username',
    'firstname',
    'lastname',
    'email',
    'birthday',
    'sex',
    'password',
    'fathername',
  ];

  String selectedCategory = '';

  List<String> listOfElements = [];

  final _formkey = GlobalKey<FormState>();

  Future<void> registerUser() async {
    UserModel userModel = UserModel(
        id: "",
        username: userData['username'].toString(),
        firstname: userData['firstname'].toString(),
        lastname: userData['lastname'].toString(),
        fathername: userData['fathername'].toString(),
        email: userData['email'].toString(),
        password: userData['password'].toString(),
        roleId: userData['roleId'].toString(),
        birthday: userData['birthday'].toString(),
        sex: userData['sex'].toString());
    bool completed = await ApiDataProvider().createUser(userModel);
    if (completed == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Check the correctness of input data!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Пользователь зарегистрирован'),
      ));
      if (userData['roleId'].toString() == globals.doctorRoleId) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ((const DesktopDoctorsListPageAdmin()))));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ((const DesktopPatientListPageAdmin()))));
      }
    }
  }

  String validate(String? value, String element) {
    String valid = "";
    if (value == null || value.isEmpty) {
      valid = 'please enter some text';
    } else if (element == "email" &&
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value)) {
      valid = "please enter a valid email";
    } else if (element == "birthday" &&
        (value.length < 10 || !RegExp(r'^[0-9-]+$').hasMatch(value))) {
      valid = "please enter a valid birthday: yyyy-mm-dd";
    } else if (element == "sex" && (value != "female" && value != "male")) {
      valid = "please enter a valid sex: female/male";
    }
    return valid;
  }

  void showError(String error) {
    if (error != "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ));
    }
  }

  bool isValid = true;
  String errorMessage = "";

  String currentValue = "";
  bool editingComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: firstColor,
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
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
              children: categories
                  .map((category) => ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedCategory = category;
                              if (selectedCategory == 'Доктор') {
                                userData['roleId'] = globals.doctorRoleId;
                                listOfElements =
                                    List<String>.from(elementsEnterDoctor);
                              } else {
                                userData['roleId'] = globals.patientRoleId;
                                listOfElements =
                                    List<String>.from(elementsEnterPatient);
                              }
                            } else {
                              selectedCategory = '';
                            }
                          });
                        },
                      ))
                  .toList(),
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
                            for (int i = 0; i < listOfElements.length; i++)
                              Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextFormField(
                                      inputFormatters:
                                          listOfElements[i] == "birthday"
                                              ? [DateTextFormatter()]
                                              : [],
                                      onChanged: (value) {
                                        setState(() {
                                          errorMessage = "";
                                          errorMessage = validate(
                                              value, listOfElements[i]);
                                          isValid =
                                              errorMessage == "" ? true : false;
                                          userData[listOfElements[i]] = value;
                                          if (errorMessage != "") {
                                            showError(errorMessage);
                                          }
                                        });
                                      },
                                      cursorColor: secondColor,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: secondColor,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        hintText: listOfElements[i],
                                        labelText: listOfElements[i],
                                        hintStyle: const TextStyle(
                                            fontSize: 16.0, color: secondColor),
                                        labelStyle: const TextStyle(
                                            fontSize: 16.0, color: secondColor),
                                        border: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: secondColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9.0))),
                                      ))),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Container(
                                  child: RaisedButton(
                                    child: const Text(
                                      'Зарегистрировать',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    onPressed: () {
                                      log(userData.toString());
                                      registerUser();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
            ),
          ],
        ),
      ),
    );
  }
}
