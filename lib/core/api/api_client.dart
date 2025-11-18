import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../../features/auth/services/auth_service.dart';

/// API Client for making HTTP requests to Laravel backend
/// Based on the old LaravelApiClient pattern but modernized
class ApiClient {
  late final Dio _dio;
  late final Options _optionsNetwork;
  late final Options _optionsCache;

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: 30000, // milliseconds for DIO v4
      receiveTimeout: 30000, // milliseconds for DIO v4
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Setup caching
    if (kIsWeb || kDebugMode) {
      // No cache in debug/web mode
      _optionsNetwork = Options();
      _optionsCache = Options();
    } else {
      // Cache for 3 days in production
      _dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
      _optionsNetwork = buildCacheOptions(
        ApiConfig.cacheDuration,
        forceRefresh: true,
      );
      _optionsCache = buildCacheOptions(
        ApiConfig.debugCacheDuration,
        forceRefresh: false,
      );
    }

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// Get query parameters with authentication token
  Map<String, dynamic> _getQueryParameters() {
    final authService = AuthService();
    final user = authService.currentState.user;

    if (user != null && user.id.isNotEmpty) {
      return {'api_token': user.id}; // Using user ID as token for now
    }
    return {};
  }

  /// Build full URI with query parameters
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final params = {...?queryParameters, ..._getQueryParameters()};
    return Uri.parse(ApiConfig.apiBaseUrl + endpoint)
        .replace(queryParameters: params);
  }

  /// GET request with caching
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool useCache = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      debugPrint('GET: $uri');

      final response = await _dio.getUri(
        uri,
        options: useCache ? _optionsCache : _optionsNetwork,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      debugPrint('POST: $uri');

      final response = await _dio.postUri(
        uri,
        data: data is Map ? json.encode(data) : data,
        options: _optionsNetwork,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  /// PUT request
  Future<ApiResponse> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      debugPrint('PUT: $uri');

      final response = await _dio.putUri(
        uri,
        data: data is Map ? json.encode(data) : data,
        options: _optionsNetwork,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      debugPrint('DELETE: $uri');

      final response = await _dio.deleteUri(
        uri,
        options: _optionsNetwork,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
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
      final uri = _buildUri(endpoint);
      debugPrint('UPLOAD: $uri');

      final formData = FormData.fromMap({
        field: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.postUri(
        uri,
        data: formData,
        options: _optionsNetwork,
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleError(e);
    }
  }

  /// Handle successful response
  ApiResponse _handleResponse(Response response) {
    if (response.data is Map && response.data['success'] == true) {
      return ApiResponse.success(response.data['data']);
    } else if (response.data is Map && response.data['success'] == false) {
      return ApiResponse.error(
        response.data['message'] ?? 'Request failed',
      );
    } else {
      // For responses without success flag, assume success if status is 2xx
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResponse.success(response.data);
      }
      return ApiResponse.error('Unexpected response format');
    }
  }

  /// Handle DIO errors (DIO v4 uses DioError)
  ApiResponse _handleError(DioError error) {
    String message = 'An error occurred';

    if (error.response != null) {
      // Server responded with error
      final data = error.response!.data;
      if (data is Map && data['message'] != null) {
        message = data['message'];
      } else {
        message = 'Server error: ${error.response!.statusCode}';
      }
    } else if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      message = 'Connection timeout. Please check your internet connection';
    } else if (error.type == DioErrorType.other) {
      message = 'Network error. Please check your internet connection';
    } else {
      message = error.message;
    }

    debugPrint('API Error: $message');
    return ApiResponse.error(message);
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
}
