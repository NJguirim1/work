class SimModel {
  final int sellId;
  final int type;
  String cinNumber;
  String contratNumber;
  String? telephoneNumber;
  String? dateEmission;
  String? pvName;
  String? nameUserCentrale;
  String? pvId;
  int state;
  String? latitude;
  String? longitude;
  String? city;
  String? country;
  String? passportNumber;

  // Images
  String? frontCinImage;
  String? backCinImage;
  String? contractImage;

  String? portFrontCinImage;
  String? portBackCinImage;
  String? rioSignatureImage;
  String? rioSignatureImage2;
  String? portNumberImage;
  String? portContractImage;

  String? foreignPassportImage1;
  String? foreignPassportImage2;
  String? foreignContractImage;

  String? airportCinFront;
  String? airportCinBack;

  SimModel({
    required this.sellId,
    required this.type,
    required this.cinNumber,
    required this.contratNumber,
    this.telephoneNumber,
    this.dateEmission,
    this.pvName,
    this.nameUserCentrale,
    this.pvId,
    this.state = 1,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.passportNumber,
    this.frontCinImage,
    this.backCinImage,
    this.contractImage,
    this.portFrontCinImage,
    this.portBackCinImage,
    this.rioSignatureImage,
    this.rioSignatureImage2,
    this.portNumberImage,
    this.portContractImage,
    this.foreignPassportImage1,
    this.foreignPassportImage2,
    this.foreignContractImage,
    this.airportCinFront,
    this.airportCinBack,
  });

  factory SimModel.fromJson(Map<String, dynamic> json) {
    return SimModel(
      sellId: json['SellId'] is int
          ? json['SellId']
          : int.tryParse(json['SellId'].toString()) ?? 0,
      type: json['Type'] is int
          ? json['Type']
          : int.tryParse(json['Type'].toString()) ?? 0,
      cinNumber: json['NationalIdentificationNumber'] ?? '',
      contratNumber: json['IccId'] ?? '',
      telephoneNumber: json['TelephoneNumber'],
      dateEmission: json['DateEmission'],
      pvName: json['PvName'],
      nameUserCentrale: json['NameUserCentrale'],
      pvId: json['SellPointId'],
      state: json['State'] is int
          ? json['State']
          : int.tryParse(json['State']?.toString() ?? '') ?? 1,
      latitude: json['Latitude'] != null ? json['Latitude'].toString() : null,
      longitude: json['Longitude'] != null ? json['Longitude'].toString() : null,
      city: json['City'],
      country: json['Country'],
      passportNumber: json['PassportNumber'],
      frontCinImage: json['Standard_NationalIdentificationNumberFrontImage'],
      backCinImage: json['Standard_NationalIdentificationNumberBackImage'],
      contractImage: json['Standard_ContratImage'],
      portFrontCinImage: json['Portability_NationalIdentificationNumberFrontImage'],
      portBackCinImage: json['Portability_NationalIdentificationNumberBackImage'],
      rioSignatureImage: json['Portability_RioSignatureImage'],
      rioSignatureImage2: json['Portability_RioSignatureImage2'],
      portNumberImage: json['Portability_NumberImage'],
      portContractImage: json['Portability_ContratImage'],
      foreignPassportImage1: json['Foreign_PassportImage1'],
      foreignPassportImage2: json['Foreign_PassportImage2'],
      foreignContractImage: json['Foreign_ContratImage'],
      airportCinFront: json['Airport_NationalIdentificationNumberFrontImage'],
      airportCinBack: json['Airport_NationalIdentificationNumberBackImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "SellId": sellId,
      "Type": type,
      "NationalIdentificationNumber": cinNumber,
      "IccId": contratNumber,
      "TelephoneNumber": telephoneNumber ?? '',
      "DateEmission": dateEmission ?? '',
      "PvName": pvName ?? '',
      "NameUserCentrale": nameUserCentrale ?? '',
      "SellPointId": pvId ?? '',
      "State": state,
      "Latitude": latitude ?? '',
      "Longitude": longitude ?? '',
      "City": city ?? '',
      "Country": country ?? '',
      "PassportNumber": passportNumber ?? '',
      "Standard_NationalIdentificationNumberFrontImage": frontCinImage ?? '',
      "Standard_NationalIdentificationNumberBackImage": backCinImage ?? '',
      "Standard_ContratImage": contractImage ?? '',
      "Portability_NationalIdentificationNumberFrontImage": portFrontCinImage ?? '',
      "Portability_NationalIdentificationNumberBackImage": portBackCinImage ?? '',
      "Portability_RioSignatureImage": rioSignatureImage ?? '',
      "Portability_RioSignatureImage2": rioSignatureImage2 ?? '',
      "Portability_NumberImage": portNumberImage ?? '',
      "Portability_ContratImage": portContractImage ?? '',
      "Foreign_PassportImage1": foreignPassportImage1 ?? '',
      "Foreign_PassportImage2": foreignPassportImage2 ?? '',
      "Foreign_ContratImage": foreignContractImage ?? '',
      "Airport_NationalIdentificationNumberFrontImage": airportCinFront ?? '',
      "Airport_NationalIdentificationNumberBackImage": airportCinBack ?? '',
    };
  }
}
