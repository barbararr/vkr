import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_doctor_appbar.dart';
import 'package:flutter/material.dart';

import '../../../../common/models/notification_model.dart';
import '../api_data_provider.dart';

import '../../../../common/globals.dart' as globals;

class DesktopNotificationPageDoctor extends StatefulWidget {
  const DesktopNotificationPageDoctor({Key? key}) : super(key: key);

  @override
  State<DesktopNotificationPageDoctor> createState() =>
      _DesktopNotificationPageDoctorState();
}

class _DesktopNotificationPageDoctorState
    extends State<DesktopNotificationPageDoctor> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    notifications = await ApiDataProvider().getNotifications(globals.user!.id);

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  String getNotificationText(int index) {
    return notifications[index].datetime.replaceAll('T', ' ') +
        "\n" +
        notifications[index].text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DoctorAppbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    child: const Text(
                      'Уведомления',
                      style: TextStyle(color: firstColor, fontSize: 22),
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 30,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (ctx, index) {
                return Row(children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        child: Card(
                          child: Center(
                            child: Text(getNotificationText(index),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                                textAlign: TextAlign.justify),
                          ),
                        ),
                      ),
                    ),
                  )
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
