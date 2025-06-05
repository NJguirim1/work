import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/foreign_sim_controller.dart';
import 'package:flutter_application_1/models/foreign_sim_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';



class ForeignSimSaleView extends StatefulWidget {
  final String token;

  const ForeignSimSaleView({Key? key, required this.token}) : super(key: key);

  @override
  _ForeignSimSaleViewState createState() => _ForeignSimSaleViewState();
}

class _ForeignSimSaleViewState extends State<ForeignSimSaleView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _iccIdController = TextEditingController();
  final TextEditingController _passportNumberController = TextEditingController();
  final TextEditingController _sellPointIdController = TextEditingController(text: "2040");
  final TextEditingController _latitudeController = TextEditingController(text: "35.667336");
  final TextEditingController _longitudeController = TextEditingController(text: "10.9001284");
  final TextEditingController _cityController = TextEditingController(text: "SAYADA");
  final TextEditingController _countryController = TextEditingController(text: "TN");
  final TextEditingController _supervisorIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? passportImage1Base64;
  String? passportImage2Base64;
  String? contractBase64;

  bool _isSubmitting = false;

  Future<void> pickImage(String type) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64img = base64Encode(bytes);
      setState(() {
        if (type == 'passport1') passportImage1Base64 = base64img;
        else if (type == 'passport2') passportImage2Base64 = base64img;
        else if (type == 'contract') contractBase64 = base64img;
      });
    }
  }

  Future<void> scanICCID() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        setState(() {
          _iccIdController.text = result.rawContent;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du scan: $e")),
      );
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (passportImage1Base64 == null ||
        passportImage2Base64 == null ||
        contractBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Merci de fournir toutes les images")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final controller = ForeignSimSaleController(token: widget.token);

    final model = ForeignSimSaleModel(
      type: 2,
      iccId: _iccIdController.text.trim(),
      passportNumber: _passportNumberController.text.trim(),
      sellPointId: _sellPointIdController.text.trim(),
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      foreignPassportImage1: passportImage1Base64!,
      foreignPassportImage2: passportImage2Base64!,
      foreignContratImage: contractBase64!,
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
        passportImage1Base64 = null;
        passportImage2Base64 = null;
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
        title: Text('Vente SIM Étranger'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _iccIdController,
                      decoration: InputDecoration(labelText: "ICCID"),
                      validator: (v) => v == null || v.isEmpty ? "ICCID requis" : null,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: scanICCID,
                    tooltip: "Scanner ICCID",
                  ),
                ],
              ),
              TextFormField(
                controller: _passportNumberController,
                decoration: InputDecoration(labelText: "Numéro Passeport"),
                validator: (v) => v == null || v.isEmpty ? "Numéro Passeport requis" : null,
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
                  _buildImagePicker("Photo Passeport 1", "passport1", passportImage1Base64),
                  _buildImagePicker("Photo Passeport 2", "passport2", passportImage2Base64),
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
