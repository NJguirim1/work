import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/standard_sim_model.dart';
import '../services/standard_sim_service.dart';

class StandardSimController {
  final StandardSimModel model;
  final picker = ImagePicker();

  StandardSimController(this.model);

  Future<void> pickImageFront() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.frontImage = base64Encode(File(pickedFile.path).readAsBytesSync());
    }
  }

  Future<void> pickImageBack() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.backImage = base64Encode(File(pickedFile.path).readAsBytesSync());
    }
  }

  Future<void> pickContractImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      model.contractImage = base64Encode(File(pickedFile.path).readAsBytesSync());
    }
  }

  Future<bool> submitStandardSim(String token) async {
    return await StandardSimService.submitStandardSim(model, token);
  }
}
