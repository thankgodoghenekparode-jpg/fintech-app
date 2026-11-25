import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient.fromEnvironment(),
);

class ApiClient {
  ApiClient(this.dio);

  final Dio dio;

  factory ApiClient.fromEnvironment() {
    const baseUrl = String.fromEnvironment('API_BASE_URL');
    if (baseUrl.isEmpty) {
      throw const ApiConfigurationException();
    }
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl.endsWith('/') ? baseUrl : '$baseUrl/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {'Accept': 'application/json'},
      ),
    );
    return ApiClient.withTokenReader(
      dio,
      (key) => const FlutterSecureStorage().read(key: key),
    );
  }

  factory ApiClient.withTokenReader(
    Dio dio,
    Future<String?> Function(String key) readToken,
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path.startsWith('/')
              ? options.path.substring(1)
              : options.path;
          const publicAuthOperations = {
            'auth/otp/request',
            'auth/otp/verify',
            'auth/login',
            'auth/refresh',
          };
          if (publicAuthOperations.contains(path)) {
            handler.next(options);
            return;
          }
          final accessToken = await readToken('session.access_token');
          final onboardingToken = await readToken('onboarding.session_token');
          final token = options.path.startsWith('onboarding/')
              ? onboardingToken
              : accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    return ApiClient(dio);
  }
}

class ApiConfigurationException implements Exception {
  const ApiConfigurationException();
}
