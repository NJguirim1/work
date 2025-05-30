import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/SimStandardModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StandardSimController {
  StandardSimModel model;

  StandardSimController(this.model);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFront() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.frontImagePath = await _compressImage(pickedFile.path);
      print("Front image selected: ${model.frontImagePath}");
    }
  }

  Future<void> pickImageBack() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.backImagePath = await _compressImage(pickedFile.path);
      print("Back image selected: ${model.backImagePath}");
    }
  }

  Future<void> pickContractImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.contractImagePath = await _compressImage(pickedFile.path);
      print("Contract image selected: ${model.contractImagePath}");
    }
  }

  Future<String> _compressImage(String filePath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      "${filePath}_compressed.jpg",
      quality: 40,
    );
    print("Image compressed: ${result?.path ?? filePath}");
    return result?.path ?? filePath;
  }

  Future<bool> submitStandardSimWithResponse(String token) async {
    try {
      print("📤 Sending request to API...");

      final uri = Uri.parse("http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell");
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      // Champs texte
      request.fields['Type'] = '0';
      request.fields['IccId'] = model.iccId;
      request.fields['NationalIdentificationNumber'] = model.cin;
      request.fields['SellPointId'] = '2046';
      request.fields['Latitude'] = '36.8065';
      request.fields['Longitude'] = '10.1815';
      request.fields['City'] = 'Tunis';
      request.fields['Country'] = 'TN';
      request.fields['InChargeSupervisorId'] = '5651';
      request.fields['DateEnvoi'] = DateTime.now().toIso8601String();

      
      print("📦 Champs envoyés :");
      request.fields.forEach((key, value) {
        print("- $key: $value");
      });

  
      if (model.frontImagePath != null) {
        print("📷 Ajout image avant: ${model.frontImagePath}");
        request.files.add(await http.MultipartFile.fromPath(
          'Standard_NationalIdentificationNumberFrontImage',
          model.frontImagePath!,
        ));
      }

      if (model.backImagePath != null) {
        print("📷 Ajout image arrière: ${model.backImagePath}");
        request.files.add(await http.MultipartFile.fromPath(
          'Standard_NationalIdentificationNumberBackImage',
          model.backImagePath!,
        ));
      }

      if (model.contractImagePath != null) {
        print("📷 Ajout image contrat: ${model.contractImagePath}");
        request.files.add(await http.MultipartFile.fromPath(
          'Standard_ContratImage',
          model.contractImagePath!,
        ));
      }

      
      var response = await request.send();
      var body = await response.stream.bytesToString();

      print("✅ Statut HTTP: ${response.statusCode}");
      print("📨 Corps réponse: $body");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Erreur lors de l'envoi: $e");
      return false;
    }
  }
}
