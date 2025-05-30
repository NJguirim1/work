import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_application_1/view/nouvellevente.dart';
 // <-- import de SimAirportEtrangerScreen
import 'package:flutter_application_1/view/portabilite_sim_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StandardSimScreen extends StatefulWidget {
  final String token;

  StandardSimScreen({required this.token});

  @override
  _StandardSimScreenState createState() => _StandardSimScreenState();
}

class _StandardSimScreenState extends State<StandardSimScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> iccidList = [];
  final ImagePicker _picker = ImagePicker();

  String? cin;
  File? cinFrontImage;
  File? cinBackImage;
  File? contractImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 1) {  // Portabilité tab index
          _tabController.index = 0;        // Reset to Standard tab
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PortabiliteSimScreen(token: widget.token),
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> scanIccid() async {
    var result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      if (iccidList.length >= 5) {
        showSnackBar('Limite de 5 ICCID atteinte');
        return;
      }
      setState(() {
        iccidList.add(result.rawContent);
      });
    }
  }

  Future<void> pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        if (type == 'front') {
          cinFrontImage = file;
        } else if (type == 'back') {
          cinBackImage = file;
        } else if (type == 'contract') {
          contractImage = file;
        }
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
    if (cin == null || cin!.isEmpty) {
      showSnackBar("Veuillez entrer le numéro CIN");
      return;
    }
    if (iccidList.isEmpty) {
      showSnackBar("Veuillez scanner au moins un ICCID");
      return;
    }
    if (cinFrontImage == null || cinBackImage == null || contractImage == null) {
      showSnackBar("Veuillez prendre toutes les photos");
      return;
    }

    showSnackBar("Compression des images...");
    final compressedFront = await compressImage(cinFrontImage!);
    final compressedBack = await compressImage(cinBackImage!);
    final compressedContract = await compressImage(contractImage!);

    if (compressedFront == null || compressedBack == null || compressedContract == null) {
      showSnackBar("Erreur lors de la compression des images");
      return;
    }

    var uri = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${widget.token}';

    request.fields.addAll({
      'Type': '0',
      'IccId': iccidList.first,
      'NationalIdentificationNumber': cin!,
      'SellPointId': '2040',
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507',
      'DateEnvoi': DateTime.now().toIso8601String(),
    });

    request.files.add(await http.MultipartFile.fromPath(
      'Standard_NationalIdentificationNumberFrontImage',
      compressedFront.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'Standard_NationalIdentificationNumberBackImage',
      compressedBack.path,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'Standard_ContratImage',
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

  Widget buildIccidList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: iccidList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(iccidList[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                iccidList.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  Widget buildImageColumn(String label, File? image, VoidCallback onPressed) {
    return Column(
      children: [
        Text(label),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: onPressed),
        if (image != null)
          Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: const Color.fromARGB(255, 207, 82, 36),
          title: Text('Nouvelle Vente', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: const Color.fromARGB(255, 207, 92, 16),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Standard'),
              Tab(text: 'Portabilité'),
              Tab(text: 'Étranger'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Numéro CIN'),
                  TextField(
                    onChanged: (value) {
                      cin = value;
                    },
                    decoration: InputDecoration(hintText: 'Entrez le numéro CIN'),
                  ),
                  SizedBox(height: 20),

                  Text('ICCID (max 5)'),
                  ElevatedButton.icon(
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text('Scanner ICCID'),
                    onPressed: scanIccid,
                  ),
                  SizedBox(height: 10),
                  buildIccidList(),

                  SizedBox(height: 20),
                  Text('Photos'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildImageColumn('CIN Avant', cinFrontImage, () => pickImage('front')),
                      buildImageColumn('CIN Arrière', cinBackImage, () => pickImage('back')),
                      buildImageColumn('Contrat', contractImage, () => pickImage('contract')),
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
            Container(), // Onglet Portabilité : redirection via listener
            Container(), // Onglet Étranger : à implémenter ou appeler un autre widget
          ],
        ),

        // Bouton flottant avec redirection vers SimAirportEtrangerScreen
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EtrangerSimScreen(token: widget.token),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 207, 82, 36),
        ),
      ),
    );
  }
}
