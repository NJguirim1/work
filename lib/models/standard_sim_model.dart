class StandardSale  {
  String cin;
  List<String> iccids; // jusqu’à 5 ICCIDs
  String frontImageBase64;
  String backImageBase64;
  String contractImageBase64;

  StandardSale ({
    required this.cin,
    required this.iccids,
    required this.frontImageBase64,
    required this.backImageBase64,
    required this.contractImageBase64,
  });

  Map<String, dynamic> toJson() => {
    'Type': 0,
    'NationalIdentificationNumber': cin,
    'IccId': iccids.join(','),
    'Standard_NationalIdentificationNumberFrontImage': frontImageBase64,
    'Standard_NationalIdentificationNumberBackImage': backImageBase64,
    'Standard_ContratImage': contractImageBase64,
    // Autres champs obligatoires (SellPointId, Latitude, etc.)
  };
}