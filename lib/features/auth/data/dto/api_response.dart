class ApiResponse {
  final bool success;
  final String? message;
  final dynamic data;

  ApiResponse._({required this.success, this.message, this.data});

  factory ApiResponse.success(dynamic data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.failure(String message) {
    return ApiResponse._(success: false, message: message);
  }
}

class LoginResponseData {
  final String accessToken;
  final bool hasPin;

  LoginResponseData({required this.accessToken, required this.hasPin});

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(
      accessToken: json['accessToken'] as String,
      hasPin: json['hasPin'] as bool,
    );
  }
}

class TransferData {
  final bool success;
  final double newBalance;

  TransferData({required this.success, required this.newBalance});

  factory TransferData.fromJson(Map<String, dynamic> json) {
    return TransferData(
      success: json['success'] as bool,
      newBalance: json['newBalance'] as double,
    );
  }
}
