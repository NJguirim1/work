import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/view/PointageScreen.dart';
 // ✅ Adjust this if needed

class MonCompteScreen extends StatelessWidget {
  const MonCompteScreen({super.key});

  // Logout method to clear session and redirect
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved session or user data

    // Redirect to onboarding and remove all previous screens
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Compte"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 213, 91, 9),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "Agent terrain",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 5),
              const Text("P.V: Espace corniche"),
              const Text("Responsable: 00310: ABDOULI NOOMAN"),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PointageView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 91, 9),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("POINTAGE"),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 91, 9),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "SE DÉCONNECTER",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text("v 1.2.8", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
