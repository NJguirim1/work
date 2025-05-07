import 'package:flutter/material.dart';

class AjouterSimScreen extends StatelessWidget {
  const AjouterSimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une SIM Aéroport'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the screen to add SIM Aéroport Étranger
                print('Naviguer vers SIM Aéroport Étranger (Passeport)');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('SIM Aéroport Étranger (Passeport)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the screen to add SIM Aéroport Standard
                print('Naviguer vers SIM Aéroport Standard (CIN)');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('SIM Aéroport Standard (CIN)'),
            ),
          ],
        ),
      ),
    );
  }
}
