class SimSaleEtranger {
  final int type = 2; // Fixe pour "Étranger"
  final String iccId;
  final String passportNumber; // Peut être vide
  final String sellPointId;
  final String latitude;
  final String longitude;
  final String city;
  final String country;
  final String inChargeSupervisorId;
  final String dateEnvoi;

  SimSaleEtranger({
    required this.iccId,
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
