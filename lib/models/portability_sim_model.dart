class PortabilitySimModel {
  String cin;
  String iccId;
  int type;
  String portabilityNumber;

  String? frontCinImage;
  String? backCinImage;
  String? rioSignatureImage;
  String? rioSignatureImage2;
  String? portabilityNumberImage;
  String? contractImage;

  PortabilitySimModel({
    required this.cin,
    required this.iccId,
    required this.type,
    required this.portabilityNumber,
    this.frontCinImage,
    this.backCinImage,
    this.rioSignatureImage,
    this.rioSignatureImage2,
    this.portabilityNumberImage,
    this.contractImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'cin': cin,
      'iccId': iccId,
      'type': type,
      'portabilityNumber': portabilityNumber,
      'frontCinImage': frontCinImage,
      'backCinImage': backCinImage,
      'rioSignatureImage': rioSignatureImage,
      'rioSignatureImage2': rioSignatureImage2,
      'portabilityNumberImage': portabilityNumberImage,
      'contractImage': contractImage,
    };
  }

  factory PortabilitySimModel.fromJson(Map<String, dynamic> json) {
    return PortabilitySimModel(
      cin: json['cin'],
      iccId: json['iccId'],
      type: json['type'],
      portabilityNumber: json['portabilityNumber'],
      frontCinImage: json['frontCinImage'],
      backCinImage: json['backCinImage'],
      rioSignatureImage: json['rioSignatureImage'],
      rioSignatureImage2: json['rioSignatureImage2'],
      portabilityNumberImage: json['portabilityNumberImage'],
      contractImage: json['contractImage'],
    );
  }
}
