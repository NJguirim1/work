import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/standard_sim_controller.dart';
import 'package:flutter_application_1/view/EtrangerSimScreen%20.dart';


import 'package:flutter_application_1/view/portabilite_sim_screen.dart';
 

import 'package:image_picker/image_picker.dart';



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

  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjU2NTEiLCJOYW1lIjoiQUJET1VMSSBNSUxFRCIsIlVzZXJuYW1lIjoibWlsZWQiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ4NTU1MDE0LCJleHAiOjE3NDg1NTg2MTQsImlhdCI6MTc0ODU1NTAxNCwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.gf7-XEzgy_bYrTpgea80sSnnDKGvGJp4uBlPccGzSj4';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PortabiliteSimPage()),
          ).then((_) {
            _tabController.index = 0; 
          });
        } else if (_tabController.index == 2) {
    
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EtrangerSimView()),
          ).then((_) {
            _tabController.index = 0; 
          });
        }
      }
    });
  }

  Future<void> scanIccid() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      setState(() {
        iccid = result.rawContent;
      });
    }
  }

  Future<void> takePhoto(int imageNumber) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) frontCinImage = File(pickedFile.path);
        if (imageNumber == 2) backCinImage = File(pickedFile.path);
        if (imageNumber == 3) contractImage = File(pickedFile.path);
      });
    }
  }

  Future<void> submit() async {
    if (iccid.isEmpty ||
        cinController.text.isEmpty ||
        frontCinImage == null ||
        backCinImage == null ||
        contractImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Veuillez remplir tous les champs et prendre les photos')),
      );
      return;
    }

    final response = await controller.submitStandardSim(
      token: token,
      iccid: iccid,
      cin: cinController.text,
      frontCinImage: frontCinImage!,
      backCinImage: backCinImage!,
      contractImage: contractImage!,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Soumission réussie')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur ${response.statusCode} : ${response.body}')),
      );
    }
  }

  @override
  void dispose() {
    cinController.dispose();
    _tabController.dispose();
    super.dispose();
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
      body: buildStandardSimForm(),
    );
  }

  Widget buildStandardSimForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: scanIccid,
              child: const Text('Scanner ICCID'),
            ),
            const SizedBox(height: 10),
            Text('ICCID scanné: $iccid'),
            const SizedBox(height: 20),
            TextField(
              controller: cinController,
              decoration: const InputDecoration(labelText: 'Numéro CIN'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => takePhoto(1),
                  child: const Text('Photo Front CIN'),
                ),
                const SizedBox(width: 10),
                frontCinImage == null
                    ? const Text('Aucune photo')
                    : const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => takePhoto(2),
                  child: const Text('Photo Back CIN'),
                ),
                const SizedBox(width: 10),
                backCinImage == null
                    ? const Text('Aucune photo')
                    : const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => takePhoto(3),
                  child: const Text('Photo Contrat'),
                ),
                const SizedBox(width: 10),
                contractImage == null
                    ? const Text('Aucune photo')
                    : const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}
