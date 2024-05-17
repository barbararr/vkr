import 'package:adaptive_design/ui/common/models/module_model.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../api_data_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/globals.dart' as globals;
import 'desktop_doctor_last_recomendations.dart';
import 'desktop_doctor_recomendation.dart';
import 'desktop_existing_modules.dart';
import 'desktop_last_records_doctor.dart';
import 'desktop_modules_doctor.dart';
import 'desktop_patient_doctor.dart';

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class DesktopStatisticsDoctorPagePatient extends StatefulWidget {
  const DesktopStatisticsDoctorPagePatient({Key? key}) : super(key: key);

  @override
  State<DesktopStatisticsDoctorPagePatient> createState() =>
      _DesktopStatisticsDoctorPagePatientState();
}

class _DesktopStatisticsDoctorPagePatientState
    extends State<DesktopStatisticsDoctorPagePatient> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Рекомендации',
    'Назначенные модули',
    'Назначить модуль',
    'Дать рекомендацию',
  ];

  Map<String, String> patientData = {};

  List<String> elementsEnterDoctor = ['Email', 'Password', 'Name'];
  String selectedCategory = '';
  List<String> listOfElements = [];

  Map<String, String>? getPatientData() {
    return globals.user?.getData();
  }

  List<TextSpan> createListText() {
    patientData = getPatientData()!;
    List<TextSpan> list = [];
    for (var v in patientData.keys) {
      list.add(TextSpan(
          text: v + ':', style: const TextStyle(fontWeight: FontWeight.bold)));
      list.add(const TextSpan(text: " "));
      list.add(TextSpan(text: patientData[v]));
      list.add(const TextSpan(text: "\n\n"));
    }
    return list;
  }

  TextSpan patientDataToString() {
    var text = TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: createListText());
    print(text);
    return text;
  }

  List<Widget> getChoiceChips() {
    return categories
        .map(
          (category) => ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedCategory = category;
                  } else {
                    selectedCategory = '';
                  }
                  if (selectedCategory == 'Назначить модуль') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopModulesPageDoctor())));
                  }
                  if (selectedCategory == 'Данные') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopMainPatientPageDoctor())));
                  }
                  if (selectedCategory == 'Последние записи') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopPatientLastRecordsPageDoctor())));
                  }
                  if (selectedCategory == 'Дать рекомендацию') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopRecomendationPageDoctor())));
                  }
                  if (selectedCategory == 'Статистика') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopStatisticsDoctorPagePatient())));
                  }
                  if (selectedCategory == 'Рекомендации') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopLastRecomendationsPageDoctor())));
                  }
                  if (selectedCategory == 'Назначенные модули') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopExistingModulesPageDoctor())));
                  }
                });
              }),
        )
        .toList();
  }

  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    data = (await ApiDataProvider().getStatisctics(
        "a76d9dc1-de4f-11ee-8c0c-00f5f80cf8ae", globals.currentPatientID));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  List<SfCartesianChart> createChartData() {
    List<SfCartesianChart> graphs = [];
    Map<String, String> dots = {};
    print(data.keys);
    for (var elem in data.keys) {
      List<ChartData> chartData = [];
      for (var it in data[elem]!.keys) {
        chartData
            .add(ChartData(DateTime.parse(it), double.parse(data[elem]![it]!)));
        print(DateTime.parse(it).toString() +
            " " +
            double.parse(data[elem]![it]!).toString());
      }
      print(elem);
      graphs.add(SfCartesianChart(
          palette: const [secondColor],
          title: ChartTitle(text: elem),
          primaryXAxis: DateTimeAxis(),
          series: <CartesianSeries<ChartData, DateTime>>[
            LineSeries<ChartData, DateTime>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y)
          ]));
    }
    return graphs;
  }

  Map userData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DoctorAppbar(),
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
                children: getChoiceChips()),
            Flexible(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: createChartData(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
