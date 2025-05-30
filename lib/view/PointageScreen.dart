import 'package:flutter/material.dart';
import '../controllers/pointage_controller.dart';
import '../models/pointage.dart';

class PointageView extends StatefulWidget {
  const PointageView({super.key});

  @override
  State<PointageView> createState() => _PointageViewState();
}

class _PointageViewState extends State<PointageView> {
  final PointageController controller = PointageController();
  late Future<List<Pointage>> pointages;

  final String idAgent = "5651"; 
  final String dateSelect = DateTime.now().toIso8601String().substring(0, 10); 

  @override
  void initState() {
    super.initState();
    pointages = controller.fetchPointages(idAgent, dateSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pointage"),
        backgroundColor: const Color.fromARGB(255, 213, 91, 9),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Pointage>>(
        future: pointages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun pointage pour aujourd'hui."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return ListTile(
                title: Text(p.time),
                subtitle: Text(p.location),
              );
            },
          );
        },
      ),
    );
  }
}
