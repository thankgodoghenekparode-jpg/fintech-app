import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CardPrivacyService {
  CardPrivacyService._();

  static const _channel = MethodChannel('yourapp/card_privacy');
  static bool _initialized = false;
  static VoidCallback? onCaptureDetected;

  static Future<bool> enable() async {
    if (kIsWeb) return false;
    try {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'screenCaptureDetected') onCaptureDetected?.call();
      });
      _initialized = await _channel.invokeMethod<bool>('enable') ?? false;
      return _initialized;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> disable() async {
    if (!_initialized) return;
    _initialized = false;
    try {
      await _channel.invokeMethod<void>('disable');
    } on PlatformException {
      // Sensitive values are hidden by the caller regardless of native result.
    } on MissingPluginException {
      // The caller still clears the in-memory card details.
    }
  }
}
