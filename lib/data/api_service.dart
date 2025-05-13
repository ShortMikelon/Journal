import 'dart:developer';

import 'package:dio/dio.dart';

import 'api/api_client.dart';

class ApiService {
  static final Dio _dio = Dio()
    ..options.responseType = ResponseType.json
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('[REQUEST] ${options.method} ${options.uri}');
          log('Headers: ${options.headers}');
          log('Body: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('[RESPONSE] ${response.statusCode} ${response.requestOptions
              .uri}');
          log('Response data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('[ERROR] ${e.response?.statusCode} ${e.requestOptions.uri}');
          log('Message: ${e.message}');
          log('Data: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );

  static final ApiClient _client = ApiClient(_dio);

  static ApiClient get client => _client;
}