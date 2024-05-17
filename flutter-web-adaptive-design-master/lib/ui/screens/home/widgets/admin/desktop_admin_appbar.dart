import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import '../log_in_page.dart';
import '../../../../common/globals.dart' as globals;
import 'desktop_doctors_admin.dart';
import 'desktop_patients_admin.dart';

class AdminAppbar extends StatefulWidget implements PreferredSizeWidget {
  const AdminAppbar({Key? key}) : super(key: key);

  @override
  State<AdminAppbar> createState() => _AdminAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _AdminAppbarState extends State<AdminAppbar> {
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
              'Пациенты',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (const DesktopPatientListPageAdmin())));
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
              'Доктора',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (const DesktopDoctorsListPageAdmin())));
            },
            color: thirdColor,
          ),
        ),
        const SizedBox(
          width: 12.0,
        ),
        const SizedBox(
          width: 12.0,
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
