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

class _EtrangerSimScreenState extends State<EtrangerSimScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ImagePicker _picker = ImagePicker();

  // Données Passport
  String? passportNumber; // facultatif
  File? passportImage;
  File? contractImage;

  // Données CIN (pour l’onglet CIN)
  String? cinNumber;
  File? cinFrontImage;
  File? cinBackImage;

  String? iccid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        }  else if (type == 'cinFront') {
          cinFrontImage = file;
        } else if (type == 'cinBack') {
          cinBackImage = file;
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

  Future<void> submitPassport() async {
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

  Future<void> submitCin() async {
    if (iccid == null || iccid!.isEmpty) {
      showSnackBar("Veuillez entrer ou scanner l'ICCID");
      return;
    }
    if (cinNumber == null || cinNumber!.isEmpty) {
      showSnackBar("Veuillez entrer le numéro CIN");
      return;
    }
    if (cinFrontImage == null || cinBackImage == null || contractImage == null) {
      showSnackBar("Veuillez prendre toutes les photos (CIN avant/arrière + contrat)");
      return;
    }

    showSnackBar("Compression des images...");
    final compressedCinFront = await compressImage(cinFrontImage!);
    final compressedCinBack = await compressImage(cinBackImage!);
    final compressedContract = await compressImage(contractImage!);

    if (compressedCinFront == null || compressedCinBack == null || compressedContract == null) {
      showSnackBar("Erreur lors de la compression des images");
      return;
    }

    var uri = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${widget.token}';

    request.fields.addAll({
      'Type': '1',  // Type 1 = CIN Étranger (à adapter selon API)
      'IccId': iccid!,
      'NationalIdentificationNumber': cinNumber!,
      'SellPointId': '2040',
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507',
      'DateEnvoi': DateTime.now().toIso8601String(),
    });

    request.files.add(await http.MultipartFile.fromPath(
      'Etranger_NationalIdentificationNumberFrontImage',
      compressedCinFront.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'Etranger_NationalIdentificationNumberBackImage',
      compressedCinBack.path,
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

  Widget buildPassportTab() {
    return SingleChildScrollView(
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
              onPressed: submitPassport,
              child: Text('Soumettre Passport'),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCinTab() {
    return SingleChildScrollView(
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
          Text('N° CIN'),
          TextFormField(
            onChanged: (value) => cinNumber = value,
            decoration: InputDecoration(hintText: "Entrez le numéro CIN"),
          ),
          SizedBox(height: 20),
          Text('Photos'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('CIN Avant'),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => pickImage('cinFront'),
                  ),
                  if (cinFrontImage != null)
                    Image.file(cinFrontImage!, width: 80, height: 80, fit: BoxFit.cover),
                ],
              ),
              Column(
                children: [
                  Text('CIN Arrière'),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => pickImage('cinBack'),
                  ),
                  if (cinBackImage != null)
                    Image.file(cinBackImage!, width: 80, height: 80, fit: BoxFit.cover),
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
              onPressed: submitCin,
              child: Text('Soumettre CIN'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vente SIM Étranger'),
        backgroundColor: const Color.fromARGB(255, 207, 82, 36),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Passport'),
            Tab(text: 'CIN'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildPassportTab(),
          buildCinTab(),
        ],
      ),
    );
  }
}
