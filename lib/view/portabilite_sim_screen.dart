import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/portability_sim_controller.dart';
import 'package:flutter_application_1/models/portability_sim_model.dart';
import 'package:flutter_application_1/view/standard_sim_view.dart';
 // à adapter
import 'package:image_picker/image_picker.dart';

class PortabiliteSimPage extends StatefulWidget {
  @override
  _PortabiliteSimPageState createState() => _PortabiliteSimPageState();
}

class _PortabiliteSimPageState extends State<PortabiliteSimPage>
    with SingleTickerProviderStateMixin {
  final PortabiliteSimController controller = PortabiliteSimController();

  String iccid = '';
  final TextEditingController cinController = TextEditingController();

  File? frontCinImage;
  File? backCinImage;
  File? rioSignatureImage;
  File? portabilityNumberImage;
  File? contractImage;

  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjU2NTEiLCJOYW1lIjoiQUJET1VMSSBNSUxFRCIsIlVzZXJuYW1lIjoibWlsZWQiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ4NTU1MDE0LCJleHAiOjE3NDg1NTg2MTQsImlhdCI6MTc0ODU1NTAxNCwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.gf7-XEzgy_bYrTpgea80sSnnDKGvGJp4uBlPccGzSj4';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => StandardSimPage()),
          );
        } else if (_tabController.index == 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Page Étranger pas encore disponible')),
          );
          _tabController.index = 1;
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
        File image = File(pickedFile.path);
        switch (imageNumber) {
          case 1:
            frontCinImage = image;
            break;
          case 2:
            backCinImage = image;
            break;
          case 3:
            rioSignatureImage = image;
            break;
          case 4:
            portabilityNumberImage = image;
            break;
          case 5:
            contractImage = image;
            break;
        }
      });
    }
  }

  Future<void> submit() async {
    if (iccid.isEmpty ||
        cinController.text.isEmpty ||
        frontCinImage == null ||
        backCinImage == null ||
        rioSignatureImage == null ||
        portabilityNumberImage == null ||
        contractImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Veuillez remplir tous les champs et prendre toutes les photos')),
      );
      return;
    }

    final response = await controller.submitPortabiliteSim(
      token: token,
      iccid: iccid,
      cin: cinController.text,
      frontCinImage: frontCinImage!,
      backCinImage: backCinImage!,
      rioSignatureImage: rioSignatureImage!,
      portabilityNumberImage: portabilityNumberImage!,
      contractImage: contractImage!, portabilityNumber: '',
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
      body: buildPortabiliteForm(),
    );
  }

  Widget buildPortabiliteForm() {
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
            buildPhotoRow('Photo Front CIN', frontCinImage, () => takePhoto(1)),
            buildPhotoRow('Photo Back CIN', backCinImage, () => takePhoto(2)),
            buildPhotoRow('Photo RIO & Signature Client', rioSignatureImage, () => takePhoto(3)),
            buildPhotoRow('Photo Numéro Portabilité', portabilityNumberImage, () => takePhoto(4)),
            buildPhotoRow('Photo Contrat', contractImage, () => takePhoto(5)),
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

  Widget buildPhotoRow(String label, File? image, VoidCallback onPressed) {
    return Row(
      children: [
        ElevatedButton(onPressed: onPressed, child: Text(label)),
        const SizedBox(width: 10),
        image == null
            ? const Text('Aucune photo')
            : const Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }
}
