class StandardSimModel {
  String cin;
  String iccId;
  String? frontImagePath;
  String? backImagePath;
  String? contractImagePath;

  StandardSimModel({
    required this.cin,
    required this.iccId,
    this.frontImagePath,
    this.backImagePath,
    this.contractImagePath,
  });
}
