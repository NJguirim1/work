import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/portability_sim_controller.dart';
import 'package:flutter_application_1/models/portability_sim_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /* ─────────────────────────  Helpers  ───────────────────────── */

  Future<void> scanICCID() async {
    final res = await BarcodeScanner.scan();
    if (res.type == ResultType.Barcode) {
      setState(() => _iccIdController.text = res.rawContent);
    }
  }

  Future<void> pickImage(String type) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (picked == null) return;
    final data = base64Encode(await picked.readAsBytes());

    setState(() {
      switch (type) {
        case "frontCin":
          frontCinBase64 = data;
          break;
        case "backCin":
          backCinBase64 = data;
          break;
        case "rioSignature":
          rioSignatureBase64 = data;
          break;
        case "rioSignature2":
          rioSignature2Base64 = data;
          break;
        case "numberImage":
          numberImageBase64 = data;
          break;
        case "contract":
          contractBase64 = data;
          break;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer"))
        ],
      ),
    );
  }

  Future<void> _saveOffline(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unsent_sales') ?? [];
    list.add(jsonEncode(json));
    await prefs.setStringList('unsent_sales', list);
  }

  /* ─────────────────────────  Submit  ───────────────────────── */

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if ([frontCinBase64, backCinBase64, rioSignatureBase64, rioSignature2Base64, numberImageBase64, contractBase64]
        .any((b) => b == null)) {
      _showErrorDialog("Merci de fournir toutes les images");
      return;
    }

    setState(() => _isSubmitting = true);

    final sale = {
      "type": 1,
      "iccId": _iccIdController.text.trim(),
      "nationalIdNumber": _nationalIdController.text.trim(),
      "portabilityNumber": _portabilityNumberController.text.trim(),
      "passportNumber": _passportNumberController.text.trim(),
      "sellPointId": _sellPointIdController.text.trim(),
      "latitude": _latitudeController.text.trim(),
      "longitude": _longitudeController.text.trim(),
      "city": _cityController.text.trim(),
      "country": _countryController.text.trim(),
      "portabilityNationalIdentificationNumberFrontImage": frontCinBase64!,
      "portabilityNationalIdentificationNumberBackImage": backCinBase64!,
      "portabilityRioSignatureImage": rioSignatureBase64!,
      "portabilityRioSignatureImage2": rioSignature2Base64!,
      "portabilityNumberImage": numberImageBase64!,
      "portabilityContratImage": contractBase64!,
      "inChargeSupervisorId": _supervisorIdController.text.trim(),
      "dateEnvoi": DateTime.now().toIso8601String(),
    };

    // offline?
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      await _saveOffline(sale);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Pas d'internet – vente enregistrée localement")));
      _resetForm();
      return;
    }

    // online
    final ctrl = PortabilitySimSaleController(token: widget.token);
    final res = await ctrl.submitSale(PortabilitySimSaleModel.fromJson(sale));

    setState(() => _isSubmitting = false);
    if (res["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Soumission réussie")));
      _resetForm();
    } else {
      _showErrorDialog(res["message"] ?? "Erreur inconnue");
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      frontCinBase64 = backCinBase64 =
          rioSignatureBase64 = rioSignature2Base64 = numberImageBase64 = contractBase64 = null;
      _isSubmitting = false;
    });
  }

  /* ─────────────────────────  UI widgets  ───────────────────────── */

  Widget _tField(TextEditingController c, String label,
      {bool req = false, IconData? icon}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: req ? (v) => v == null || v.isEmpty ? "$label requis" : null : null,
        ),
      );

  Widget _imgPicker(String label, String key, String? b64) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 56) / 2, // 16 + 20 + spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => pickImage(key),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: b64 == null
                  ? const Center(child: Icon(Icons.camera_alt, size: 32, color: Colors.grey))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(base64Decode(b64), fit: BoxFit.cover),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /* ─────────────────────────  build  ───────────────────────── */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vente SIM Portabilité'),
        actions: [
          IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: scanICCID),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informations Générales",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _tField(_iccIdController, "ICCID", req: true, icon: Icons.qr_code),
                  _tField(_nationalIdController, "Numéro CIN", req: true),
                  _tField(_portabilityNumberController, "Numéro Portabilité"),
                  _tField(_passportNumberController, "Numéro Passeport (optionnel)"),
                  _tField(_sellPointIdController, "SellPointId", req: true),
                  _tField(_latitudeController, "Latitude"),
                  _tField(_longitudeController, "Longitude"),
                  _tField(_cityController, "Ville"),
                  _tField(_countryController, "Pays"),
                  _tField(_supervisorIdController, "ID Superviseur"),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Photos obligatoires",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _imgPicker("CIN Face", "frontCin", frontCinBase64),
                      _imgPicker("CIN Dos", "backCin", backCinBase64),
                      _imgPicker("Signature RIO 1", "rioSignature", rioSignatureBase64),
                      _imgPicker("Signature RIO 2", "rioSignature2", rioSignature2Base64),
                      _imgPicker("Numéro Portabilité", "numberImage", numberImageBase64),
                      _imgPicker("Contrat", "contract", contractBase64),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.send),
                            label: const Text("Soumettre la vente"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
