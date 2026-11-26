import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageProvider),
  ),
);

final onboardingStatusProvider = FutureProvider<OnboardingStatusSnapshot>(
  (ref) => ref.watch(onboardingRepositoryProvider).getOnboardingStatus(),
);

final signupPhoneProvider = StateProvider<String?>((ref) => null);
final signupPasscodeProvider = StateProvider<String?>((ref) => null);
final onboardingProfileDraftProvider = StateProvider<OnboardingProfileDraft?>(
  (ref) => null,
);

String? onboardingRouteForNextStep(String? nextStep) {
  if (nextStep == null || nextStep.isEmpty) return '/signup/details';
  const allowedRoutes = {
    '/signup/details',
    '/signup/consent',
    '/signup/bvn',
    '/signup/nin',
    '/signup/selfie',
    '/signup/passcode',
    '/signup/pin',
    '/signup/biometrics',
    '/signup/status',
  };
  return allowedRoutes.contains(nextStep) ? nextStep : null;
}

String? onboardingRouteForResumeStep(String? step) {
  if (step == null || step.isEmpty) return null;
  return onboardingRouteForNextStep(step);
}

class OnboardingProfileDraft {
  const OnboardingProfileDraft({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    this.referralCode,
  });

  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String email;
  final String? referralCode;
}

enum OnboardingAccountState {
  onboarding,
  pendingAccount,
  active,
  manualReview,
  rejected
}

class OnboardingStatusSnapshot {
  const OnboardingStatusSnapshot({
    required this.state,
    required this.step,
    required this.accountNumber,
  });

  final OnboardingAccountState state;
  final String? step;
  final String? accountNumber;

  factory OnboardingStatusSnapshot.fromJson(Map<String, dynamic> json) {
    final rawState = json['status'];
    final state = switch (rawState) {
      'ONBOARDING' => OnboardingAccountState.onboarding,
      'PENDING_ACCOUNT' => OnboardingAccountState.pendingAccount,
      'ACTIVE' => OnboardingAccountState.active,
      'MANUAL_REVIEW' => OnboardingAccountState.manualReview,
      'REJECTED' => OnboardingAccountState.rejected,
      _ => throw const UnsupportedOnboardingStatusException(),
    };
    return OnboardingStatusSnapshot(
      state: state,
      step: json['step'] as String?,
      accountNumber: json['accountNumber'] as String?,
    );
  }
}

class OnboardingRepository {
  OnboardingRepository(this._api, this._storage);

  final ApiClient _api;
  final FlutterSecureStorage _storage;

  Future<void> requestSignupOtp(String phone) async {
    await _api.dio.post<void>(
      'auth/otp/request',
      data: {'phone': phone, 'purpose': 'SIGNUP'},
    );
  }

  Future<void> requestNewDeviceOtp(String phone) async {
    await _api.dio.post<void>(
      'auth/otp/request',
      data: {'phone': phone, 'purpose': 'LOGIN_NEW_DEVICE'},
    );
  }

  /// Verify the OTP without persisting the restricted verification token as a
  /// normal onboarding or authenticated customer session.
  Future<String> verifyNewDeviceOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'auth/otp/verify',
      data: {
        'phone': phone,
        'code': code,
        'purpose': 'LOGIN_NEW_DEVICE',
      },
    );
    final token = response.data?['sessionToken'];
    if (token is! String || token.isEmpty) {
      throw const MissingOnboardingSessionException();
    }
    return token;
  }

  // CB-ONB-003: send the validated BVN only to its documented verification API.
  Future<void> verifyBvn(String bvn) async {
    await _api.dio.post<void>('onboarding/bvn', data: {'bvn': bvn});
  }

  // CB-ONB-004: send the validated NIN only to its documented verification API.
  Future<void> verifyNin(String nin) async {
    await _api.dio.post<void>('onboarding/nin', data: {'nin': nin});
  }

  // CB-ONB-006: credentials are submitted together as the API requires.
  Future<void> setCredentials({required String passcode, required String pin}) {
    return _api.dio.post<void>(
      'onboarding/credentials',
      data: {'passcode': passcode, 'pin': pin},
    );
  }

  Future<OnboardingStatusSnapshot> getOnboardingStatus() async {
    final response = await _api.dio.get<Map<String, dynamic>>(
      'onboarding/status',
    );
    final data = response.data;
    if (data == null) throw const UnsupportedOnboardingStatusException();
    return OnboardingStatusSnapshot.fromJson(data);
  }

  Future<String?> verifySignupOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _api.dio.post<Map<String, dynamic>>(
      'auth/otp/verify',
      data: {'phone': phone, 'code': code, 'purpose': 'SIGNUP'},
    );
    final token = response.data?['sessionToken'] as String?;
    if (token == null || token.isEmpty) {
      throw const MissingOnboardingSessionException();
    }
    await _storage.write(key: 'onboarding.session_token', value: token);
    return response.data?['nextStep'] as String?;
  }

  Future<void> login({
    required String identifier,
    required String passcode,
  }) async {
    var deviceId = await _storage.read(key: 'security.device_id');
    if (deviceId == null) {
      deviceId = _newDeviceId();
      await _storage.write(key: 'security.device_id', value: deviceId);
    }
    final response = await _api.dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {'identifier': identifier, 'passcode': passcode},
      options: Options(headers: {'X-Device-Id': deviceId}),
    );
    final accessToken = response.data?['accessToken'] as String?;
    final refreshToken = response.data?['refreshToken'] as String?;
    if (accessToken == null || refreshToken == null) {
      throw const MissingOnboardingSessionException();
    }
    await _storage.write(key: 'session.access_token', value: accessToken);
    await _storage.write(key: 'session.refresh_token', value: refreshToken);
  }

  Future<void> refreshSession() async {
    final refreshToken = await _storage.read(key: 'session.refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const InvalidStoredSessionException();
    }
    try {
      final response = await _api.dio.post<Map<String, dynamic>>(
        'auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final accessToken = response.data?['accessToken'] as String?;
      final rotatedRefreshToken = response.data?['refreshToken'] as String?;
      if (accessToken == null ||
          accessToken.isEmpty ||
          rotatedRefreshToken == null ||
          rotatedRefreshToken.isEmpty) {
        throw const MissingOnboardingSessionException();
      }
      await _storage.write(key: 'session.access_token', value: accessToken);
      await _storage.write(
        key: 'session.refresh_token',
        value: rotatedRefreshToken,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _storage.delete(key: 'session.access_token');
        await _storage.delete(key: 'session.refresh_token');
        throw const InvalidStoredSessionException();
      }
      rethrow;
    }
  }

  String _newDeviceId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}

sealed class OnboardingFailure implements Exception {
  const OnboardingFailure();
}

class MissingOnboardingSessionException extends OnboardingFailure {
  const MissingOnboardingSessionException();
}

class InvalidStoredSessionException extends OnboardingFailure {
  const InvalidStoredSessionException();
}

class UnsupportedOnboardingStepException extends OnboardingFailure {
  const UnsupportedOnboardingStepException();
}

class UnsupportedOnboardingStatusException extends OnboardingFailure {
  const UnsupportedOnboardingStatusException();
}

String onboardingErrorKey(Object error) {
  if (error is ApiConfigurationException) {
    return 'onboarding.error.configuration';
  }
  if (error is MissingOnboardingSessionException) {
    return 'onboarding.error.unexpected';
  }
  if (error is UnsupportedOnboardingStepException) {
    return 'onboarding.error.resumeUnsupported';
  }
  if (error is UnsupportedOnboardingStatusException) {
    return 'onboarding.error.statusUnsupported';
  }
  if (error is DioException) {
    final responseData = error.response?.data;
    final code =
        responseData is Map<String, dynamic> ? responseData['code'] : null;
    if (code == 'OTP_INVALID' || code == 'OTP_EXPIRED') {
      return 'onboarding.error.otpInvalid';
    }
    if (code == 'KYC_REJECTED') return 'onboarding.error.kycRejected';
    if (code == 'KYC_MISMATCH') return 'onboarding.error.kycMismatch';
    if (code == 'KYC_PROVIDER_UNAVAILABLE') {
      return 'onboarding.error.kycUnavailable';
    }
    if (error.response?.statusCode == 429 || code == 'OTP_RATE_LIMITED') {
      return 'onboarding.error.rateLimited';
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'onboarding.error.offline';
    }
    if (error.response?.statusCode == 503 || code == 'SYSTEM_UNAVAILABLE') {
      return 'onboarding.error.kycUnavailable';
    }
  }
  return 'onboarding.error.unexpected';
}

String loginErrorKey(Object error) {
  if (error is InvalidStoredSessionException) {
    return 'login.error.sessionExpired';
  }
  if (error is ApiConfigurationException) {
    return 'onboarding.error.configuration';
  }
  if (error is DioException) {
    final responseData = error.response?.data;
    final code =
        responseData is Map<String, dynamic> ? responseData['code'] : null;
    if (code == 'AUTH_LOCKED') return 'login.error.locked';
    if (code == 'AUTH_DEVICE_NOT_TRUSTED') return 'login.error.device';
    if (code == 'AUTH_INVALID_CREDENTIALS' ||
        error.response?.statusCode == 401) {
      return 'login.error.credentials';
    }
    if (error.response?.statusCode == 429) {
      return 'onboarding.error.rateLimited';
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'onboarding.error.offline';
    }
  }
  return 'onboarding.error.unexpected';
}
