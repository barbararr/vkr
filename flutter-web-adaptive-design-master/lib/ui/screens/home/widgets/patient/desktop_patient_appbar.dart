import 'package:adaptive_design/ui/screens/home/widgets/desktop_change_info_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_main_patient.dart';
import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import 'desktop_notification_page_patient.dart';
import 'desktop_replies_page.dart';
import '../log_in_page.dart';
import '../../../../common/globals.dart' as globals;

class PatientAppbar extends StatefulWidget implements PreferredSizeWidget {
  const PatientAppbar({Key? key}) : super(key: key);

  @override
  State<PatientAppbar> createState() => _PatientAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _PatientAppbarState extends State<PatientAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: firstColor,
      title: const Text(
        "BlueFig",
        style: TextStyle(color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: MaterialButton(
            child: const Text(
              'Данные',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      (const DesktopMainPatientPagePatient())));
            },
            color: thirdColor,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: MaterialButton(
            child: const Text(
              'Уведомления',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      (const DesktopNotificationPagePatient())));
            },
            color: thirdColor,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: MaterialButton(
            child: const Text(
              'Рекомендации',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (const DesktopRepliesPage())));
            },
            color: thirdColor,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 5.0, 10.0),
          child: MaterialButton(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => (const UserChangingUser())));
              },
              icon: const Icon(Icons.account_circle),
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          child: MaterialButton(
            child: IconButton(
              onPressed: () {
                globals.logedIn = false;
                globals.user = null;
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => (const Login())));
              },
              icon: const Icon(Icons.logout_rounded),
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
