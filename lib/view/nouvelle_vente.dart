import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/vente_view.dart'; 

class NouvelleVenteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: NouvelleVente(),
    );
  }
}

class NouvelleVente extends StatelessWidget {
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjEwMDciLCJOYW1lIjoidGVycmFpbiogdGVycmFpbiIsIlVzZXJuYW1lIjoidGVycmFpbiIsIlR5cGUiOiJGaWVsZEFnZW50IiwibmJmIjoxNzM5OTAzNDgzLCJleHAiOjE3Mzk5MDcwODMsImlhdCI6MTczOTkwMzQ4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.6GwWfbQRThy0b2qMeri_3bZBj31la-Ag2mFJB-Vz6Hg'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Vente'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choisis un type de vente',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildButton(
              context,
              label: 'STANDARD',
              icon: Icons.confirmation_number,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VenteView(token: token),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              context,
              label: 'AÉROPORT',
              icon: Icons.airplanemode_active,
              onTap: () {
                // Ajoute ta navigation ici si nécessaire
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
