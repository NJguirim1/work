import 'package:flutter/material.dart';
import '../controllers/portability_sim_controller.dart';
import '../models/portability_sim_model.dart';
import '../services/portability_sim_service.dart';

class PortabilitySimView extends StatefulWidget {
  final String token;
  const PortabilitySimView({required this.token, super.key});

  @override
  State<PortabilitySimView> createState() => _PortabilitySimViewState();
}

class _PortabilitySimViewState extends State<PortabilitySimView> {
  final _cinController = TextEditingController();
  final _iccIdController = TextEditingController();
  final _portabilityNumberController = TextEditingController();
  late PortabilitySimController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PortabilitySimController(
      PortabilitySimModel(cin: '', iccId: '', type: 1, portabilityNumber: ''),
      PortabilitySimService('https://your-api-base-url.com'), // Replace with actual URL
    );
  }

  Widget buildImagePicker(String label, Future<void> Function() onTap) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.orange),
          onPressed: () async {
            await onTap();
            setState(() {});
          },
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Vente - Portabilité'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 12),
            TextField(
              controller: _portabilityNumberController,
              decoration: const InputDecoration(
                labelText: 'Numéro Portabilité',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _controller.model.portabilityNumber = val,
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
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    buildImagePicker('CIN Recto', () => _controller.pickImage((img) => _controller.model.frontCinImage = img)),
                    buildImagePicker('CIN Verso', () => _controller.pickImage((img) => _controller.model.backCinImage = img)),
                    buildImagePicker('RIO & Signature 1', () => _controller.pickImage((img) => _controller.model.rioSignatureImage = img)),
                    buildImagePicker('RIO & Signature 2', () => _controller.pickImage((img) => _controller.model.rioSignatureImage2 = img)),
                    buildImagePicker('Numéro Portabilité', () => _controller.pickImage((img) => _controller.model.portabilityNumberImage = img)),
                    buildImagePicker('Contrat', () => _controller.pickImage((img) => _controller.model.contractImage = img)),
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
                  bool result = await _controller.submit(
                    token: widget.token,
                    sellPointId: '1',
                    latitude: '36.123',
                    longitude: '10.123',
                    city: 'Tunis',
                    country: 'Tunisie',
                    supervisorId: '42',
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result ? 'Vente soumise avec succès' : 'Échec de l’envoi'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Action bouton +')),
          );
        },
      ),
    );
  }
}
