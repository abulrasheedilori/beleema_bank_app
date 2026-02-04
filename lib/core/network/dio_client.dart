import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../navigation/navigation_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final navigation = ref.read(navigationServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
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
        handler.next(response);
      },
      onError: (DioException e, handler) {
        final statusCode = e.response?.statusCode;

        // print(' ERROR');
        // print('URI: ${e.requestOptions.uri}');
        // print('STATUS: $statusCode');
        // print('DATA: ${e.response?.data}');

        if (statusCode == 401) {
          navigation.goToLogin();
        }

        handler.next(e);
      },
    ),
  );

  return dio;
});
