import 'package:beleema_bank_app/core/config/app_config.dart';
import 'package:dio/dio.dart';

import '../navigation/app_navigator.dart';

class DioClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              // print(' REQUEST');
              // print('URI: ${options.uri}');
              // print('METHOD: ${options.method}');
              // print('BODY: ${options.data}');
              // handler.next(options);
            },
            onResponse: (response, handler) {
              // print(' RESPONSE');
              // print('STATUS: ${response.statusCode}');
              // print('DATA: ${response.data}');
              // handler.next(response);
            },
            onError: (DioException e, handler) {
              final statusCode = e.response?.statusCode;

              // print(' ERROR');
              // print('URI: ${e.requestOptions.uri}');
              // print('STATUS: $statusCode');
              // print('DATA: ${e.response?.data}');

              // Global 401 handling
              if (statusCode == 401) {
                // Optional: clear tokens/session here
                AppNavigator.goToLogin();
              }

              handler.next(e);
            },
          ),
        );
}
