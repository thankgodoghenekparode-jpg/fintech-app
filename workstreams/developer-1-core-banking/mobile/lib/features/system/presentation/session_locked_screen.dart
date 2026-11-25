import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../core/security/biometric_service.dart';
import '../../onboarding/data/onboarding_repository.dart';

class SessionLockedScreen extends ConsumerStatefulWidget {
  const SessionLockedScreen({this.previewOnly = false, super.key});

  final bool previewOnly;

  @override
  ConsumerState<SessionLockedScreen> createState() =>
      _SessionLockedScreenState();
}

class _SessionLockedScreenState extends ConsumerState<SessionLockedScreen> {
  final _identifierController = TextEditingController();
  String _passcode = '';
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _appendDigit(String digit) {
    if (_busy || _passcode.length == 6) return;
    setState(() {
      _passcode += digit;
      _error = null;
    });
  }

  Future<void> _unlockWithPasscode() async {
    if (_busy || _passcode.length != 6) return;
    if (widget.previewOnly) {
      _showPreviewMessage();
      return;
    }
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      setState(
          () => _error = 'Enter the phone number or email on your account.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(onboardingRepositoryProvider).login(
            identifier: identifier,
            passcode: _passcode,
          );
      if (mounted) context.go('/home');
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = _loginErrorMessage(error);
          _passcode = '';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _unlockWithBiometrics() async {
    if (_busy) return;
    if (widget.previewOnly) {
      _showPreviewMessage();
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(biometricEnrollmentServiceProvider)
          .authenticateForLogin(localizedReason: 'Unlock your YourApp session');
      if (!mounted) return;
      if (result == BiometricUnlockResult.authenticated) {
        await ref.read(onboardingRepositoryProvider).refreshSession();
        if (mounted) context.go('/home');
      } else if (result == BiometricUnlockResult.cancelled) {
        setState(() => _error =
            'Biometric unlock was cancelled. Try again or enter your passcode.');
      } else {
        ref.invalidate(biometricLoginAvailableProvider);
        setState(() =>
            _error = 'Biometric unlock is unavailable. Enter your passcode.');
      }
    } catch (error) {
      if (mounted) setState(() => _error = _loginErrorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _logout() async {
    if (!widget.previewOnly) {
      const storage = FlutterSecureStorage();
      try {
        await Future.wait([
          storage.delete(key: 'session.access_token'),
          storage.delete(key: 'session.refresh_token'),
        ]);
      } catch (_) {
        if (mounted) {
          setState(() => _error = 'Could not clear the saved session. Try again.');
        }
        return;
      }
    }
    if (mounted) context.go('/welcome');
  }

  void _showPreviewMessage() {
    setState(() {
      _error =
          'Preview only. Sign-in requires the approved authentication API.';
    });
  }

  String _loginErrorMessage(Object error) => switch (loginErrorKey(error)) {
        'login.error.locked' =>
          'Sign-in is temporarily locked. Contact support if you need help.',
        'login.error.device' =>
          'This device needs verification before you can sign in.',
        'login.error.credentials' =>
          'Those sign-in details were not accepted. Try again.',
        'login.error.biometricCancelled' => 'Biometric unlock was cancelled.',
        'login.error.sessionExpired' =>
          'Your saved session expired. Sign in with your passcode.',
        'onboarding.error.configuration' =>
          'Sign-in is unavailable until the API is configured.',
        'onboarding.error.rateLimited' =>
          'Too many attempts. Wait a moment and try again.',
        'onboarding.error.offline' =>
          'You are offline. Check your connection and try again.',
        _ => 'We could not unlock your session. Try again.',
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final biometricAvailable = widget.previewOnly ||
        ref
            .watch(biometricLoginAvailableProvider)
            .maybeWhen(data: (available) => available, orElse: () => false);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'YourApp',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.lock_clock_outlined, size: 18),
                  label: const Text('Session timed out'),
                ),
              ],
            ),
            if (widget.previewOnly) ...[
              const SizedBox(height: 8),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Screen preview only'),
                  subtitle: Text('No credentials are sent from this preview.'),
                ),
              ),
            ],
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colors.primaryContainer,
                      child: Icon(Icons.lock_outline, color: colors.primary),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your session was locked for your security. Sign in to continue.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: _identifierController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username],
              decoration: const InputDecoration(
                labelText: 'Phone number or email',
                border: OutlineInputBorder(),
              ),
            ),
            if (biometricAvailable) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _unlockWithBiometrics,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock with biometrics'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('ENTER 6-DIGIT PASSCODE'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    index < _passcode.length
                        ? Icons.circle
                        : Icons.circle_outlined,
                    size: 14,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.error),
              ),
            ],
            const SizedBox(height: 12),
            for (var row = 0; row < 3; row++)
              Row(
                children: [
                  for (var column = 1; column <= 3; column++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: _PasscodeKey(
                          label: '${row * 3 + column}',
                          onPressed: () => _appendDigit('${row * 3 + column}'),
                        ),
                      ),
                    ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    tooltip: 'Unlock with biometrics',
                    onPressed: biometricAvailable && !_busy
                        ? _unlockWithBiometrics
                        : null,
                    icon: const Icon(Icons.fingerprint),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: _PasscodeKey(
                        label: '0', onPressed: () => _appendDigit('0')),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    tooltip: 'Delete last digit',
                    onPressed: _passcode.isEmpty || _busy
                        ? null
                        : () => setState(() {
                              _passcode =
                                  _passcode.substring(0, _passcode.length - 1);
                              _error = null;
                            }),
                    icon: const Icon(Icons.backspace_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _passcode.length == 6 && !_busy
                    ? _unlockWithPasscode
                    : null,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Unlock session'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.go('/login/reset'),
                    child: const Text('Forgot passcode?'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: _busy ? null : _logout,
                    child: const Text('Switch account / Log out'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 18),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Your financial information stays hidden while your session is locked.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PasscodeKey extends StatelessWidget {
  const _PasscodeKey({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 58,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(label, style: Theme.of(context).textTheme.titleLarge),
        ),
      );
}
