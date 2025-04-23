import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Onboarding.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/data_screen.dart';
import 'package:flutter_application_1/view/sim_view.dart'; // Assure-toi que ce fichier existe
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
        GetPage(name: '/salesScreen', page: () => const SimView ()), 
      ],
    );
  }
}
