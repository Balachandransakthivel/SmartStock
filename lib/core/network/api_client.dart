import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(_secureStorage),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: AppConstants.storageTokenKey, value: token);
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: AppConstants.storageTokenKey);
    await _secureStorage.delete(key: AppConstants.storageRefreshTokenKey);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: AppConstants.storageTokenKey);
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  _AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: AppConstants.storageTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _secureStorage.delete(key: AppConstants.storageTokenKey);
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🌐 REQUEST[${options.method}] => ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}');
    debugPrint('Message: ${err.message}');
    if (err.response?.data != null) {
      debugPrint('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please check your internet.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        
        if (data is Map && data.containsKey('message')) {
          message = data['message'].toString();
        } else {
          message = switch (statusCode) {
            400 => 'Invalid request. Please check your input.',
            401 => 'Session expired. Please login again.',
            403 => 'You do not have permission to perform this action.',
            404 => 'Resource not found.',
            422 => 'Validation failed. Please check your input.',
            500 => 'Server error. Please try again later.',
            _ => 'An unexpected error occurred.',
          };
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.unknown:
        message = 'An unexpected error occurred. Please try again.';
        break;
      default:
        message = 'An error occurred. Please try again.';
    }
    
    err = DioException(
      requestOptions: err.requestOptions,
      error: message,
      type: err.type,
      response: err.response,
    );
    
    handler.next(err);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

extension DioErrorExtension on DioException {
  ApiException toApiException() {
    return ApiException(
      message ?? 'Unknown error',
      statusCode: response?.statusCode,
      data: response?.data,
    );
  }
}