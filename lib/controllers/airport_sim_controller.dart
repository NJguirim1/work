import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/airport_sim_model.dart';

class AirportSimController {
  AirportSimModel model;
  final ImagePicker _picker = ImagePicker();

  AirportSimController(this.model);

  Future<void> pickFrontCinImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      model.frontCinImage = base64Encode(await picked.readAsBytes());
    }
  }

  Future<void> pickBackCinImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      model.backCinImage = base64Encode(await picked.readAsBytes());
    }
  }

  Future<void> pickContractImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      model.contractImage = base64Encode(await picked.readAsBytes());
    }
  }

  Future<bool> submit(String token, String sellPointId, String latitude, String longitude) async {
    const apiUrl = 'https://your-api-base-url.com/airport-sim'; // Replace with actual endpoint
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          ...model.toJson(),
          'sell_point_id': sellPointId,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
