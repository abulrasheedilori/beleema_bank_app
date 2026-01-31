import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/security/secure_storage.dart';
import '../../auth/data/dto/api_response.dart';
import '../../auth/data/dto/login_error_response.dart';

class TransferRepository {
  final Dio _dio = DioClient.dio;

  /// Perform transfer
  /// Returns new balance on success
  Future<ApiResponse> transfer({
    required double amount,
    required String toAccount,
    required String pin,
  }) async {
    try {
      final token = await SecureStorage.read('auth_token');

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
      return ApiResponse.success(transferData); // always ApiResponse
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final error = LoginErrorResponse.fromJson(e.response!.data);
        return ApiResponse.failure(error.message);
      }
      return ApiResponse.failure('Network error');
    }
  }
}
