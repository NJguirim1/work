class StandardSimModel {
  String cin;
  String iccId;
  String? frontImage;
  String? backImage;
  String? contractImage;
  int type;

  StandardSimModel({
    required this.cin,
    required this.iccId,
    this.frontImage,
    this.backImage,
    this.contractImage,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'IccId': iccId,
        'NationalIdentificationNumber': cin,
        'Type': type,
        'Standard_NationalIdentificationNumberFrontImage': frontImage,
        'Standard_NationalIdentificationNumberBackImage': backImage,
        'Standard_ContratImage': contractImage,
      };

  factory StandardSimModel.fromJson(Map<String, dynamic> json) {
    return StandardSimModel(
      cin: json['NationalIdentificationNumber'],
      iccId: json['IccId'],
      frontImage: json['Standard_NationalIdentificationNumberFrontImage'],
      backImage: json['Standard_NationalIdentificationNumberBackImage'],
      contractImage: json['Standard_ContratImage'],
      type: json['Type'],
    );
  }
}