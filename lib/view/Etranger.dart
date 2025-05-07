import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VenteEtrangerView extends StatefulWidget {
  final String token;
  const VenteEtrangerView({super.key, required this.token});

  @override
  State<VenteEtrangerView> createState() => _VenteEtrangerViewState();
}

class _VenteEtrangerViewState extends State<VenteEtrangerView> {
  final picker = ImagePicker();

  Map<String, XFile?> images = {
    'Passeport': null,
    'Contrat': null,
  };

  final passportNumberController = TextEditingController(); // facultatif
  final iccIdController = TextEditingController(); // obligatoire

  Future<void> pickImage(String label) async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        images[label] = picked;
      });
    }
  }

  Widget buildImageCard(String label) {
    final image = images[label];
    return GestureDetector(
      onTap: () => pickImage(label),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            image != null
                ? Image.file(File(image.path), fit: BoxFit.cover, width: double.infinity)
                : const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            const Positioned(top: 5, right: 5, child: Icon(Icons.refresh, color: Colors.blueAccent)),
            Positioned(
              bottom: 5,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.qr_code_scanner, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            required ? Icons.error_outline : Icons.add,
            color: required ? Colors.red : Colors.redAccent,
          )
        ],
      ),
    );
  }

  void sendSale() {
    print("ICC-ID: ${iccIdController.text}");
    print("N° Passport: ${passportNumberController.text}");

    for (var entry in images.entries) {
      if (entry.value == null) {
        print("Image manquante : ${entry.key}");
      }
    }

    // Ajoute ici ton appel API
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: images.keys.map((label) => buildImageCard(label)).toList(),
          ),
          const SizedBox(height: 20),
          buildTextField("N° Passport (facultatif)", passportNumberController),
          buildTextField("Icc-Id", iccIdController, required: true),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: sendSale,
                  icon: const Icon(Icons.send),
                  label: const Text("ENVOYER"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {}, // Action optionnelle
                icon: const Icon(Icons.videogame_asset, color: Colors.blue, size: 32),
              )
            ],
          )
        ],
      ),
    );
  }
}
