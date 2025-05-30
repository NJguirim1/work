import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/foreign_sim_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // for ISO datetime formatting



class ForeignSaleController extends GetxController {
  final iccIdController = TextEditingController();
  final passportNumberController = TextEditingController();

  Rx<File?> passportImage1 = Rx<File?>(null);
  Rx<File?> contractImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  RxBool isLoading = false.obs;

  // TODO: Replace with your actual Bearer token management
  String bearerToken = "YOUR_BEARER_TOKEN_HERE";

  // TODO: Replace with your actual sell point id and supervisor id
  String sellPointId = "SELL_POINT_ID";
  String inChargeSupervisorId = "";

  // Dummy GPS and location - replace with real GPS & city/country
  String latitude = "48.8566";
  String longitude = "2.3522";
  String city = "Paris";
  String country = "France";

  Future<void> pickImage(bool isPassport) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      if (isPassport) {
        passportImage1.value = File(pickedFile.path);
      } else {
        contractImage.value = File(pickedFile.path);
      }
    }
  }

  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> submitForeignSale() async {
    final iccId = iccIdController.text.trim();
    final passportNumber = passportNumberController.text.trim();

    if (iccId.isEmpty) {
      Get.snackbar("Erreur", "Le champ ICC ID est obligatoire");
      return;
    }
    if (passportImage1.value == null) {
      Get.snackbar("Erreur", "Veuillez prendre une photo du passeport");
      return;
    }
    if (contractImage.value == null) {
      Get.snackbar("Erreur", "Veuillez prendre une photo du contrat");
      return;
    }

    isLoading.value = true;

    try {
      final passportBase64 = await _fileToBase64(passportImage1.value!);
      final contractBase64 = await _fileToBase64(contractImage.value!);

      // For Foreign_PassportImage2, send empty string as optional
      final foreignSale = ForeignSaleModel(
        iccId: iccId,
        passportNumber: passportNumber,
        sellPointId: sellPointId,
        latitude: latitude,
        longitude: longitude,
        city: city,
        country: country,
        passportImage1Base64: passportBase64,
        passportImage2Base64: "", // optional
        contractImageBase64: contractBase64,
        inChargeSupervisorId: inChargeSupervisorId,
        dateEnvoi: DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
      );

      final response = await http.post(
        Uri.parse("https://yourapi.com/Main/Api/Sims/CreateSell"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(foreignSale.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Succès", "Vente enregistrée avec succès");
        clearForm();
      } else {
        Get.snackbar(
            "Erreur",
            "Échec de la soumission : ${response.statusCode} \n${response.body}");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Une erreur est survenue : $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    iccIdController.clear();
    passportNumberController.clear();
    passportImage1.value = null;
    contractImage.value = null;
  }

  @override
  void onClose() {
    iccIdController.dispose();
    passportNumberController.dispose();
    super.onClose();
  }
}
