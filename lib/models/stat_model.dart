class StatModel {
  final String username;
  final int avecRecharge;
  final int rechargeInitSeulement;
  final int fraude;
  final int firstCall;
  final int sansRecharge;
  final int total;
  final int fcr;
  final double fcrPercent;

  StatModel({
    required this.username,
    required this.avecRecharge,
    required this.rechargeInitSeulement,
    required this.fraude,
    required this.firstCall,
    required this.sansRecharge,
    required this.total,
    required this.fcr,
    required this.fcrPercent,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) {
    return StatModel(
      username: json['username'] ?? '',
      avecRecharge: json['avecRecharge'] ?? 0,
      rechargeInitSeulement: json['rechargeInitSeulement'] ?? 0,
      fraude: json['fraude'] ?? 0,
      firstCall: json['firstCall'] ?? 0,
      sansRecharge: json['sansRecharge'] ?? 0,
      total: json['total'] ?? 0,
      fcr: json['fcr'] ?? 0,
      fcrPercent: (json['fcrPercent'] ?? 0).toDouble(),
    );
  }
}
