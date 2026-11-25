import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricEnrollmentResult { enabled, unavailable, cancelled }

enum BiometricUnlockResult { authenticated, unavailable, cancelled }

abstract interface class BiometricEnrollmentService {
  Future<BiometricEnrollmentResult> enable({required String localizedReason});

  Future<bool> isLoginAvailable();

  Future<BiometricUnlockResult> authenticateForLogin({
    required String localizedReason,
  });
}

final biometricLoginAvailableProvider = FutureProvider<bool>(
  (ref) => ref.watch(biometricEnrollmentServiceProvider).isLoginAvailable(),
);

final biometricEnrollmentServiceProvider = Provider<BiometricEnrollmentService>(
  (ref) => PlatformBiometricEnrollmentService(
    LocalAuthentication(),
    const FlutterSecureStorage(),
  ),
);

class PlatformBiometricEnrollmentService implements BiometricEnrollmentService {
  PlatformBiometricEnrollmentService(this._authentication, this._storage);

  final LocalAuthentication _authentication;
  final FlutterSecureStorage _storage;

  @override
  Future<BiometricEnrollmentResult> enable({
    required String localizedReason,
  }) async {
    try {
      if (!await _authentication.canCheckBiometrics ||
          (await _authentication.getAvailableBiometrics()).isEmpty) {
        return BiometricEnrollmentResult.unavailable;
      }
      final authenticated = await _authentication.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (!authenticated) return BiometricEnrollmentResult.cancelled;
      await _storage.write(
        key: 'security.biometric_unlock_enabled',
        value: 'true',
      );
      return BiometricEnrollmentResult.enabled;
    } catch (_) {
      // Unsupported platforms and unavailable biometric hardware are optional.
      return BiometricEnrollmentResult.unavailable;
    }
  }

  @override
  Future<bool> isLoginAvailable() async {
    try {
      final optedIn =
          await _storage.read(key: 'security.biometric_unlock_enabled') ==
              'true';
      final refreshToken = await _storage.read(key: 'session.refresh_token');
      if (!optedIn || refreshToken == null || refreshToken.isEmpty) {
        return false;
      }
      return await _hasAvailableBiometrics();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<BiometricUnlockResult> authenticateForLogin({
    required String localizedReason,
  }) async {
    try {
      if (!await isLoginAvailable()) return BiometricUnlockResult.unavailable;
      final authenticated = await _authentication.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      return authenticated
          ? BiometricUnlockResult.authenticated
          : BiometricUnlockResult.cancelled;
    } catch (_) {
      return BiometricUnlockResult.unavailable;
    }
  }

  Future<bool> _hasAvailableBiometrics() async {
    try {
      return await _authentication.canCheckBiometrics &&
          (await _authentication.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
