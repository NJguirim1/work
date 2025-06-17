import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/foreign_sim_controller.dart';
import 'package:flutter_application_1/models/foreign_sim_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForeignSimSaleView extends StatefulWidget {
  final String token;

  const ForeignSimSaleView({Key? key, required this.token}) : super(key: key);

  @override
  _ForeignSimSaleViewState createState() => _ForeignSimSaleViewState();
}

class _ForeignSimSaleViewState extends State<ForeignSimSaleView> {
  /* ─────────────  Controllers  ───────────── */
  final _formKey = GlobalKey<FormState>();

  final _iccIdController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _sellPointIdController = TextEditingController(text: '2040');
  final _latitudeController = TextEditingController(text: '35.667336');
  final _longitudeController = TextEditingController(text: '10.9001284');
  final _cityController = TextEditingController(text: 'SAYADA');
  final _countryController = TextEditingController(text: 'TN');
  final _supervisorIdController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? passportImage1Base64;
  String? passportImage2Base64;
  String? contractBase64;

  bool _isSubmitting = false;

  /* ─────────────  NET : disponibilité  ───────────── */
  Future<bool> _hasInternet() async {
    final status = await Connectivity().checkConnectivity();
    if (status == ConnectivityResult.none) return false;
    try {
      final lookup =
          await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 2));
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  /* ─────────────  Persist « À envoyer »  ───────────── */
  Future<void> _saveUnsentSale() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('unsent_foreign_sales') ?? [];

    final saleMap = {
      'type': 2,
      'iccId': _iccIdController.text.trim(),
      'passportNumber': _passportNumberController.text.trim(),
      'sellPointId': _sellPointIdController.text.trim(),
      'latitude': _latitudeController.text.trim(),
      'longitude': _longitudeController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'foreignPassportImage1': passportImage1Base64,
      'foreignPassportImage2': passportImage2Base64,
      'foreignContratImage': contractBase64,
      'inChargeSupervisorId': _supervisorIdController.text.trim(),
      'dateEnvoi': DateTime.now().toIso8601String(),
    };

    list.add(jsonEncode(saleMap));
    await prefs.setStringList('unsent_foreign_sales', list);
  }

  /* ─────────────  Image picker  ───────────── */
  Future<void> pickImage(String type) async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (picked == null) return;
    final data = base64Encode(await picked.readAsBytes());

    setState(() {
      switch (type) {
        case 'passport1':
          passportImage1Base64 = data;
          break;
        case 'passport2':
          passportImage2Base64 = data;
          break;
        case 'contract':
          contractBase64 = data;
          break;
      }
    });
  }

  /* ─────────────  Scan ICCID  ───────────── */
  Future<void> scanICCID() async {
    try {
      final res = await BarcodeScanner.scan();
      if (res.type == ResultType.Barcode) {
        setState(() => _iccIdController.text = res.rawContent);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur scan : $e')));
    }
  }

  /* ─────────────  Soumission  ───────────── */
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if ([passportImage1Base64, passportImage2Base64, contractBase64]
        .any((b64) => b64 == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Toutes les images sont requises')));
      return;
    }

    setState(() => _isSubmitting = true);

    /* --- hors‑ligne ? --- */
    final online = await _hasInternet();
    if (!online) {
      await _saveUnsentSale();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pas de réseau : vente ajoutée à « À envoyer »')));
      setState(() => _isSubmitting = false);
      return;
    }

    /* --- création modèle --- */
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

    final api = ForeignSimSaleController(token: widget.token);

    try {
      final res = await api.submitSale(model);

      if (res['success'] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Soumission réussie')));
        _formKey.currentState?.reset();
        setState(() {
          passportImage1Base64 = passportImage2Base64 = contractBase64 = null;
        });
      } else {
        // serveur répond mais erreur → stocker localement
        await _saveUnsentSale();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Erreur serveur (${res['message'] ?? 'code inconnu'}) : vente mise en attente')));
      }
    } on SocketException catch (_) {
      await _saveUnsentSale();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pas de connexion : vente ajoutée à « À envoyer »')));
    } on TimeoutException catch (_) {
      await _saveUnsentSale();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Timeout réseau : vente ajoutée à « À envoyer »')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  /* ─────────────  UI helper  ───────────── */
  Widget _buildImagePicker(String label, String key, String? base64img) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => pickImage(key),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: base64img == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                  : Image.memory(base64Decode(base64img), fit: BoxFit.cover),
            ),
          ),
        ],
      );

  /* ─────────────  BUILD  ───────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vente SIM Étranger')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _iccIdController,
                      decoration: const InputDecoration(labelText: 'ICCID'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'ICCID requis' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: 'Scanner ICCID',
                    onPressed: scanICCID,
                  ),
                ],
              ),
              TextFormField(
                controller: _passportNumberController,
                decoration:
                    const InputDecoration(labelText: 'Numéro Passeport'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Passeport requis' : null,
              ),
              TextFormField(
                controller: _sellPointIdController,
                decoration: const InputDecoration(labelText: 'SellPointId'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'SellPointId requis' : null,
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ville'),
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Pays'),
              ),
              TextFormField(
                controller: _supervisorIdController,
                decoration:
                    const InputDecoration(labelText: 'ID Superviseur'),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildImagePicker('Passeport 1', 'passport1', passportImage1Base64),
                  _buildImagePicker('Passeport 2', 'passport2', passportImage2Base64),
                  _buildImagePicker('Contrat', 'contract', contractBase64),
                ],
              ),
              const SizedBox(height: 30),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Soumettre la vente'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
