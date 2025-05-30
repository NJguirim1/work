import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EtrangerSimScreen extends StatefulWidget {
  final String token;

  EtrangerSimScreen({required this.token});

  @override
  _EtrangerSimScreenState createState() => _EtrangerSimScreenState();
}

class _EtrangerSimScreenState extends State<EtrangerSimScreen> {
  final ImagePicker _picker = ImagePicker();

  String? passportNumber; // facultatif
  String? iccid;
  File? passportImage;
  File? contractImage;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

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
        if (type == 'passport') {
          passportImage = file;
        } else if (type == 'contract') {
          contractImage = file;
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

  Future<void> submit() async {
    if (iccid == null || iccid!.isEmpty) {
      showSnackBar("Veuillez entrer ou scanner l'ICCID");
      return;
    }
    if (passportImage == null || contractImage == null) {
      showSnackBar("Veuillez prendre les photos du passeport et du contrat");
      return;
    }

    showSnackBar("Compression des images...");
    final compressedPassport = await compressImage(passportImage!);
    final compressedContract = await compressImage(contractImage!);

    if (compressedPassport == null || compressedContract == null) {
      showSnackBar("Erreur lors de la compression des images");
      return;
    }

    var uri = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${widget.token}';

    request.fields.addAll({
      'Type': '2',  // Type 2 = Étranger
      'IccId': iccid!,
      'PassportNumber': passportNumber ?? '',
      'SellPointId': '2040',
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507',
      'DateEnvoi': DateTime.now().toIso8601String(),
    });

    request.files.add(await http.MultipartFile.fromPath(
      'Etranger_PassportImage',
      compressedPassport.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'Etranger_ContratImage',
      compressedContract.path,
    ));

    try {
      showSnackBar("Envoi en cours...");
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showSnackBar("Succès : données envoyées");
      } else {
        showSnackBar("Erreur API : ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar("Erreur réseau : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vente SIM Étranger'),
        backgroundColor: const Color.fromARGB(255, 207, 82, 36),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ICCID'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: iccid,
                    onChanged: (value) => iccid = value,
                    decoration: InputDecoration(hintText: "Entrez ou scannez l'ICCID"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: scanIccid,
                ),
              ],
            ),
            SizedBox(height: 20),

            Text('N° Passport (facultatif)'),
            TextFormField(
              onChanged: (value) => passportNumber = value,
              decoration: InputDecoration(hintText: "Entrez le numéro de passeport"),
            ),
            SizedBox(height: 20),

            Text('Photos'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Passeport'),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () => pickImage('passport'),
                    ),
                    if (passportImage != null)
                      Image.file(passportImage!, width: 80, height: 80, fit: BoxFit.cover),
                  ],
                ),
                Column(
                  children: [
                    Text('Contrat'),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () => pickImage('contract'),
                    ),
                    if (contractImage != null)
                      Image.file(contractImage!, width: 80, height: 80, fit: BoxFit.cover),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: submit,
                child: Text('Soumettre'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
