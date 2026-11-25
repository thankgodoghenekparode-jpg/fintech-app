import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/biometric_service.dart';
import '../../../l10n/app_localizations.dart';

class BiometricsSetupScreen extends ConsumerStatefulWidget {
  const BiometricsSetupScreen({super.key});

  @override
  ConsumerState<BiometricsSetupScreen> createState() =>
      _BiometricsSetupScreenState();
}

class _BiometricsSetupScreenState extends ConsumerState<BiometricsSetupScreen> {
  bool _loading = false;
  bool _cancelled = false;

  Future<void> _enable() async {
    if (_loading) return;
    final text = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
      _cancelled = false;
    });
    try {
      final result = await ref
          .read(biometricEnrollmentServiceProvider)
          .enable(localizedReason: text.biometricSystemReason);
      if (!mounted) return;
      if (result == BiometricEnrollmentResult.enabled ||
          result == BiometricEnrollmentResult.unavailable) {
        context.go('/signup/status');
      } else {
        setState(() => _cancelled = true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _skip() {
    if (!_loading) context.go('/signup/status');
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              _skip();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(text.onboardingStepEight),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              CircleAvatar(
                radius: 44,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.fingerprint,
                  size: 48,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                text.biometricSetupTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                text.biometricSetupHelper,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                text.biometricSetupPrivacy,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              if (_cancelled) ...[
                const SizedBox(height: 16),
                Text(
                  text.biometricSetupCancelled,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.error),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _enable,
                  icon: _loading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.fingerprint),
                  label: Text(
                    _loading ? text.commonLoading : text.biometricSetupEnable,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: _loading ? null : _skip,
                  child: Text(text.biometricSetupSkip),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
