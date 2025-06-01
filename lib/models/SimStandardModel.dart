class SimSale {
  int type; // toujours 0 pour standard
  String iccId;
  String nationalIdNumber;
  String passportNumber; // vide pour standard
  String sellPointId;
  String latitude;
  String longitude;
  String city;
  String country;
  String inChargeSupervisorId;
  String dateEnvoi;

  SimSale({
    required this.type,
    required this.iccId,
    required this.nationalIdNumber,
    this.passportNumber = '',
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.inChargeSupervisorId,
    required this.dateEnvoi,
  });
}
