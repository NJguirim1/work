class SimModel {
  String cinNumber;
  String dateEmission;
  int state;
  String contratNumber;
  String telephoneNumber;
  String pvName;
  String nameUserCentrale;

  SimModel({
    required this.cinNumber,
    required this.dateEmission,
    required this.state,
    required this.contratNumber,
    required this.telephoneNumber,
    required this.pvName,
    required this.nameUserCentrale,
  });

  factory SimModel.fromJson(Map<String, dynamic> json) {
    return SimModel(
      cinNumber: json['CinNumber'] ?? 'Non disponible',
      dateEmission: json['DateEmission'] ?? 'Non disponible',
      state: json['State'] ?? 0,
      contratNumber: json['ContratNumber'] ?? 'Non disponible',
      telephoneNumber: json['TelephoneNumber'] ?? 'Non disponible',
      pvName: json['PvName'] ?? 'Non disponible',
      nameUserCentrale: json['NameUserCentrale'] ?? 'Non disponible',
    );
  }
}
