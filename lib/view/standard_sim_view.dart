import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/AirportSimView.dart';
import 'package:flutter_application_1/view/foreign_sale_view.dart';
import '../controllers/standard_sim_controller.dart';
import '../models/standard_sim_model.dart';
import 'portability_sim_view.dart';


class StandardSimView extends StatefulWidget {
  final String token;
  const StandardSimView({required this.token, Key? key}) : super(key: key);

  @override
  State<StandardSimView> createState() => _StandardSimViewState();
}

class _StandardSimViewState extends State<StandardSimView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      if (_tabController.index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PortabilitySimView(token: widget.token),
          ),
        );
        _tabController.index = 0;
      } else if (_tabController.index == 2) {
       Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => PortabilitySimView(token: widget.token), 
  ),
);

        _tabController.index = 0;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Vente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Standard'),
            Tab(text: 'Portabilité'),
            Tab(text: 'Étranger'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StandardTabContent(token: widget.token),
          Container(),
          Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AirportSimView(token: widget.token),
            ),
          );
        },
      ),
    );
  }
}

class _StandardTabContent extends StatefulWidget {
  final String token;
  const _StandardTabContent({required this.token, Key? key}) : super(key: key);

  @override
  State<_StandardTabContent> createState() => _StandardTabContentState();
}

class _StandardTabContentState extends State<_StandardTabContent> {
  final _cinController = TextEditingController();
  final _iccIdController = TextEditingController();
  late StandardSimController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StandardSimController(
      StandardSimModel(cin: '', iccId: '', type: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations Client',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cinController,
            decoration: const InputDecoration(
              labelText: 'CIN',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.cin = val,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _iccIdController,
            decoration: const InputDecoration(
              labelText: 'ICC ID',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _controller.model.iccId = val,
          ),
          const SizedBox(height: 20),
          const Text(
            'Photos requises',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.orange),
                        onPressed: () async {
                          await _controller.pickImageFront();
                          setState(() {});
                        },
                      ),
                      const Text('CIN Recto', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.orange),
                        onPressed: () async {
                          await _controller.pickImageBack();
                          setState(() {});
                        },
                      ),
                      const Text('CIN Verso', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.description, color: Colors.orange),
                        onPressed: () async {
                          await _controller.pickContractImage();
                          setState(() {});
                        },
                      ),
                      const Text('Contrat', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              label: const Text(
                'ENVOYER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                bool result = await _controller.submitStandardSim(widget.token);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result ? 'Vente soumise avec succès' : 'Échec de l’envoi')),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
