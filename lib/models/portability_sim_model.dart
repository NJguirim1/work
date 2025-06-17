class PortabilitySimSaleModel {
  final int type;
  final String iccId;
  final String nationalIdNumber;
  final String portabilityNumber;
  final String passportNumber;
  final String sellPointId;
  final String latitude;
  final String longitude;
  final String city;
  final String country;
  final String portabilityNationalIdentificationNumberFrontImage;
  final String portabilityNationalIdentificationNumberBackImage;
  final String portabilityRioSignatureImage;
  final String portabilityRioSignatureImage2;
  final String portabilityNumberImage;
  final String portabilityContratImage;
  final String inChargeSupervisorId;
  final String dateEnvoi;

  PortabilitySimSaleModel({
    required this.type,
    required this.iccId,
    required this.nationalIdNumber,
    required this.portabilityNumber,
    required this.passportNumber,
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.portabilityNationalIdentificationNumberFrontImage,
    required this.portabilityNationalIdentificationNumberBackImage,
    required this.portabilityRioSignatureImage,
    required this.portabilityRioSignatureImage2,
    required this.portabilityNumberImage,
    required this.portabilityContratImage,
    required this.inChargeSupervisorId,
    required this.dateEnvoi,
  });

  Map<String, dynamic> toJson() => {
        "Type": type,
        "IccId": iccId,
        "NationalIdentificationNumber": nationalIdNumber,
        "PortabilityNumber": portabilityNumber,
        "PassportNumber": passportNumber,
        "SellPointId": sellPointId,
        "Latitude": latitude,
        "Longitude": longitude,
        "City": city,
        "Country": country,
        "Portability_NationalIdentificationNumberFrontImage": portabilityNationalIdentificationNumberFrontImage,
        "Portability_NationalIdentificationNumberBackImage": portabilityNationalIdentificationNumberBackImage,
        "Portability_RioSignatureImage": portabilityRioSignatureImage,
        "Portability_RioSignatureImage2": portabilityRioSignatureImage2,
        "Portability_NumberImage": portabilityNumberImage,
        "Portability_ContratImage": portabilityContratImage,
        "InChargeSupervisorId": inChargeSupervisorId,
        "DateEnvoi": dateEnvoi,
      };

  static fromJson(Map<String, Object> saleData) {}
}
