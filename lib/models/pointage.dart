class Pointage {
  final String time;
  final String location;

  Pointage({required this.time, required this.location});

  factory Pointage.fromJson(Map<String, dynamic> json) {
    return Pointage(
      time: json['time'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
