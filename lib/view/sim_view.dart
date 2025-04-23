import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/SimController.dart';
import 'package:flutter_application_1/models/sim_model.dart';
import 'package:flutter_application_1/view/Report_screen.dart';
import 'package:flutter_application_1/view/statique_screen.dart';
import 'package:flutter_application_1/view/nouvelle_vente.dart'; // Add this import

import 'package:get/get.dart';

class SimView extends StatefulWidget {
  const SimView({super.key});

  @override
  _SimViewState createState() => _SimViewState();
}

class _SimViewState extends State<SimView> {
  final SimController simController = Get.put(SimController());
  int _selectedIndex = 1;

  final String username = 'terrain';
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjEwMDciLCJOYW1lIjoidGVycmFpbiogdGVycmFpbiIsIlVzZXJuYW1lIjoidGVycmFpbiIsIlR5cGUiOiJGaWVsZEFnZW50IiwibmJmIjoxNzM5OTAzNDgzLCJleHAiOjE3Mzk5MDcwODMsImlhdCI6MTczOTkwMzQ4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.6GwWfbQRThy0b2qMeri_3bZBj31la-Ag2mFJB-Vz6Hg';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.toNamed('/toSend');
        break;
      case 1:
        break;
      case 2:
        Get.to(() => NouvelleVente());
        break;
      case 3:
        Get.toNamed('/stock');
        break;
      case 4:
        Get.toNamed('/account');
        break;
    }
  }

  void _showEditModal(BuildContext context, SimModel sim) {
    TextEditingController phoneController =
        TextEditingController(text: sim.telephoneNumber);
    TextEditingController cinController =
        TextEditingController(text: sim.cinNumber);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Modifier la vente",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Téléphone"),
                ),
                TextField(
                  controller: cinController,
                  decoration: const InputDecoration(labelText: "CIN"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Call API to update sale (to be implemented)
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur: $e')));
                    }
                  },
                  child: const Text("Enregistrer"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 212, 99, 97),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.show_chart, color: Colors.white),
          onPressed: () {
            Get.to(() => ReportScreen(
                  token: token,
                  from: '',
                  to: '',
                ));
          },
        ),
        title: const Text(
          'Ventes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline, color: Colors.white),
            tooltip: 'Statistiques',
            onPressed: () {
              Get.to(() => StatsScreen(
                    username: username,
                    token: token,
                  ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SimModel>>(
        future: simController.fetchSimData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Erreur de chargement des ventes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune vente trouvée.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final sim = snapshot.data![index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.sim_card, color: Colors.orange),
                  title: Text('CIN: ${sim.cinNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Icc-Id: ${sim.contratNumber}'),
                      Text('Traité par: ${sim.nameUserCentrale}'),
                      Text('Date Émission: ${sim.dateEmission}'),
                      Text('État: ${_getStateText(sim.state)}'),
                      Text(
                          'Téléphone: ${sim.telephoneNumber.isNotEmpty ? sim.telephoneNumber : "Non disponible"}'),
                    ],
                  ),
                  trailing:
                      const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onTap: () {
                    _showEditModal(context, sim);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'À envoyer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Ventes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nouvelle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
      ),
    );
  }

  String _getStateText(int state) {
    switch (state) {
      case 1:
        return "En attente";
      case 2:
        return "Validée";
      case 3:
        return "Rejetée";
      default:
        return "Inconnu";
    }
  }
}
