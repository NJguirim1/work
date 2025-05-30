import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PortabiliteSimScreen extends StatefulWidget {
  final String token;

  PortabiliteSimScreen({required this.token});

  @override
  _PortabiliteSimScreenState createState() => _PortabiliteSimScreenState();
}

class _PortabiliteSimScreenState extends State<PortabiliteSimScreen> {
  final ImagePicker _picker = ImagePicker();

  String? cin;
  String? iccid;
  String? portabiliteNumber;

  File? cinFrontImage;
  File? cinBackImage;
  File? rioSignatureImage;
  File? contratImage;

  Future<void> scanIccid() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      setState(() {
        iccid = result.rawContent;
      });
    }
  }

  Future<void> pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        switch (type) {
          case 'front':
            cinFrontImage = file;
            break;
          case 'back':
            cinBackImage = file;
            break;
          case 'rio':
            rioSignatureImage = file;
            break;
          case 'contract':
            contratImage = file;
            break;
        }
      });
    }
  }

  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      format: CompressFormat.jpeg,
    );
    return result != null ? File(result.path) : null;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> submit() async {
    if ([cin, iccid, portabiliteNumber].any((e) => e == null || e!.isEmpty) ||
        [cinFrontImage, cinBackImage, rioSignatureImage, contratImage].any((f) => f == null)) {
      showSnackBar("Veuillez remplir tous les champs et ajouter toutes les images.");
      return;
    }

    final compressedFront = await compressImage(cinFrontImage!);
    final compressedBack = await compressImage(cinBackImage!);
    final compressedRio = await compressImage(rioSignatureImage!);
    final compressedContract = await compressImage(contratImage!);

    if ([compressedFront, compressedBack, compressedRio, compressedContract].any((f) => f == null)) {
      showSnackBar("Erreur lors de la compression d’image.");
      return;
    }

    var uri = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${widget.token}';

    request.fields.addAll({
      'Type': '1',
      'NationalIdentificationNumber': cin!,
      'IccId': iccid!,
      'PortedNumber': portabiliteNumber!,
      'SellPointId': '2040',
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507',
      'DateEnvoi': DateTime.now().toIso8601String(),
    });

    request.files.add(await http.MultipartFile.fromPath('Portability_NationalIdentificationNumberFrontImage', compressedFront!.path));
    request.files.add(await http.MultipartFile.fromPath('Portability_NationalIdentificationNumberBackImage', compressedBack!.path));
    request.files.add(await http.MultipartFile.fromPath('Portability_RIOAndSignatureClientImage', compressedRio!.path));
    request.files.add(await http.MultipartFile.fromPath('Portability_ContratImage', compressedContract!.path));

    try {
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showSnackBar("Soumission réussie !");
      } else {
        showSnackBar("Erreur API : ${response.statusCode}");
        print("Réponse : $responseBody");
      }
    } catch (e) {
      showSnackBar("Erreur réseau : $e");
    }
  }

  Widget buildImageRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildImageColumn('CIN Avant', cinFrontImage, () => pickImage('front')),
            buildImageColumn('CIN Arrière', cinBackImage, () => pickImage('back')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildImageColumn('RIO + Signature', rioSignatureImage, () => pickImage('rio')),
            buildImageColumn('Contrat', contratImage, () => pickImage('contract')),
          ],
        ),
      ],
    );
  }

  Widget buildImageColumn(String label, File? image, VoidCallback onPressed) {
    return Column(
      children: [
        Text(label),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: onPressed),
        if (image != null) Image.file(image, width: 80, height: 80),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SIM Portabilité")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Numéro CIN"),
            TextField(
              decoration: InputDecoration(hintText: "Entrez le numéro CIN"),
              onChanged: (val) => cin = val,
            ),
            SizedBox(height: 10),
            Text("Numéro de Portabilité"),
            TextField(
              decoration: InputDecoration(hintText: "Entrez le numéro à porter"),
              onChanged: (val) => portabiliteNumber = val,
            ),
            SizedBox(height: 10),
            Text("ICCID"),
            Row(
              children: [
                Expanded(
                  child: Text(iccid ?? 'Aucun ICCID scanné'),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: scanIccid,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Photos"),
            buildImageRow(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: submit,
                child: Text("Soumettre"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
