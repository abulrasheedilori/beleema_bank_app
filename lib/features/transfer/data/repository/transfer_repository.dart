import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/security/secure_storage.dart';
import '../../../auth/data/dto/api_response.dart';
import '../../../auth/data/dto/login_error_response.dart';

class TransferRepository {
  final Dio _dio;
  final SecureStorage secureStorage;

  TransferRepository(this._dio, this.secureStorage);

  Future<ApiResponse> transfer({
    required double amount,
    required String toAccount,
    required String pin,
  }) async {
    try {
      final token = await secureStorage.read('auth_token');

      final response = await _dio.post(
        '/api/transfer',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: jsonEncode({
          'amount': amount,
          'toAccount': toAccount,
          'pin': pin,
        }),
      );

      final transferData = TransferData.fromJson(response.data);
      return ApiResponse.success(transferData);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final error = LoginErrorResponse.fromJson(e.response?.data);
        return ApiResponse.failure(error.message);
      }
      return ApiResponse.failure('Network error');
    }
  }
}
