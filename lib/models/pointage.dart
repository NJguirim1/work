class Pointage {
  final int id;
  final int idAgent;
  final double latitude;
  final double longitude;
  final DateTime pointageDate;

  Pointage({
    required this.id,
    required this.idAgent,
    required this.latitude,
    required this.longitude,
    required this.pointageDate,
  });

  factory Pointage.fromJson(Map<String, dynamic> json) {
    return Pointage(
      id: json['Id'] ?? 0,
      idAgent: json['IdAgent'] ?? 0,
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      pointageDate: DateTime.parse(json['PointageDate']),
    );
  }

  String get time => pointageDate.toLocal().toIso8601String().substring(11, 16);

  String get location => 'Lat: $latitude, Long: $longitude';
}
