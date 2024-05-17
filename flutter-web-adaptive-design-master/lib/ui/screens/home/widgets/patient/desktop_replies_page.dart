import 'package:adaptive_design/ui/common/app_colors.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_appbar.dart';
import 'package:adaptive_design/ui/screens/home/widgets/replies_expansion_tile.dart';
import 'package:flutter/material.dart';

class DesktopRepliesPage extends StatelessWidget {
  const DesktopRepliesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PatientAppbar(),
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
                      'Рекомендации',
                      style: TextStyle(color: firstColor, fontSize: 22),
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 30,
                  ),
                ),
              ],
            ),
            const ReplyExpansionTile()
          ],
        ),
      ),
    );
  }
}
