import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../services/session_manager.dart';

/// Production-ready API Client with automatic token management
/// Features:
/// - Automatic token injection via interceptor
/// - Token refresh on 401 errors
/// - Comprehensive error handling
/// - Clean architecture with no code duplication
class ApiClient {
  late final Dio _dio;
  final SessionManager _sessionManager;

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() : _sessionManager = SessionManager() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: 30000, // milliseconds for Dio v4
      receiveTimeout: 30000, // milliseconds for Dio v4
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  /// Setup all interceptors
  void _setupInterceptors() {
    // 1. Token injection interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _sessionManager.getToken();
          if (token != null && token.isNotEmpty) {
            // Add token as query parameter (Laravel pattern)
            options.queryParameters['api_token'] = token;
          }
          return handler.next(options);
        },
      ),
    );

    // 2. Token refresh interceptor (handles 401 errors)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            debugPrint('=== TOKEN EXPIRED - ATTEMPTING REFRESH ===');

            // Try to refresh token
            final refreshed = await _refreshToken();

            if (refreshed) {
              // Retry the failed request with new token
              try {
                final response = await _retry(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              // Refresh failed - user needs to login again
              debugPrint('Token refresh failed - session expired');
              await _sessionManager.clearSession();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // 3. Logging interceptor (debug mode only)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  /// Retry a failed request (used after token refresh)
  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Refresh expired token
  /// Returns true if refresh was successful
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _sessionManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('No refresh token available');
        return false;
      }

      // Call refresh endpoint
      final response = await _dio.post(
        'auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['api_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newToken != null) {
          await _sessionManager.saveToken(newToken);
          if (newRefreshToken != null) {
            await _sessionManager.saveRefreshToken(newRefreshToken);
          }
          debugPrint('Token refreshed successfully');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  /// GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data, // Dio handles JSON encoding automatically
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// PUT request
  Future<ApiResponse> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data, // Dio handles JSON encoding automatically
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Upload file (multipart)
  Future<ApiResponse> uploadFile(
    String endpoint,
    String filePath,
    String field, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        field: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Handle successful response
  ApiResponse _handleResponse(Response response) {
    // Check if response has success flag
    if (response.data is Map) {
      final success = response.data['success'];

      if (success == true) {
        return ApiResponse.success(response.data['data']);
      } else if (success == false) {
        return ApiResponse.error(
          response.data['message'] ?? 'Request failed',
        );
      }
    }

    // For responses without success flag, check status code
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return ApiResponse.success(response.data);
    }

    return ApiResponse.error('Unexpected response format');
  }

  /// Handle DioError with comprehensive error mapping (Dio v4)
  ApiResponse _handleError(DioError error) {
    debugPrint('=== API ERROR ===');
    debugPrint('Type: ${error.type}');
    debugPrint('Message: ${error.message}');
    debugPrint('Status Code: ${error.response?.statusCode}');

    // Handle by status code
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      // Try to extract error message from response
      String? serverMessage;
      if (data is Map && data['message'] != null) {
        serverMessage = data['message'];
      }

      // Map status codes to user-friendly messages
      switch (statusCode) {
        case 400:
          return ApiResponse.error(
            serverMessage ?? 'طلب غير صالح - Bad Request',
          );

        case 401:
          return ApiResponse.error(
            serverMessage ?? 'غير مصرح - Unauthorized',
          );

        case 403:
          return ApiResponse.error(
            serverMessage ?? 'ممنوع - Forbidden',
          );

        case 404:
          return ApiResponse.error(
            serverMessage ?? 'المورد غير موجود - Not Found',
          );

        case 422:
          return ApiResponse.error(
            serverMessage ?? 'بيانات غير صالحة - Validation Failed',
          );

        case 429:
          return ApiResponse.error(
            serverMessage ?? 'طلبات كثيرة جداً. حاول مرة أخرى لاحقاً',
          );

        case 500:
          return ApiResponse.error(
            serverMessage ?? 'خطأ في الخادم - Server Error',
          );

        case 503:
          return ApiResponse.error(
            serverMessage ?? 'الخدمة غير متوفرة - Service Unavailable',
          );

        default:
          return ApiResponse.error(
            serverMessage ?? 'خطأ في الخادم: $statusCode',
          );
      }
    }

    // Handle by error type (Dio v4)
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return ApiResponse.error(
          'انتهت مهلة الاتصال. تحقق من اتصالك بالإنترنت',
        );

      case DioErrorType.response:
        return ApiResponse.error(
          'خطأ في الاستجابة من الخادم',
        );

      case DioErrorType.cancel:
        return ApiResponse.error('تم إلغاء الطلب');

      case DioErrorType.other:
        return ApiResponse.error(
          'خطأ في الشبكة. تحقق من اتصالك بالإنترنت',
        );
    }
  }
}

/// API Response wrapper
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? errorMessage;

  ApiResponse._({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory ApiResponse.success(dynamic data) => ApiResponse._(
        success: true,
        data: data,
      );

  factory ApiResponse.error(String message) => ApiResponse._(
        success: false,
        errorMessage: message,
      );

  @override
  String toString() {
    if (success) {
      return 'ApiResponse.success(data: $data)';
    } else {
      return 'ApiResponse.error(message: $errorMessage)';
    }
  }
}
