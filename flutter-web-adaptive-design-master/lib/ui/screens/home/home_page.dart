import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_doctors_admin.dart';
import 'package:adaptive_design/ui/screens/home/widgets/api_data_provider.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_main_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_modules_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_notification_page_patient.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_patient_last_records.dart';
import 'package:adaptive_design/ui/screens/home/widgets/doctor/desktop_patients_list_doctor.dart';
import 'package:adaptive_design/ui/screens/home/widgets/admin/desktop_user_registration.dart';
import 'package:adaptive_design/ui/screens/home/widgets/log_in_page.dart';
import 'package:adaptive_design/ui/screens/home/widgets/patient/desktop_statistics_patient.dart';
import 'package:adaptive_design/ui/widgets/adaptive_page_builder.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptivePageBuilder(builder: (context, type) {
      return Login();
    });
  }
}
