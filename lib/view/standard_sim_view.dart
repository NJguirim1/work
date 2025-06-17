// 🟦 Same imports
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/standard_sim_controller.dart';
import 'package:flutter_application_1/view/EtrangerSimScreen%20.dart';
import 'package:flutter_application_1/view/portabilite_sim_screen.dart';
import 'package:flutter_application_1/view/unsentsalepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameMagnetPage extends StatelessWidget {
  const GameMagnetPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Game Magnet')),
        body: const Center(child: Text('Bienvenue dans le mini‑jeu !')),
      );
}

class StandardSimPage extends StatefulWidget {
  @override
  _StandardSimPageState createState() => _StandardSimPageState();
}

class _StandardSimPageState extends State<StandardSimPage>
    with SingleTickerProviderStateMixin {
  final StandardSimController controller = StandardSimController();

  String iccid = '';
  final TextEditingController cinController = TextEditingController();

  File? frontCinImage;
  File? backCinImage;
  File? contractImage;

  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzUwMDAxMzgzLCJleHAiOjE3NTAwMDQ5ODMsImlhdCI6MTc1MDAwMTM4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.EN6WkUzTCwC0avn1VWX9NbGvhsi34_u8MQD8WhgEt5c';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PortabilitySimSaleView(token: token),
              ),
            ).then((_) => _tabController.index = 0);
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ForeignSimSaleView(token: token),
              ),
            ).then((_) => _tabController.index = 0);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cinController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveUnsentSale() async {
    if (frontCinImage == null || backCinImage == null || contractImage == null) return;

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unsent_sales') ?? [];

    final saleMap = {
      'iccid': iccid,
      'cin': cinController.text,
      'frontCinImagePath': frontCinImage!.path,
      'backCinImagePath': backCinImage!.path,
      'contractImagePath': contractImage!.path,
    };

    list.add(jsonEncode(saleMap));
    await prefs.setStringList('unsent_sales', list);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vente enregistrée dans « À envoyer »')),
    );
  }

  void _askSaveDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connexion introuvable'),
        content: const Text('La vente n’a pas pu être envoyée. Voulez-vous l’enregistrer localement ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Non')),
          TextButton(onPressed: () async {
            Navigator.pop(context);
            await _saveUnsentSale();
          }, child: const Text('Oui')),
        ],
      ),
    );
  }

  Future<void> _scanIccid() async {
    final res = await BarcodeScanner.scan();
    if (res.type == ResultType.Barcode) {
      setState(() => iccid = res.rawContent);
    }
  }

  Future<void> _takePhoto(int idx) async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (file == null) return;
    setState(() {
      if (idx == 1) frontCinImage = File(file.path);
      if (idx == 2) backCinImage = File(file.path);
      if (idx == 3) contractImage = File(file.path);
    });
  }

  Future<void> _submit() async {
    if (iccid.isEmpty || cinController.text.isEmpty || frontCinImage == null || backCinImage == null || contractImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs et prendre les photos')),
      );
      return;
    }

    try {
      final r = await controller.submitStandardSim(
        token: token,
        iccid: iccid,
        cin: cinController.text,
        frontCinImage: frontCinImage!,
        backCinImage: backCinImage!,
        contractImage: contractImage!,
      );

      if (r.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Soumission réussie')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur serveur : ${r.statusCode}')));
      }
    } catch (_) {
      _askSaveDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion SIM'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Standard'),
            Tab(text: 'Portabilité'),
            Tab(text: 'Étranger'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'gameMagnet',
        icon: const Icon(Icons.sports_esports),
        label: const Text('Game Magnet'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GameMagnetPage()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scanner ICCID'),
                  onPressed: _scanIccid,
                ),
                const SizedBox(height: 12),
                Text('ICCID scanné : $iccid', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                TextField(
                  controller: cinController,
                  decoration: InputDecoration(
                    labelText: 'Numéro CIN',
                    prefixIcon: const Icon(Icons.credit_card),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                _photoRow('Photo Front CIN', 1, frontCinImage != null),
                const SizedBox(height: 10),
                _photoRow('Photo Back CIN', 2, backCinImage != null),
                const SizedBox(height: 10),
                _photoRow('Photo Contrat', 3, contractImage != null),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Soumettre'),
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoRow(String label, int idx, bool done) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: Text(label),
            onPressed: () => _takePhoto(idx),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        done
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      ],
    );
  }
}
