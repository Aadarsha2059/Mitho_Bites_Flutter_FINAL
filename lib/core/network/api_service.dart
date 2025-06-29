import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:fooddelivery_b/app/shared_pref/token_shared_prefs.dart';

class ApiService {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  Dio get dio => _dio;

  ApiService(this._dio, this._tokenSharedPrefs) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

    // Add request interceptor to include auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from shared preferences
          final tokenResult = await _tokenSharedPrefs.getToken();
          tokenResult.fold(
            (failure) {
              // No token available, continue without auth
              handler.next(options);
            },
            (token) {
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          );
        },
      ),
    );
  }
}