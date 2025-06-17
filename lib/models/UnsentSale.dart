import 'dart:convert';

class UnsentSale {
  String iccid;
  String cin;
  String frontCinImagePath;
  String backCinImagePath;
  String contractImagePath;
  DateTime dateTimeSaved;

  UnsentSale({
    required this.iccid,
    required this.cin,
    required this.frontCinImagePath,
    required this.backCinImagePath,
    required this.contractImagePath,
    required this.dateTimeSaved,
  });

  Map<String, dynamic> toMap() {
    return {
      'iccid': iccid,
      'cin': cin,
      'frontCinImagePath': frontCinImagePath,
      'backCinImagePath': backCinImagePath,
      'contractImagePath': contractImagePath,
      'dateTimeSaved': dateTimeSaved.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UnsentSale.fromMap(Map<String, dynamic> map) {
    return UnsentSale(
      iccid: map['iccid'],
      cin: map['cin'],
      frontCinImagePath: map['frontCinImagePath'],
      backCinImagePath: map['backCinImagePath'],
      contractImagePath: map['contractImagePath'],
      dateTimeSaved: DateTime.parse(map['dateTimeSaved']),
    );
  }

  factory UnsentSale.fromJson(String source) =>
      UnsentSale.fromMap(json.decode(source));
}
