class LoginErrorResponse {
  final bool error;
  final int statusCode;
  final String message;

  LoginErrorResponse({
    required this.error,
    required this.statusCode,
    required this.message,
  });

  factory LoginErrorResponse.fromJson(Map<String, dynamic> json) {
    return LoginErrorResponse(
      error: json['error'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
    );
  }
}
