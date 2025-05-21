
class Vente {
  final String type;
  final String iccid;
  final String nationalId;
  final String passportNumber;
  final String sellPointId;
  final String latitude;
  final String longitude;
  final String city;
  final String country;
  final String dateEnvoi;
  final String frontImage;
  final String backImage;
  final String contractImage;
  final String? supervisorId;

  Vente({
    required this.type,
    required this.iccid,
    required this.nationalId,
    required this.passportNumber,
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.dateEnvoi,
    required this.frontImage,
    required this.backImage,
    required this.contractImage,
    this.supervisorId,
  });

  
  Map<String, String> toMap() {
    return {
      'Type': type,
      'IccId': iccid,
      'NationalIdentificationNumber': nationalId,
      'PassportNumber': passportNumber,
      'SellPointId': sellPointId,
      'Latitude': latitude,
      'Longitude': longitude,
      'City': city,
      'Country': country,
      'DateEnvoi': dateEnvoi,
      'FrontImage': frontImage,
      'BackImage': backImage,
      'Standard_ContratImage': contractImage,
      if (supervisorId != null) 'InChargeSupervisorId': supervisorId!,
    };
  }
}
