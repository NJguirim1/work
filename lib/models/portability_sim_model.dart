class PortabiliteSimSale {
  int type; // 1 pour portabilité
  String iccId;
  String nationalIdNumber; // CIN
  String portabilityNumber; // numéro de portabilité
  String sellPointId;
  String latitude;
  String longitude;
  String city;
  String country;
  String inChargeSupervisorId;
  String dateEnvoi;

 
  String passportNumber = ''; // vide

  PortabiliteSimSale({
    this.type = 1, // toujours 1 pour portabilité
    required this.iccId,
    required this.nationalIdNumber,
    required this.portabilityNumber,
    required this.sellPointId,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.inChargeSupervisorId,
    required this.dateEnvoi,
  });
}
