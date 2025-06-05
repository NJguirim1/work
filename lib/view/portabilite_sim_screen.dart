import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/portability_sim_controller.dart';
import 'package:flutter_application_1/models/portability_sim_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';


class PortabilitySimSaleView extends StatefulWidget {
  final String token;

  const PortabilitySimSaleView({Key? key, required this.token}) : super(key: key);

  @override
  _PortabilitySimSaleViewState createState() => _PortabilitySimSaleViewState();
}

class _PortabilitySimSaleViewState extends State<PortabilitySimSaleView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _iccIdController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _portabilityNumberController = TextEditingController();
  final TextEditingController _passportNumberController = TextEditingController();
  final TextEditingController _sellPointIdController = TextEditingController(text: "2040");
  final TextEditingController _latitudeController = TextEditingController(text: "35.667336");
  final TextEditingController _longitudeController = TextEditingController(text: "10.9001284");
  final TextEditingController _cityController = TextEditingController(text: "SAYADA");
  final TextEditingController _countryController = TextEditingController(text: "TN");
  final TextEditingController _supervisorIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? frontCinBase64;
  String? backCinBase64;
  String? rioSignatureBase64;
  String? rioSignature2Base64;
  String? numberImageBase64;
  String? contractBase64;

  bool _isSubmitting = false;

  Future<void> scanICCID() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      setState(() {
        _iccIdController.text = result.rawContent;
      });
    }
  }

  Future<void> pickImage(String type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64img = base64Encode(bytes);
      setState(() {
        switch (type) {
          case "frontCin":
            frontCinBase64 = base64img;
            break;
          case "backCin":
            backCinBase64 = base64img;
            break;
          case "rioSignature":
            rioSignatureBase64 = base64img;
            break;
          case "rioSignature2":
            rioSignature2Base64 = base64img;
            break;
          case "numberImage":
            numberImageBase64 = base64img;
            break;
          case "contract":
            contractBase64 = base64img;
            break;
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (frontCinBase64 == null ||
        backCinBase64 == null ||
        rioSignatureBase64 == null ||
        rioSignature2Base64 == null ||
        numberImageBase64 == null ||
        contractBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Merci de fournir toutes les images")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final controller = PortabilitySimSaleController(token: widget.token);

    final model = PortabilitySimSaleModel(
      type: 1,
      iccId: _iccIdController.text.trim(),
      nationalIdNumber: _nationalIdController.text.trim(),
      portabilityNumber: _portabilityNumberController.text.trim(),
      passportNumber: _passportNumberController.text.trim(),
      sellPointId: _sellPointIdController.text.trim(),
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      portabilityNationalIdentificationNumberFrontImage: frontCinBase64!,
      portabilityNationalIdentificationNumberBackImage: backCinBase64!,
      portabilityRioSignatureImage: rioSignatureBase64!,
      portabilityRioSignatureImage2: rioSignature2Base64!,
      portabilityNumberImage: numberImageBase64!,
      portabilityContratImage: contractBase64!,
      inChargeSupervisorId: _supervisorIdController.text.trim(),
      dateEnvoi: DateTime.now().toIso8601String(),
    );

    final result = await controller.submitSale(model);

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"] ?? "Erreur inconnue")),
    );

    if (result["success"] == true) {
      _formKey.currentState?.reset();
      setState(() {
        frontCinBase64 = null;
        backCinBase64 = null;
        rioSignatureBase64 = null;
        rioSignature2Base64 = null;
        numberImageBase64 = null;
        contractBase64 = null;
      });
    }
  }

  Widget _buildImagePicker(String label, String type, String? base64img) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        InkWell(
          onTap: () => pickImage(type),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: base64img == null
                ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                : Image.memory(base64Decode(base64img), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vente SIM Portabilité'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: scanICCID,
            tooltip: "Scanner ICCID",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _iccIdController,
                decoration: InputDecoration(
                  labelText: "ICCID",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: scanICCID,
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? "ICCID requis" : null,
              ),
              TextFormField(
                controller: _nationalIdController,
                decoration: InputDecoration(labelText: "Numéro CIN"),
                validator: (v) => v == null || v.isEmpty ? "Numéro CIN requis" : null,
              ),
              TextFormField(
                controller: _portabilityNumberController,
                decoration: InputDecoration(labelText: "Numéro Portabilité"),
                // si tu veux, tu peux le rendre optionnel
              ),
              TextFormField(
                controller: _passportNumberController,
                decoration: InputDecoration(labelText: "Numéro Passeport (optionnel)"),
              ),
              TextFormField(
                controller: _sellPointIdController,
                decoration: InputDecoration(labelText: "SellPointId"),
                validator: (v) => v == null || v.isEmpty ? "SellPointId requis" : null,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: "Latitude"),
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: "Longitude"),
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: "Ville"),
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: "Pays"),
              ),
              TextFormField(
                controller: _supervisorIdController,
                decoration: InputDecoration(labelText: "ID Superviseur"),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildImagePicker("Photo CIN Face", "frontCin", frontCinBase64),
                  _buildImagePicker("Photo CIN Dos", "backCin", backCinBase64),
                  _buildImagePicker("Signature RIO 1", "rioSignature", rioSignatureBase64),
                  _buildImagePicker("Signature RIO 2", "rioSignature2", rioSignature2Base64),
                  _buildImagePicker("Photo Numéro Portabilité", "numberImage", numberImageBase64),
                  _buildImagePicker("Photo Contrat", "contract", contractBase64),
                ],
              ),
              SizedBox(height: 30),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text("Soumettre la vente"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
