import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_doctors_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_patients_admin.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/models/user_model.dart';
import '../api_data_provider.dart';
import '../date_formatter.dart';
import '../../../../common/globals.dart' as globals;

class UserChangingAdmin extends StatefulWidget {
  const UserChangingAdmin({Key? key}) : super(key: key);

  @override
  State<UserChangingAdmin> createState() => _UserChangingAdminState();
}

class _UserChangingAdminState extends State<UserChangingAdmin> {
  List<String> patientData = [];

  Map<String, String> userData = {
    'username': '',
    'firstname': '',
    'lastname': '',
    'email': '',
    'birthday': '',
    'sex': '',
    'fathername': '',
    'roleId': '',
  };

  Map<String, String> changedData = {
    'id': '',
    'username': '',
    'firstname': '',
    'lastname': '',
    'email': '',
    'birthday': '',
    'sex': '',
    'fathername': '',
    'roleId': '',
  };

  UserModel userToChange = UserModel(
      id: '',
      username: '',
      firstname: 'firstname',
      lastname: 'lastname',
      fathername: 'fathername',
      email: 'email',
      password: 'password',
      roleId: 'roleId',
      birthday: 'birthday',
      sex: 'sex');

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    userToChange = await ApiDataProvider().getUser(globals.userToChange);
    setState(() {
      userData['username'] = userToChange.username;
      userData['firstname'] = userToChange.firstname;
      userData['lastname'] = userToChange.lastname;
      userData['email'] = userToChange.email;
      userData['birthday'] = userToChange.birthday;
      userData['sex'] = userToChange.sex;
      userData['fathername'] = userToChange.fathername;
      changedData['id'] = userToChange.id;
    });

    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {}));
  }

  List<String> categories = ['Доктор', 'Пациент'];
  List<String> elementsEnterPatient = [
    'username',
    'firstname',
    'lastname',
    'email',
    'birthday',
    'sex',
    'fathername',
  ];

  List<String> elementsEnterDoctor = [
    'username',
    'firstname',
    'lastname',
    'email',
    'birthday',
    'sex',
    'fathername',
  ];

  String selectedCategory = '';

  List<String> listOfElements = [];

  final _formkey = GlobalKey<FormState>();

  Future<void> changeUser() async {
    changedData.removeWhere((key, value) => value == '');
    bool completed = await ApiDataProvider().changeUser(changedData);
    if (completed == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Пользователь изменен'),
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
        title: const Text('Редактировать'),
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
                                      initialValue: userData[listOfElements[i]],
                                      inputFormatters:
                                          listOfElements[i] == "birthday"
                                              ? [DateTextFormatter()]
                                              : [],
                                      onChanged: (value) {
                                        setState(() {
                                          changedData[listOfElements[i]] =
                                              value;
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
                                      'Сохранить',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    onPressed: () {
                                      changeUser();
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
