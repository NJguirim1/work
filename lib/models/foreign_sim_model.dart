class ForeignSimSaleModel {
  final int type;
  final String iccId;
  final String passportNumber;
  final String sellPointId;
  final String latitude;
  final String longitude;
  final String city;
  final String country;
  final String foreignPassportImage1;
  final String foreignPassportImage2;
  final String foreignContratImage;
  final String inChargeSupervisorId;
  final String dateEnvoi;

  ForeignSimSaleModel({
    required this.type,
    required this.iccId,
    required this.passportNumber,
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.foreignPassportImage1,
    required this.foreignPassportImage2,
    required this.foreignContratImage,
    required this.inChargeSupervisorId,
    required this.dateEnvoi,
  });

  Map<String, dynamic> toJson() => {
        "Type": type,
        "IccId": iccId,
        "PassportNumber": passportNumber,
        "SellPointId": sellPointId,
        "Latitude": latitude,
        "Longitude": longitude,
        "City": city,
        "Country": country,
        "Foreign_PassportImage1": foreignPassportImage1,
        "Foreign_PassportImage2": foreignPassportImage2,
        "Foreign_ContratImage": foreignContratImage,
        "InChargeSupervisorId": inChargeSupervisorId,
        "DateEnvoi": dateEnvoi,
      };
}
