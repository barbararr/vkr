import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/module_model.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_existing_modules.dart';
import 'package:flutter/material.dart';
import 'api_data_provider.dart';

import '../../../common/globals.dart' as globals;

class ExistingModulesExpansionTile extends StatefulWidget {
  const ExistingModulesExpansionTile({Key? key}) : super(key: key);

  @override
  State<ExistingModulesExpansionTile> createState() =>
      _ExistingModulesExpansionTileState();
}

class _ExistingModulesExpansionTileState
    extends State<ExistingModulesExpansionTile> {
  List<Map<String, dynamic>> modulesToPrint = [];
  List<ModuleModel> modules = [];

  void deleteModule(int id) async {
    if (!(await ApiDataProvider()
        .deleteQuestionary(modules[id].questionaryId))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Модуль удалён')));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DesktopExistingModulesPageDoctor(),
          transitionDuration: const Duration(milliseconds: 100),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  void changeModule(int id, String frequency) async {
    if (!(await ApiDataProvider()
        .changeQuestionary(modules[id].questionaryId, frequency))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Модуль изменен')));
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                const DesktopExistingModulesPageDoctor(),
            transitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ));
    }
  }

  void getModulesToPrint() {
    for (var i = 0; i < modules.length; i++) {
      modulesToPrint.add({
        "id": i,
        "name": "Модуль " + modules[i].name,
        "detail": "\nПараметры: " +
            modules[i].parametersToString() +
            "\nЧастота: " +
            modules[i].frequency.toString() +
            " дней",
      });
    }
  }

  List<Widget> buildModuleInput(int index, Map<String, dynamic> item) {
    List<Widget> fields = [];
    fields.add(ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.extension),
          backgroundColor: Colors.white,
          foregroundColor: firstColor,
        ),
        title: Text(item['detail'])));

    fields.add(const SizedBox(
      height: 10,
    ));
    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Частота: ",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 6,
          height: 30,
          child: TextFormField(
            onChanged: (value) => frequency = value,
            cursorColor: secondColor,
            decoration: const InputDecoration(
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
        const Text(
          " дней",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ],
    ));
    fields.add(const SizedBox(height: 10));
    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: RaisedButton(
            child: const Text(
              'Изменить',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () => changeModule(item['id'], frequency),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: firstColor,
          ),
          width: MediaQuery.of(context).size.width / 5,
          height: 25,
        ),
        Container(
          child: RaisedButton(
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () => deleteModule(item['id']),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: firstColor,
          ),
          width: MediaQuery.of(context).size.width / 5,
          height: 25,
        ),
      ],
    ));
    return fields;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    modules = (await ApiDataProvider()
        .getExistingModules(globals.currentPatientID, globals.user!.id));
    getModulesToPrint();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  String frequency = "";

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: modulesToPrint.length,
      itemBuilder: (_, index) {
        final item = modulesToPrint[index];
        return Card(
          key: PageStorageKey(item['id']),
          child: ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              childrenPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              maintainState: true,
              title: Text(item['name']),
              textColor: firstColor,
              iconColor: firstColor,
              children: buildModuleInput(item['id'], item)),
        );
      },
    );
  }
}
