class ForeignSaleModel {
  String iccId;
  String passportNumber;
  String sellPointId;
  String latitude;
  String longitude;
  String city;
  String country;
  String passportImage1Base64;
  String passportImage2Base64; // optional
  String contractImageBase64;
  String inChargeSupervisorId; // optional
  String dateEnvoi;

  ForeignSaleModel({
    required this.iccId,
    required this.passportNumber,
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.passportImage1Base64,
    required this.passportImage2Base64,
    required this.contractImageBase64,
    this.inChargeSupervisorId = '',
    required this.dateEnvoi,
  });

  Map<String, dynamic> toJson() => {
        "Type": 2,
        "IccId": iccId,
        "NationalIdentificationNumber": "",
        "PassportNumber": passportNumber,
        "SellPointId": sellPointId,
        "Latitude": latitude,
        "Longitude": longitude,
        "City": city,
        "Country": country,
        "Foreign_PassportImage1": passportImage1Base64,
        "Foreign_PassportImage2": passportImage2Base64,
        "Foreign_ContratImage": contractImageBase64,
        "InChargeSupervisorId": inChargeSupervisorId,
        "DateEnvoi": dateEnvoi,
      };

  factory ForeignSaleModel.fromJson(Map<String, dynamic> json) {
    return ForeignSaleModel(
      iccId: json["IccId"],
      passportNumber: json["PassportNumber"],
      sellPointId: json["SellPointId"],
      latitude: json["Latitude"],
      longitude: json["Longitude"],
      city: json["City"],
      country: json["Country"],
      passportImage1Base64: json["Foreign_PassportImage1"],
      passportImage2Base64: json["Foreign_PassportImage2"] ?? '',
      contractImageBase64: json["Foreign_ContratImage"],
      inChargeSupervisorId: json["InChargeSupervisorId"] ?? '',
      dateEnvoi: json["DateEnvoi"],
    );
  }
}
