import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_main_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_appbar.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../../../common/app_colors.dart';
import '../../../common/models/product_model.dart';
import 'api_data_provider.dart';
import '../../../common/globals.dart' as globals;

class DesktopFoodDiary extends StatefulWidget {
  const DesktopFoodDiary({Key? key}) : super(key: key);

  @override
  State<DesktopFoodDiary> createState() => _DesktopFoodDiaryState();
}

class _DesktopFoodDiaryState extends State<DesktopFoodDiary> {
  List<String> categories = ['к пациенту'];
  List<String> elementsEnterPatient = [
    'ФИО',
    'Дата рождения',
    'Пол',
    'Вес',
    'Рост'
  ];
  List<String> elementsEnterDoctor = ['Email', 'Password', 'Name'];
  String selectedCategory = '';
  List<String> listOfElements = [];

  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  var cards = <Card>[];

  List<String> foodNames = [];
  List<String> foodWeights = [];
  String foodNamesID = "89e20095-fd15-11ee-88dc-00f5f80cf8ae";
  String foodWeightsID = "7f1862d8-fe90-11ee-88dc-00f5f80cf8ae";
  List<List<String>> selected = [];
  List<String> options = [];
  int iter = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<ProductModel> cat = (await ApiDataProvider().getProducts());
    for (var k = 0; k < cat.length; k++) {
      options.add(cat[k].name);
    }
    for (var i = 0; i < 100; i++) {
      List<String> list = [];
      selected.add(list);
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  Future<void> sendModuleData(String moduleID, String datetime) async {
    String datetime = DateTime.now().toString().replaceAll(" ", "T");
    String json =
        "{\"questionaryId\": \"$moduleID\", \"datetime\": \"$datetime\", \"fillIn\": [";
    String value = foodNames.toString();
    json +=
        "{\"value\": \"$value\", \"answerIdJpa\": {\"fillIn\" : \"\", \"parameterId\": \"$foodNamesID\"}},";
    value = foodWeights.toString();
    json +=
        "{\"value\": \"$value\", \"answerIdJpa\": {\"fillIn\" : \"\", \"parameterId\": \"$foodWeightsID\"}}]}";
    print(json);
    if (!(await ApiDataProvider().sendModuleData(json))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Проверьте корректность введенных значений!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 600),
          content: Text('Запись добавлена')));
    }
  }

  Card createCard(int i) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Продукт ${cards.length + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text('Продукт:'),
              Flexible(
                fit: FlexFit.tight,
                child: DropDownMultiSelect(
                  options: options,
                  selectedValues: selected[i],
                  onChanged: (value) {
                    print('выбрано $value');
                    setState(() {
                      selected[i] = value;
                    });
                    foodNames.add(value
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''));
                  },
                  whenEmpty: 'Выберите',
                ),
              ),
              const SizedBox(
                width: 70,
              ),
              const Text('Вес:'),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 40,
                child: TextFormField(
                  onChanged: (value) =>
                      foodWeights[foodWeights.length - 1] = value,
                  cursorColor: secondColor,
                  decoration: const InputDecoration(
                    labelText: "г",
                    hintStyle: TextStyle(fontSize: 16.0, color: secondColor),
                    labelStyle: TextStyle(fontSize: 16.0, color: secondColor),
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
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PatientAppbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  child: RaisedButton.icon(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'на главную',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ((const DesktopMainPatientPagePatient())))),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: firstColor,
                  ),
                  width: MediaQuery.of(context).size.width / 5,
                  height: 25,
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  child: RaisedButton(
                    child: const Text(
                      'добавить запись',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () => {
                      sendModuleData(
                          globals.questtionaryID, DateTime.now().toString()),
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: firstColor,
                  ),
                  width: MediaQuery.of(context).size.width / 4,
                  height: 25,
                ),
              ]),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cards[index];
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton.icon(
                      icon: const Icon(
                        Icons.add_rounded,
                        color: firstColor,
                      ),
                      label: const Text('новый продукт'),
                      onPressed: () => {
                        setState(() => {
                              foodWeights.add(''),
                              cards.add(createCard(iter)),
                              iter++
                            })
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
