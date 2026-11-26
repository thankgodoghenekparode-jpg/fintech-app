import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/onboarding_repository.dart';

class NewDeviceVerificationScreen extends ConsumerStatefulWidget {
  const NewDeviceVerificationScreen({super.key});

  @override
  ConsumerState<NewDeviceVerificationScreen> createState() =>
      _NewDeviceVerificationScreenState();
}

class _NewDeviceVerificationScreenState
    extends ConsumerState<NewDeviceVerificationScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  bool _requested = false;
  bool _loading = false;
  bool _otpVerified = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    final phone = _phone.text.trim();
    if (!_validNigerianPhone(phone) || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(onboardingRepositoryProvider).requestNewDeviceOtp(phone);
      if (!mounted) return;
      setState(() {
        _requested = true;
        _code.clear();
      });
    } catch (error) {
      if (mounted) setState(() => _error = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    if (_code.text.length != 6 || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Keep the restricted OTP session token in memory only. The current API
      // does not define the liveness session exchange or device-trust result.
      await ref.read(onboardingRepositoryProvider).verifyNewDeviceOtp(
            phone: _phone.text.trim(),
            code: _code.text,
          );
      if (mounted) setState(() => _otpVerified = true);
    } catch (error) {
      if (mounted) setState(() => _error = onboardingErrorKey(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.newDeviceTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.phonelink_lock_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 20),
            Text(text.newDeviceHeading,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(text.newDeviceExplanation),
            const SizedBox(height: 24),
            _StepLabel(
              number: 1,
              title: text.newDeviceOtpStep,
              complete: _otpVerified,
            ),
            if (!_otpVerified) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                enabled: !_requested && !_loading,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                decoration: InputDecoration(
                  labelText: text.newDevicePhoneLabel,
                  hintText: '+2348012345678',
                  border: const OutlineInputBorder(),
                ),
              ),
              if (_requested) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _code,
                  enabled: !_loading,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: text.newDeviceCodeLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _loading ? null : _requestCode,
                    child: Text(text.newDeviceResendAction),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorCopy(text, _error!),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _loading
                      ? null
                      : _requested
                          ? (_code.text.length == 6 ? _verifyCode : null)
                          : (_validNigerianPhone(_phone.text)
                              ? _requestCode
                              : null),
                  child: _loading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_requested
                          ? text.newDeviceVerifyAction
                          : text.newDeviceSendAction),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              _StepLabel(
                number: 2,
                title: text.newDeviceLivenessStep,
                complete: false,
              ),
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 12),
                      Expanded(child: Text(text.newDeviceLivenessGap)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.arrow_back),
                label: Text(text.commonBack),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel(
      {required this.number, required this.title, required this.complete});

  final int number;
  final String title;
  final bool complete;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          CircleAvatar(
            radius: 16,
            child:
                complete ? const Icon(Icons.check, size: 18) : Text('$number'),
          ),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleMedium)),
        ],
      );
}

bool _validNigerianPhone(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  return digits.length >= 10 && digits.length <= 13;
}

String _errorCopy(AppLocalizations text, String key) => switch (key) {
      'onboarding.error.rateLimited' => text.errorRateLimited,
      'onboarding.error.otpInvalid' => text.errorOtpInvalid,
      'onboarding.error.offline' => text.errorOffline,
      'onboarding.error.configuration' => text.errorConfiguration,
      _ => text.errorUnexpected,
    };
