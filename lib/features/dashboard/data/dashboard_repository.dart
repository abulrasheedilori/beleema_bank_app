import 'package:beleema_bank_app/features/dashboard/data/models/account_model.dart';
import 'package:beleema_bank_app/features/dashboard/data/models/transaction_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/security/secure_storage.dart';

class DashboardRepository {
  final Dio _dio = DioClient.dio;

  Future<AccountModel> getAccountDetails() async {
    final token = await SecureStorage.read('auth_token');

    final response = await _dio.get(
      '/api/get-account-details',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return AccountModel.fromJson(response.data);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final token = await SecureStorage.read('auth_token');

    final response = await _dio.get(
      '/api/get-transactions',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final List list = response.data;

    return list.map((json) => TransactionModel.fromJson(json)).toList();
  }
}
