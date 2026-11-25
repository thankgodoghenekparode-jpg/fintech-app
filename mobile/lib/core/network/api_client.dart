import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  const baseUrl = String.fromEnvironment('API_BASE_URL');
  const mockAccessToken = String.fromEnvironment('MOCK_API_ACCESS_TOKEN');
  return ApiClient(
    dio: Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    )),
    secureStorage: const FlutterSecureStorage(),
    mockAccessToken: mockAccessToken,
  );
});

class ApiClient {
  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    this.mockAccessToken = '',
  })  : _dio = dio,
        _secureStorage = secureStorage;

  static const _accessTokenKey = 'access_token';

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final String mockAccessToken;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String> headers = const {},
  }) =>
      _request(
        (options) => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
        ),
        headers,
      );

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, String> headers = const {},
    String? idempotencyKey,
    String? pinToken,
    String? tenantId,
  }) {
    final requestHeaders = <String, String>{...headers};
    if (idempotencyKey != null) {
      requestHeaders['Idempotency-Key'] = idempotencyKey;
    }
    if (pinToken != null) requestHeaders['X-Pin-Token'] = pinToken;
    if (tenantId != null) requestHeaders['X-Tenant-Id'] = tenantId;

    return _request(
      (options) => _dio.post<T>(path, data: data, options: options),
      requestHeaders,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, String> headers = const {},
    String? tenantId,
  }) {
    final requestHeaders = <String, String>{...headers};
    if (tenantId != null) requestHeaders['X-Tenant-Id'] = tenantId;
    return _request(
      (options) => _dio.patch<T>(path, data: data, options: options),
      requestHeaders,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, String> headers = const {},
    String? idempotencyKey,
    String? pinToken,
    String? tenantId,
  }) {
    final requestHeaders = <String, String>{...headers};
    if (idempotencyKey != null) {
      requestHeaders['Idempotency-Key'] = idempotencyKey;
    }
    if (pinToken != null) requestHeaders['X-Pin-Token'] = pinToken;
    if (tenantId != null) requestHeaders['X-Tenant-Id'] = tenantId;
    return _request(
      (options) => _dio.put<T>(path, data: data, options: options),
      requestHeaders,
    );
  }

  Future<Response<T>> _request<T>(
    Future<Response<T>> Function(Options options) send,
    Map<String, String> extraHeaders,
  ) async {
    if (_dio.options.baseUrl.isEmpty) {
      throw const ApiRequestFailure('service_unavailable');
    }
    final storedToken = await _secureStorage.read(key: _accessTokenKey);
    final baseUri = Uri.tryParse(_dio.options.baseUrl);
    final isLoopbackMockHost = baseUri != null &&
        const {'localhost', '127.0.0.1', '::1', '10.0.2.2'}
            .contains(baseUri.host);
    final token = storedToken?.isNotEmpty == true
        ? storedToken
        : isLoopbackMockHost && mockAccessToken.isNotEmpty
            ? mockAccessToken
            : null;
    if (token == null || token.isEmpty) {
      throw const ApiRequestFailure('authentication_required');
    }

    try {
      return await send(Options(headers: {
        'Authorization': 'Bearer $token',
        'X-Request-Id': _requestId(),
        ...extraHeaders,
      }));
    } on DioException catch (error) {
      final body = error.response?.data;
      final code = body is Map<String, dynamic> ? body['code'] : null;
      throw ApiRequestFailure(
        code is String ? code : _statusCode(error.response?.statusCode),
      );
    }
  }

  String _statusCode(int? statusCode) {
    if (statusCode == 401) return 'authentication_required';
    if (statusCode == 403) return 'forbidden';
    if (statusCode == 409) return 'conflict';
    if (statusCode == 422) return 'business_rule';
    return 'network_error';
  }

  String _requestId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}

class ApiRequestFailure implements Exception {
  const ApiRequestFailure(this.code);

  final String code;
}
