import 'package:flutter/material.dart';

class ForeignSaleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vente SIM Étranger"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "ICC ID *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Numéro de passeport (optionnel)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Card(
                color: Colors.grey[200],
                child: Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50),
                      SizedBox(height: 10),
                      Text("Photo Passeport"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.grey[200],
                child: Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50),
                      SizedBox(height: 10),
                      Text("Photo Contrat"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Push the button to the bottom of scroll view
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  print("Soumettre");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Soumettre la vente",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 24), // Space after button
            ],
          ),
        ),
      ),
    );
  }
}
