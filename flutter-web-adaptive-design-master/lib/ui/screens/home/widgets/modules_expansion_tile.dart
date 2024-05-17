import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/doctor_parameter_model.dart';
import 'package:adaptive_design/ui/common/models/module_model.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../../../common/models/doctor_parameter_label_model.dart';
import 'api_data_provider.dart';

import '../../../common/globals.dart' as globals;

class ModulesExpansionTile extends StatefulWidget {
  const ModulesExpansionTile({Key? key}) : super(key: key);

  @override
  State<ModulesExpansionTile> createState() => _ModulesExpansionTileState();
}

class _ModulesExpansionTileState extends State<ModulesExpansionTile> {
  // Generate a list of Users, You often use API or database for creation of this list
  List<Map<String, dynamic>> modulesToPrint = [];
  /*List.generate(
          5,
          (index) => {
                "id": index,
                "name": "Модуль $index",
                "detail": "Модуль $index. \nПараметры: ..."
              });*/

  List<ModuleModel> modules = [];

  void addModule(int id) async {
    String json = "[";

    for (var i = 0; i < modules[id].doctorParameterList.length; i++) {
      String value = modules[id].doctorParameterList[i].value;
      String paramId = modules[id].doctorParameterList[i].id;
      json += "{\"parameterId\": \"$paramId\", \"value\": \"$value\"}";
      if (i != modules[id].doctorParameterList.length - 1) {
        json += ",";
      } else {
        json += "]";
      }
    }
    print(json);

    if (!(await ApiDataProvider().giveModuleToPatient(globals.currentPatientID,
        globals.user!.id, modules[id].id, frequency, json))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Модуль назначен')));
    }
  }

  void getModulesToPrint() {
    for (var i = 0; i < modules.length; i++) {
      modulesToPrint.add({
        "id": i,
        "name": "Модуль " + modules[i].name,
        "detail": "\nПараметры: " + modules[i].parametersToString()
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

    for (var i = 0; i < modules[index].doctorParameterList.length; i++) {
      DoctorParameterModel current = modules[index].doctorParameterList[i];
      String currentName = current.name;
      List<Widget> rowWidgets = [];

      rowWidgets.add(Text(
        "$currentName: ",
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ));

      if (current.dataType == "input") {
        rowWidgets.add(Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 40,
          child: TextFormField(
            onChanged: (value) =>
                modules[index].doctorParameterList[i].value = value,
            cursorColor: secondColor,
            decoration: const InputDecoration(
              labelStyle: TextStyle(fontSize: 16.0, color: secondColor),
              hintStyle: TextStyle(fontSize: 16.0, color: secondColor),
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
        ));
      }
      if (current.dataType == "switch") {
        modules[index].doctorParameterList[i].value = "нет";
        rowWidgets.add(StatefulBuilder(builder: (context, setState) {
          return Checkbox(
              value: modules[index].doctorParameterList[i].isChecked,
              onChanged: (value) {
                setState(() {
                  modules[index].doctorParameterList[i].isChecked = value!;
                  if (modules[index].doctorParameterList[i].isChecked) {
                    modules[index].doctorParameterList[i].value = "есть";
                  } else {
                    modules[index].doctorParameterList[i].value = "нет";
                  }
                });
              });
        }));
      }
      if (current.dataType == "datalist" || current.dataType == "select") {
        rowWidgets.add(Expanded(
          child: DropDownMultiSelect(
            options: current.options,
            selectedValues: current.selectedOptions,
            onChanged: (value) {
              print('выбрано $value');
              setState(() {
                current.selectedOptions = value;
              });
              current.value = current.selectedOptions.toString();
            },
            whenEmpty: 'Выберите',
          ),
        ));
      }
      Row row =
          Row(mainAxisAlignment: MainAxisAlignment.start, children: rowWidgets);
      fields.add(row);
      fields.add(const SizedBox(
        height: 10,
      ));
    }
    fields.add(const SizedBox(
      height: 10,
    ));
    fields.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
        const Spacer(),
        Container(
          child: RaisedButton(
            child: const Text(
              'Добавить модуль',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () => addModule(item['id']),
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
    modules = (await ApiDataProvider().getAllModules());

    for (var i = 0; i < modules.length; i++) {
      modules[i].doctorParameterList =
          await ApiDataProvider().getDoctorParameters(modules[i].id);
      for (var j = 0; j < modules[i].doctorParameterList.length; j++) {
        if (modules[i].doctorParameterList[j].dataType == "datalist" ||
            modules[i].doctorParameterList[j].dataType == "select") {
          List<DoctorParameterLabelModel> lables = (await ApiDataProvider()
              .getDoctorParametersLabels(modules[i].doctorParameterList[j].id));
          List<String> names = [];
          for (var l = 0; l < lables.length; l++) {
            names.add(lables[l].name);
          }
          modules[i].doctorParameterList[j].options = names;
        }
      }
    }
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
