import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/SimController.dart';
import 'package:flutter_application_1/models/sim_model.dart';
import 'package:flutter_application_1/view/agent_report_screen.dart';
import 'package:flutter_application_1/view/report_screen.dart';
import 'package:flutter_application_1/view/statique_screen.dart';
import 'package:get/get.dart';

class SimView extends StatefulWidget {
  const SimView({super.key});

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

      if (superviseur != null) {
        String? typeText = superviseur?['TypeText'];
        if (typeText != null && typeText == "Superviseur terrain") {
          isSupervisor = true;
        } else {
          if (superviseur?['Name'] != null &&
              superviseur?['Name']!.contains("SUPERVISEUR")) {
            isSupervisor = true;
          }
        }
      }
    }

    if (pointDeVente == null || superviseur == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
            "Erreur", "Informations manquantes. Retour à l'écran précédent");
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
        Get.toNamed('/UnsentSalesPage');
        break;
      case 1:
        Get.toNamed('/SimView');
        break;
        case 2:
      Get.toNamed('/NouvelleVenteScreen');    // Nouvelle vente
      break;
    case 3:
      Get.toNamed('/MonCompteScreen');        // Compte
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
        title: const Text(' Liste Des Ventes'),
        backgroundColor: Colors.orange,
        leading: isSupervisor
            ? IconButton(
                icon: const Icon(Icons.report),
                onPressed: () {
                  final token = superviseur?['Token'] ?? '';
                  final from = DateTime.now().toIso8601String().split('T')[0];
                  final to = from;

                  Get.to(() => const SupervisorReportPage(
                        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzUwMDAxMzgzLCJleHAiOjE3NTAwMDQ5ODMsImlhdCI6MTc1MDAwMTM4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.EN6WkUzTCwC0avn1VWX9NbGvhsi34_u8MQD8WhgEt5c',
                        from: '',
                        to: '',
                      ), arguments: {
                    'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzUwMDAxMzgzLCJleHAiOjE3NTAwMDQ5ODMsImlhdCI6MTc1MDAwMTM4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.EN6WkUzTCwC0avn1VWX9NbGvhsi34_u8MQD8WhgEt5c',
                    'from': '',
                    'to': '',
                  });
                },
              )
            : null,
        actions: [
          if (isSupervisor)
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                final token = superviseur?['Token'] ?? '';
                final username = superviseur?['Username'] ?? '';
                Get.to(() => const StatsScreen(
                      token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzUwMDAxMzgzLCJleHAiOjE3NTAwMDQ5ODMsImlhdCI6MTc1MDAwMTM4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.EN6WkUzTCwC0avn1VWX9NbGvhsi34_u8MQD8WhgEt5c',
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
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Superviseur: ${superviseur?['Name'] ?? "Inconnu"}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SimModel>>(
              future: simController.fetchSimData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucune vente trouvée.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final sim = snapshot.data![index];

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading:
                            const Icon(Icons.sim_card, color: Colors.orange),
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
                                'Téléphone: ${sim.telephoneNumber!.isNotEmpty ? sim.telephoneNumber : "Non disponible"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditDialog(sim),
                        ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'À envoyer'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Ventes'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Nouvelle'),
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
    final cinController = TextEditingController(text: sim.cinNumber);
    final contratController = TextEditingController(text: sim.contratNumber);
    final telephoneController = TextEditingController(text: sim.telephoneNumber ?? '');
    final dateEmissionController = TextEditingController(text: sim.dateEmission ?? '');
    final nameUserCentraleController = TextEditingController(text: sim.nameUserCentrale ?? '');
    final _formKey = GlobalKey<FormState>();

    // Fix: ensure stateValue is one of the dropdown's allowed values (1,2,3) or default to 1
    int stateValue = [1, 2, 3].contains(sim.state) ? sim.state : 1;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Modifier la vente',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cinController,
                      decoration: const InputDecoration(labelText: 'Numéro CIN'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: contratController,
                      decoration: const InputDecoration(labelText: 'Numéro Contrat'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Champ requis' : null,
                    ),
                    TextFormField(
                      controller: telephoneController,
                      decoration: const InputDecoration(labelText: 'Numéro Téléphone'),
                    ),
                    TextFormField(
                      controller: dateEmissionController,
                      decoration: const InputDecoration(labelText: 'Date Émission'),
                    ),
                    TextFormField(
                      controller: nameUserCentraleController,
                      decoration: const InputDecoration(labelText: 'Nom Utilisateur Centrale'),
                    ),
                    DropdownButtonFormField<int>(
                      value: stateValue,
                      decoration: const InputDecoration(labelText: 'État'),
                      items: const [
                        DropdownMenuItem(child: Text('En attente'), value: 1),
                        DropdownMenuItem(child: Text('Validée'), value: 2),
                        DropdownMenuItem(child: Text('Rejetée'), value: 3),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            stateValue = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // fermer le bottom sheet
                          },
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              SimModel updatedSim = SimModel(
                                sellId: sim.sellId,
                                type: sim.type,
                                cinNumber: cinController.text,
                                contratNumber: contratController.text,
                                telephoneNumber: telephoneController.text,
                                dateEmission: dateEmissionController.text,
                                pvName: sim.pvName,
                                nameUserCentrale: nameUserCentraleController.text,
                                pvId: sim.pvId,
                                state: stateValue,
                                latitude: sim.latitude,
                                longitude: sim.longitude,
                                city: sim.city,
                                country: sim.country,
                                passportNumber: sim.passportNumber,
                                frontCinImage: sim.frontCinImage,
                                backCinImage: sim.backCinImage,
                                contractImage: sim.contractImage,
                                portFrontCinImage: sim.portFrontCinImage,
                                portBackCinImage: sim.portBackCinImage,
                                rioSignatureImage: sim.rioSignatureImage,
                                rioSignatureImage2: sim.rioSignatureImage2,
                                portNumberImage: sim.portNumberImage,
                                portContractImage: sim.portContractImage,
                                foreignPassportImage1: sim.foreignPassportImage1,
                                foreignPassportImage2: sim.foreignPassportImage2,
                                foreignContractImage: sim.foreignContractImage,
                                airportCinFront: sim.airportCinFront,
                                airportCinBack: sim.airportCinBack,
                              );

                              try {
                                await simController.updateSim(updatedSim);
                                Get.back();
                                Get.snackbar(
                                  'Succès',
                                  'Vente modifiée avec succès',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                                setState(() {}); // Refresh the list in the view
                              } catch (e) {
                                Get.snackbar(
                                  'Erreur',
                                  'Échec de la modification: $e',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          child: const Text('Enregistrer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}  