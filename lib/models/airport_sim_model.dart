import 'sale_model.dart';

class AirportSimModel extends SaleModel {
  String? cin;
  String? passportNumber;
  String iccId;
  int type;

  String? frontCinImage;
  String? backCinImage;
  String? contractImage;

  AirportSimModel({
    this.cin,
    this.passportNumber,
    required this.iccId,
    required this.type,
    this.frontCinImage,
    this.backCinImage,
    this.contractImage,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'cin': cin,
      'passportNumber': passportNumber,
      'iccId': iccId,
      'type': type,
      'frontCinImage': frontCinImage,
      'backCinImage': backCinImage,
      'contractImage': contractImage,
    };
  }

  factory AirportSimModel.fromJson(Map<String, dynamic> json) {
    return AirportSimModel(
      cin: json['cin'],
      passportNumber: json['passportNumber'],
      iccId: json['iccId'],
      type: json['type'],
      frontCinImage: json['frontCinImage'],
      backCinImage: json['backCinImage'],
      contractImage: json['contractImage'],
    );
  }
}
