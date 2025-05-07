// controllers/vente_controller.dart
import 'package:flutter_application_1/models/vente_model.dart';
import 'package:http/http.dart' as http;


class VenteController {
  final String token;

  VenteController(this.token);

  // Fonction pour envoyer la vente à l'API
  Future<void> createSell(Vente vente) async {
    final url = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token';

    // Ajout des champs
    vente.toMap().forEach((key, value) {
      request.fields[key] = value;
    });

    // Ajout des images
    request.files.add(await http.MultipartFile.fromPath('FrontImage', vente.frontImage));
    request.files.add(await http.MultipartFile.fromPath('BackImage', vente.backImage));
    request.files.add(await http.MultipartFile.fromPath('Standard_ContratImage', vente.contractImage));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Vente ajoutée avec succès');
      } else {
        print('Erreur lors de l\'ajout de la vente : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }
}
