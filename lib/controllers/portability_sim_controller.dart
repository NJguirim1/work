import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/portability_sim_model.dart';
import '../services/portability_sim_service.dart';

class PortabilitySimController {
  final PortabilitySimModel model;
  final PortabilitySimService service;

  PortabilitySimController(this.model, this.service);

  Future<void> pickImage(Function(String) onImagePicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);
      onImagePicked(base64Image);
    }
  }

  Future<bool> submit({
    required String token,
    required String sellPointId,
    required String latitude,
    required String longitude,
    required String city,
    required String country,
    required String supervisorId,
  }) async {
    return await service.submitPortabilitySale(
      model: model,
      token: token,
      sellPointId: sellPointId,
      latitude: latitude,
      longitude: longitude,
      city: city,
      country: country,
      supervisorId: supervisorId,
    );
  }
}
