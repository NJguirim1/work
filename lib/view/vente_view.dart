// views/vente_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/vente_controller.dart';
import 'package:flutter_application_1/models/vente_model.dart';
import 'package:image_picker/image_picker.dart';



class VenteView extends StatefulWidget {
  final String token; 
  VenteView({required this.token});

  @override
  _VenteViewState createState() => _VenteViewState();
}

class _VenteViewState extends State<VenteView> {
  late VenteController venteController;

  late XFile frontImage;
  late XFile backImage;
  late XFile contractImage;

  @override
  void initState() {
    super.initState();
    venteController = VenteController(widget.token);
  }


  Future<void> pickImage(ImageSource source, String imageType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    setState(() {
      if (image != null) {
        if (imageType == 'front') {
          frontImage = image;
        } else if (imageType == 'back') {
          backImage = image;
        } else if (imageType == 'contract') {
          contractImage = image;
        }
      }
    });
  }

  // Envoyer la vente
  void sendSale() {
    Vente vente = Vente(
      type: '0', // Exemple pour 'Standard'
      iccid: '123456789',
      nationalId: '1234567890',
      passportNumber: 'P1234567',
      sellPointId: '123',
      latitude: '34.0522',
      longitude: '-118.2437',
      city: 'Los Angeles',
      country: 'USA',
      dateEnvoi: '2025-04-23',
      frontImage: frontImage.path,
      backImage: backImage.path,
      contractImage: contractImage.path,
    );

    venteController.createSell(vente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle Vente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera, 'front'),
              child: const Text('Prendre photo de la CIN avant'),
            ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera, 'back'),
              child: const Text('Prendre photo de la CIN arrière'),
            ),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.camera, 'contract'),
              child: const Text('Prendre photo du contrat'),
            ),
            ElevatedButton(
              onPressed: sendSale,
              child: const Text('Envoyer la vente'),
            ),
          ],
        ),
      ),
    );
  }
}
