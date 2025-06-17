class LoginModel {
  final String login; 
  final String password;
  final bool rememberMe;
  final String deviceId;
  final String deviceType;

  var token;

  LoginModel({
    required this.login,  
    required this.password,
    required this.rememberMe,
    required this.deviceId,
    required this.deviceType,
  });

  // Convert JSON to LoginModel
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      login: json['Login'] ?? '',  // Provide a default empty string if null
      password: json['Password'] ?? '', // Handle null with a default value
      rememberMe: json['RememberMe'] ?? false, // Default to false if null
      deviceId: json['DeviceId'] ?? '', // Handle null with a default value
      deviceType: json['DeviceType'] ?? '', // Handle null with a default value
    );
  }

 

  

  get userName => null;

  // Convert LoginModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'Login': login,  
      'Password': password,
      'RememberMe': rememberMe,
      'DeviceId': deviceId,
      'DeviceType': deviceType,
    };
  }
}
