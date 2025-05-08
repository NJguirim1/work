import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/SimController.dart';
import 'package:flutter_application_1/models/sim_model.dart';
import 'package:flutter_application_1/view/statique_screen.dart';
import 'package:get/get.dart';

class SimView extends StatefulWidget {
  @override
  _SimViewState createState() => _SimViewState();
}

class _SimViewState extends State<SimView> {
  final SimController simController = Get.put(SimController());
  int _selectedIndex = 1;

  Map<String, dynamic>? pointDeVente;
  Map<String, dynamic>? superviseur;

  bool isSupervisor = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null && args is Map) {
      pointDeVente = args['pointDeVente'] as Map<String, dynamic>?;
      superviseur = args['superviseur'] as Map<String, dynamic>?;

      print('Superviseur: $superviseur');

      if (superviseur != null) {
        print('Superviseur full object: $superviseur');
        String? typeText = superviseur?['TypeText'];
        print('TypeText: $typeText');

        if (typeText != null && typeText == "Superviseur terrain") {
          isSupervisor = true;
        } else {
          if (superviseur?['Name'] != null && superviseur?['Name']!.contains("SUPERVISEUR")) {
            isSupervisor = true;
          }
        }
      }

      print('Is Supervisor: $isSupervisor');
    }

    if (pointDeVente == null || superviseur == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Erreur", "Informations manquantes. Retour à l'écran précédent");
        Get.back();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.toNamed('/toSend');
        break;
      case 2:
        Get.toNamed('/newSale');
        break;
      case 3:
        Get.toNamed('/stock');
        break;
      case 4:
        Get.toNamed('/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pointDeVente == null || superviseur == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Des Ventes'),
        backgroundColor: Colors.orange,
        leading: isSupervisor
            ? IconButton(
                icon: Icon(Icons.report),
                onPressed: () {
                  Get.toNamed('/report');
                },
              )
            : null,
        actions: [
          if (isSupervisor)
        IconButton(
  icon: Icon(Icons.bar_chart),
  onPressed: () {
    final token = superviseur?['Token'] ?? '';
    final username = superviseur?['Username'] ?? '';
   Get.to(() => StatsScreen(
  token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ2NzI0MTYxLCJleHAiOjE3NDY3Mjc3NjEsImlhdCI6MTc0NjcyNDE2MSwiaXNzIjoiSXNzdW',
  username: 'noomana',
));
  },
),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Point de Vente: ${pointDeVente?['Name'] ?? "Inconnu"}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Superviseur: ${superviseur?['Name'] ?? "Inconnu"}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SimModel>>(
              future: simController.fetchSimData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucune vente trouvée.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final sim = snapshot.data![index];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Icon(Icons.sim_card, color: Colors.orange),
                        title: Text('CIN: ${sim.cinNumber}', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Icc-Id: ${sim.contratNumber}'),
                            Text('Traité par: ${sim.nameUserCentrale}'),
                            Text('Date Émission: ${sim.dateEmission}'),
                            Text('État: ${_getStateText(sim.state)}'),
                            Text('Téléphone: ${sim.telephoneNumber.isNotEmpty ? sim.telephoneNumber : "Non disponible"}'),
                          ],
                        ),
                        trailing: Icon(Icons.edit, size: 20),
                        onTap: () => _showEditDialog(sim),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'À envoyer'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Ventes'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Nouvelle'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
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

  void _showEditDialog(SimModel sim) {
    // Ajoute ici le code pour afficher un dialog d’édition si nécessaire
  }
}
