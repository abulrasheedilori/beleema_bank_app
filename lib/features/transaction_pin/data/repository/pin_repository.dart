import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../../../core/security/secure_storage.dart';

class PinRepository {
  final Dio dio;
  final SecureStorage secureStorage;

  PinRepository({required this.dio, required this.secureStorage});

  /// Simple SHA-256 hashing (demo only)
  String hashPin(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    return sha256.convert(bytes).toString();
  }

  /// Set Transaction PIN with Authorization
  Future<void> setTransactionPin(String pin) async {
    try {
      // Hash PIN for production: use proper salt per user/device.
      // final hashedPin = hashPin(pin, 'some_salt');

      // Get auth token from secure storage
      String? token = await secureStorage.read("auth_token");
      if (token == null) {
        throw Exception('Authentication token missing. Please login again.');
      }

      final response = await dio.post(
        '/api/set-transaction-pin',
        data: jsonEncode({'pin': pin}),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Failed to set PIN');
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
