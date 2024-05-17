import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/common/models/module_with_parameters.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;
import 'api_data_provider.dart';

class LastRecordsExpansionTile extends StatefulWidget {
  const LastRecordsExpansionTile({Key? key}) : super(key: key);

  @override
  State<LastRecordsExpansionTile> createState() =>
      _LastRecordsExpansionTileState();
}

class _LastRecordsExpansionTileState extends State<LastRecordsExpansionTile> {
  List<ModuleWithParametersModel> modules = [];
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _getData();
    print(modules.length.toString() + "u");
  }

  void _getData() async {
    if (globals.user!.roleId == globals.patientRoleId) {
      modules = await ApiDataProvider().getLastRecordsPatient(globals.user!.id);
    } else {
      modules = await ApiDataProvider()
          .getLastRecordsPatient(globals.currentPatientID);
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    print(modules.length.toString() + "pop");
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < modules.length; i++) {
      String parameters = "";
      for (var j = 0; j < modules[i].parameterList.length; j++) {
        parameters += modules[i].parameterList[j].name +
            ": " +
            modules[i].parameterList[j].value +
            "\n";
      }
      Map<String, dynamic> recordString = {};
      recordString.addAll({
        "id": modules[i].dateTime + " " + modules[i].name,
        "name": "Запись " +
            modules[i].dateTime.replaceAll('T', ' ') +
            " " +
            modules[i].name,
        "detail": "Параметры: \n" + parameters
      });
      records.add(recordString);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: records.length,
      itemBuilder: (_, index) {
        final item = records[index];
        return Card(
          key: PageStorageKey(item['id']),
          child: ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            childrenPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            expandedCrossAxisAlignment: CrossAxisAlignment.end,
            maintainState: true,
            title: Text(item['name']),
            collapsedBackgroundColor: (modules[index].isRed &&
                    globals.user!.roleId == globals.doctorRoleId)
                ? const Color.fromRGBO(247, 156, 159, 100)
                : null,
            textColor: firstColor,
            iconColor: firstColor,
            backgroundColor: (modules[index].isRed &&
                    globals.user!.roleId == globals.doctorRoleId)
                ? const Color.fromRGBO(247, 156, 159, 100)
                : null,
            children: [
              ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.comment),
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.018),
                    foregroundColor: firstColor,
                  ),
                  title: Text(item['detail'])),
            ],
          ),
        );
      },
    );
  }
}
