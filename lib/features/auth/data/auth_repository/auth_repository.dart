import 'package:beleema_bank_app/core/security/secure_storage.dart';
import 'package:dio/dio.dart';

import '../dto/api_response.dart';
import '../dto/login_error_response.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorage secureStorage;

  AuthRepository(this._dio, this.secureStorage);

  Future<ApiResponse> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/api/login',
        data: {'username': username, 'password': password},
        options: Options(headers: {'skipAuthInterceptor': true}),
      );

      final data = LoginResponseData.fromJson(response.data);
      await secureStorage.write("auth_token", data.accessToken);

      return ApiResponse.success(data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final error = LoginErrorResponse.fromJson(e.response!.data);
        return ApiResponse.failure(error.message);
      }
      return ApiResponse.failure('Network error');
    }
  }
}
