import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final localSessionCleanupProvider = Provider<LocalSessionCleanup>(
  (ref) => LocalSessionCleanup(
    (key) => const FlutterSecureStorage().delete(key: key),
  ),
);

class LocalSessionCleanup {
  LocalSessionCleanup(this._deleteKey);

  static const keysClearedOnSignOut = <String>[
    'session.access_token',
    'session.refresh_token',
    'onboarding.session_token',
    'security.biometric_unlock_enabled',
  ];

  final Future<void> Function(String key) _deleteKey;

  /// Clears this device's session credentials but preserves its stable ID.
  Future<void> clearCurrentDeviceSession() async {
    Object? firstError;
    for (final key in keysClearedOnSignOut) {
      try {
        await _deleteKey(key);
      } catch (error) {
        firstError ??= error;
      }
    }
    if (firstError != null) {
      throw const LocalSessionCleanupException();
    }
  }
}

class LocalSessionCleanupException implements Exception {
  const LocalSessionCleanupException();
}
