import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/etrangercontroller.dart';

import 'package:image_picker/image_picker.dart';

class EtrangerSimView extends StatefulWidget {
  @override
  _EtrangerSimViewState createState() => _EtrangerSimViewState();
}

class _EtrangerSimViewState extends State<EtrangerSimView> {
  final EtrangerSimController controller = EtrangerSimController();

  String iccid = '';
  final TextEditingController passportNumberController = TextEditingController();

  File? passportImage;
  File? contractImage;

  // Replace by your actual token or get it dynamically
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjU2NTEiLCJOYW1lIjoiQUJET1VMSSBNSUxFRCIsIlVzZXJuYW1lIjoibWlsZWQiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ4NTU1MDE0LCJleHAiOjE3NDg1NTg2MTQsImlhdCI6MTc0ODU1NTAxNCwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.gf7-XEzgy_bYrTpgea80sSnnDKGvGJp4uBlPccGzSj4';

  // You might want to get these values from user or context:
  final String sellPointId = '2040';
  final String latitude = '35.667336';
  final String longitude = '10.9001284';
  final String city = 'SAYADA';
  final String country = 'TN';
  final String inChargeSupervisorId = '1507';
  final String dateEnvoi = DateTime.now().toIso8601String();

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
        if (imageNumber == 1) passportImage = File(pickedFile.path);
        if (imageNumber == 2) contractImage = File(pickedFile.path);
      });
    }
  }

  Future<void> submit() async {
    if (iccid.isEmpty || passportImage == null || contractImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Veuillez scanner ICCID et prendre toutes les photos')),
      );
      return;
    }

    final response = await controller.submitEtrangerSim(
      token: token,
      iccid: iccid,
      passportNumber: passportNumberController.text,
      passportImage: passportImage!,
      contractImage: contractImage!,
      sellPointId: sellPointId,
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
      inChargeSupervisorId: inChargeSupervisorId,
      dateEnvoi: dateEnvoi,
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
    passportNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vente SIM Étranger'),
      ),
      body: Padding(
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
                controller: passportNumberController,
                decoration: const InputDecoration(labelText: 'Numéro Passeport (optionnel)'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => takePhoto(1),
                    child: const Text('Photo Passeport'),
                  ),
                  const SizedBox(width: 10),
                  passportImage == null
                      ? const Text('Aucune photo')
                      : const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => takePhoto(2),
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
      ),
    );
  }
}
