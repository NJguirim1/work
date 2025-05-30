class Pointage {
  final String dateTime;
  final String location;

  Pointage({required this.dateTime, required this.location});

  factory Pointage.fromJson(Map<String, dynamic> json) {
    return Pointage(
      dateTime: json['dateTime'],
      location: json['location'],
    );
  }
}
