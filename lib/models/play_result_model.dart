class PlayResult {
  final bool hasWon;
  final int giftId;

  PlayResult({
    required this.hasWon,
    required this.giftId,
  });

  factory PlayResult.fromJson(Map<String, dynamic> json) {
    return PlayResult(
      hasWon: json['HasWon'],
      giftId: json['GiftId'],
    );
  }
}
