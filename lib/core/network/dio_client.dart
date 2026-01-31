import 'package:beleema_bank_app/core/config/app_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  final String apiBaseUrl = AppConfig.apiBaseUrl;

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://testbank-one.vercel.app',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  // ..interceptors.add(
  //   InterceptorsWrapper(
  //     onRequest: (options, handler) {
  //       print(' REQUEST');
  //       print('URI: ${options.uri}');
  //       print('METHOD: ${options.method}');
  //       print('HEADERS: ${options.headers}');
  //       print('BODY: ${options.data}');
  //       handler.next(options);
  //     },
  //     onResponse: (response, handler) {
  //       print(' RESPONSE');
  //       print('URI: ${response.requestOptions.uri}');
  //       print('STATUS: ${response.statusCode}');
  //       print('DATA: ${response.data}');
  //       handler.next(response);
  //     },
  //     onError: (DioException e, handler) {
  //       print(' ERROR');
  //       print('URI: ${e.requestOptions.uri}');
  //       print('STATUS: ${e.response?.statusCode}');
  //       print('MESSAGE: ${e.message}');
  //       print('DATA: ${e.response?.data}');
  //       handler.next(e);
  //     },
  //   ),
  // );
}
