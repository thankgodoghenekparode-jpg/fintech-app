import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/onboarding_repository.dart';

class PasscodeResetScreen extends ConsumerStatefulWidget {
  const PasscodeResetScreen({super.key});

  @override
  ConsumerState<PasscodeResetScreen> createState() =>
      _PasscodeResetScreenState();
}

class _PasscodeResetScreenState extends ConsumerState<PasscodeResetScreen> {
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
    if (!_validPhone(phone) || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(onboardingRepositoryProvider)
          .requestPasscodeResetOtp(phone);
      if (mounted) {
        setState(() {
          _requested = true;
          _code.clear();
        });
      }
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
      // Reset OTP tokens remain in memory and are never accepted as login
      // credentials. A reset API is required before changing a passcode.
      await ref.read(onboardingRepositoryProvider).verifyPasscodeResetOtp(
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
        title: Text(text.resetPasscodeTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.lock_reset_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 20),
            Text(text.resetPasscodeHeading,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(text.resetPasscodeExplanation),
            const SizedBox(height: 24),
            _RecoveryStep(
                number: 1, title: text.resetOtpStep, complete: _otpVerified),
            const SizedBox(height: 12),
            if (!_requested)
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: text.resetPhoneLabel,
                  hintText: '+2348012345678',
                  border: const OutlineInputBorder(),
                ),
              ),
            if (_requested && !_otpVerified)
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: text.resetOtpLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            if (_requested && !_otpVerified)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading ? null : _requestCode,
                  child: Text(text.resetResendCode),
                ),
              ),
            if (!_otpVerified && _error != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorCopy(text, _error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (!_otpVerified) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _loading
                      ? null
                      : _requested
                          ? (_code.text.length == 6 ? _verifyCode : null)
                          : (_validPhone(_phone.text) ? _requestCode : null),
                  child: _loading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _requested ? text.resetVerifyOtp : text.resetSendOtp),
                ),
              ),
            ],
            if (_otpVerified) ...[
              _RecoveryStep(
                number: 2,
                title: text.resetIdentityStep,
                complete: false,
              ),
              const SizedBox(height: 12),
              _NoticeCard(message: text.resetIdentityContractGap),
              const SizedBox(height: 16),
              _RecoveryStep(
                number: 3,
                title: text.resetNewPasscodeStep,
                complete: false,
              ),
            ],
            const SizedBox(height: 16),
            _NoticeCard(message: text.resetHoldPolicyGap),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.arrow_back),
              label: Text(text.commonBack),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryStep extends StatelessWidget {
  const _RecoveryStep({
    required this.number,
    required this.title,
    required this.complete,
  });

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

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
}

bool _validPhone(String value) {
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
