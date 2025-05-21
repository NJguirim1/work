class GamePlayRequest {
  final String playerIdentificationNumber;
  final int instanceId;
  final bool isNewMethod;

  GamePlayRequest({
    required this.playerIdentificationNumber,
    required this.instanceId,
    required this.isNewMethod,
  });

  Map<String, dynamic> toJson() => {
        'PlayerIdentificationNumber': playerIdentificationNumber,
        'InstanceId': instanceId,
        'IsNewMethod': isNewMethod,
      };
}

class GamePlayResponse {
  final bool success;
  final String message;
  final dynamic data;

  GamePlayResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory GamePlayResponse.fromJson(Map<String, dynamic> json) {
    return GamePlayResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
