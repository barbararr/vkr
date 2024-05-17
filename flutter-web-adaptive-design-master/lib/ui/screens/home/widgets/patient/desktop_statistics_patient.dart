import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_main_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_modules_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_last_records.dart';
import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../api_data_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/globals.dart' as globals;

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class DesktopStatisticsPatientPagePatient extends StatefulWidget {
  const DesktopStatisticsPatientPagePatient({Key? key}) : super(key: key);

  @override
  State<DesktopStatisticsPatientPagePatient> createState() =>
      _DesktopStatisticsPatientPagePatientState();
}

class _DesktopStatisticsPatientPagePatientState
    extends State<DesktopStatisticsPatientPagePatient> {
  List<String> categories = [
    'Данные',
    'Статистика',
    'Последние записи',
    'Добавить запись'
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
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
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
                  if (selectedCategory == 'Данные') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopMainPatientPagePatient())));
                  }
                  if (selectedCategory == 'Последние записи') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopPatientLastRecordsPagePatient())));
                  }
                  if (selectedCategory == 'Добавить запись') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopModulesPagePatient())));
                  }
                  if (selectedCategory == 'Статистика') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            (const DesktopStatisticsPatientPagePatient())));
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
        "a76d9dc1-de4f-11ee-8c0c-00f5f80cf8ae", globals.user!.id));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  List<SfCartesianChart> createChartData() {
    List<SfCartesianChart> graphs = [];
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
            // Renders line chart
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
      appBar: const PatientAppbar(),
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
