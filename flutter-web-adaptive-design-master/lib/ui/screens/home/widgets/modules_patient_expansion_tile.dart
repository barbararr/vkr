import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/category_model.dart';
import 'package:adaptive_design/ui/common/models/gastro_label_model.dart';
import 'package:adaptive_design/ui/common/models/module_model.dart';
import 'package:adaptive_design/ui/common/models/parameter_model.dart';
import 'package:adaptive_design/ui/screens/home/widgets/food_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import 'api_data_provider.dart';

import '../../../common/globals.dart' as globals;

class ModulesPatientExpansionTile extends StatefulWidget {
  const ModulesPatientExpansionTile({Key? key}) : super(key: key);

  @override
  State<ModulesPatientExpansionTile> createState() =>
      _ModulesPatientExpansionTileState();
}

class _ModulesPatientExpansionTileState
    extends State<ModulesPatientExpansionTile> {
  List<Map<String, dynamic>> modulesToPrint = [];

  List<ModuleModel> modules = [];
  List<String> selectedValues = [];
  List<GastroLabelModel> lables = [];
  Map<String, List<String>> categories = {};
  List<String> selectedCategories = [];
  List<String> selectedCProducts = [];
  List<String> selectedWeights = [];

  void getModulesToPrint() {
    for (var i = 0; i < modules.length; i++) {
      modulesToPrint.add({
        "id": i,
        "name": "Модуль " + modules[i].name,
        "detail": "\nПараметры: " + modules[i].parametersToString()
      });
    }
  }

  void getLables(String id) async {
    lables = (await ApiDataProvider().getGastroLables(id));
    Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> sendModuleData(String moduleID, String datetime,
      List<ParameterModel> parameterList) async {
    String datetime = DateTime.now().toString().replaceAll(" ", "T");
    String json =
        "{ \"questionaryId\": \"$moduleID\", \"datetime\": \"$datetime\", \"fillIn\": [";
    for (var i = 0; i < parameterList.length; i++) {
      String value = parameterList[i].value;
      String id = parameterList[i].id;
      json +=
          "{\"value\": \"$value\", \"answerIdJpa\": {\"fillIn\" : \"\", \"parameterId\": \"$id\"}}";
      if (i != parameterList.length - 1) {
        json += ",";
      } else {
        json += "]}";
      }
    }
    print(json);

    if (!(await ApiDataProvider().sendModuleData(json))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  List<Widget> buildModuleInput(int index) {
    List<Widget> fields = [];
    List<Widget> row_widgets = [];
    Row row_food;
    if (modules[index].name == "Дневник питания") {
      globals.questtionaryID = modules[index].questionaryId;
      fields.add(Container(
        child: RaisedButton(
          child: const Text(
            'Добавить запись',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => (const DesktopFoodDiary())))
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: firstColor,
        ),
        width: MediaQuery.of(context).size.width / 5,
        height: 25,
      ));
    } else {
      for (var i = 0; i < modules[index].parameterList.length; i++) {
        ParameterModel current = modules[index].parameterList[i];
        String currentName = current.name;
        row_widgets = [];

        row_widgets.add(Text(
          "$currentName: ",
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ));
        if (current.dataType == "input") {
          row_widgets.add(Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 40,
            child: TextFormField(
              onChanged: (value) =>
                  modules[index].parameterList[i].value = value,
              cursorColor: secondColor,
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 16.0, color: secondColor),
                labelStyle: const TextStyle(fontSize: 16.0, color: secondColor),
                labelText: modules[index].parameterList[i].description,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: fourthColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor),
                    borderRadius: BorderRadius.all(Radius.circular(9.0))),
              ),
            ),
          ));
        }
        if (current.dataType == "switch") {
          modules[index].parameterList[i].value = "нет";
          row_widgets.add(StatefulBuilder(builder: (context, setState) {
            return Checkbox(
                value: modules[index].parameterList[i].isChecked,
                onChanged: (value) {
                  setState(() {
                    modules[index].parameterList[i].isChecked = value!;
                    if (modules[index].parameterList[i].isChecked) {
                      modules[index].parameterList[i].value = "есть";
                    } else {
                      modules[index].parameterList[i].value = "нет";
                    }
                  });
                });
          }));
        }
        if (current.dataType == "datalist" || current.dataType == "select") {
          row_widgets.add(Expanded(
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
        Row row = Row(
            mainAxisAlignment: MainAxisAlignment.start, children: row_widgets);
        fields.add(row);
        fields.add(const SizedBox(
          height: 10,
        ));
      }
      fields.add(const SizedBox(
        height: 10,
      ));
      fields.add(Container(
        child: RaisedButton(
          child: const Text(
            'Добавить запись',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () => {
            sendModuleData(modules[index].questionaryId,
                DateTime.now().toString(), modules[index].parameterList),
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(milliseconds: 600),
                content: Text('Запись добавлена')))
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: firstColor,
        ),
        width: MediaQuery.of(context).size.width / 5,
        height: 25,
      ));
    }
    return fields;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    modules = (await ApiDataProvider().getPatientModules(globals.user!.id));
    for (var i = 0; i < modules.length; i++) {
      if (modules[i].name != "Дневник питания") {
        for (var j = 0; j < modules[i].parameterList.length; j++) {
          if (modules[i].parameterList[j].dataType == "datalist" ||
              modules[i].parameterList[j].dataType == "select") {
            if (modules[i].parameterList[j].name == "Наименование смеси") {
              modules[i].parameterList[j].options =
                  (await ApiDataProvider().getFormula());
            } else {
              if (modules[i].parameterList[j].name == "Группа продуктов") {
                List<CategoryModel> cat =
                    (await ApiDataProvider().getCategories());
                List<String> catNames = [];
                for (var k = 0; k < cat.length; k++) {
                  catNames.add(cat[k].name);
                }
              }

              List<GastroLabelModel> lables = (await ApiDataProvider()
                  .getGastroLables(modules[i].parameterList[j].id));
              List<String> names = [];
              for (var i = 0; i < lables.length; i++) {
                names.add(lables[i].name);
              }
              modules[i].parameterList[j].options = names;
            }
          }
        }
      }
    }
    getModulesToPrint();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  int frequency = 0;

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
            children: buildModuleInput(item['id']),
          ),
        );
      },
    );
  }
}
