import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/SupervisorReportModel.dart';
import 'package:flutter_application_1/view/MonCompteScreen.dart';
import 'package:flutter_application_1/view/Onboarding.dart';
import 'package:flutter_application_1/view/agent_report_screen.dart';
import 'package:flutter_application_1/view/nouvelle_vente.dart';
import 'package:flutter_application_1/view/report_screen.dart';
import 'package:flutter_application_1/view/sim_view.dart';
import 'package:flutter_application_1/view/statique_screen.dart';
import 'package:flutter_application_1/view/unsentsalepage.dart';

import 'package:get/get.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/data_screen.dart';
// Assure-toi que ce fichier existe
 // Import the onboarding screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advasim Login',
      initialRoute: '/onboardingScreen', 
      getPages: [
        GetPage(name: '/onboardingScreen', page: () => const OnboardingScreen()),
        GetPage(name: '/loginScreen', page: () => const LoginScreen()),
        GetPage(name: '/dataScreen', page: () => const DataScreen(token: '')),
        GetPage(name: '/SimView', page: () => const SimView()),
 GetPage(name: '/StatsScreen', page: () => const StatsScreen(token: '', username: '',)),
  GetPage(name: '/ReportView', page: () => const SupervisorReportPage (token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ2NzI0MTYxLCJleHAiOjE3NDY3Mjc3NjEsImlhdCI6MTc0NjcyNDE2MSwiaXNzIjoiSXNzdW', from: '', to: '',)),
    GetPage(name: '/NouvelleVenteScreen', page: () => const NouvelleVenteScreen()),
          GetPage(name: '/MonCompteScreen', page: () => const MonCompteScreen()),
            GetPage(name: '/UnsentSalesPage', page: () => UnsentSalesPage()),
      ],
    );
  }
}
