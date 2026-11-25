import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/home/data/home_repository.dart';
import '../../../features/system/presentation/account_locked_screen.dart';
import '../data/account_security_repository.dart';

class SecurityHubScreen extends ConsumerStatefulWidget {
  const SecurityHubScreen({this.previewOnly = false, super.key});

  final bool previewOnly;

  @override
  ConsumerState<SecurityHubScreen> createState() => _SecurityHubScreenState();
}

class _SecurityHubScreenState extends ConsumerState<SecurityHubScreen> {
  bool _submitting = false;

  Future<void> _lockAccount() async {
    if (widget.previewOnly || _submitting) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Lock your account?'),
        content: const Text(
          'Locking restricts debits and card use while allowing credits. '
          'To restore access, the documented flow requires identity checks '
          'with an OTP and selfie. In-app account recovery is not available yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Continue to PIN'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final pin = await showDialog<String>(
      context: context,
      builder: (dialogContext) => const _SecurityPinDialog(),
    );
    if (pin == null || !mounted) return;
    setState(() => _submitting = true);
    try {
      final token =
          await ref.read(homeRepositoryProvider).verifyTransactionPin(pin);
      await ref
          .read(accountSecurityRepositoryProvider)
          .lockOwnAccount(pinToken: token);
      if (!mounted) return;
      context.go(
        '/account-locked',
        extra: const AccountRestrictionContext(
          reason: AccountRestrictionReason.selfLock,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not lock your account. Check your connection and try again.',
          ),
        ),
      );
    }
  }

  void _showPreviewNotice() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Preview only'),
        content: const Text(
          'This screen preview will not request a PIN or lock an account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Security & privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          if (widget.previewOnly)
            const Card(
              child: ListTile(
                leading: Icon(Icons.visibility_outlined),
                title: Text('Screen preview only'),
                subtitle:
                    Text('No security settings or account state are changed.'),
              ),
            ),
          Card(
            color: colors.primaryContainer,
            child: const ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text('Protect your account'),
              subtitle: Text(
                'Review account access and lock the account if you suspect '
                'unauthorised activity.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('ACCOUNT ACCESS', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              minVerticalPadding: 14,
              leading: CircleAvatar(
                backgroundColor: colors.errorContainer,
                child: Icon(Icons.lock_outline, color: colors.error),
              ),
              title: const Text('Lock my account'),
              subtitle: const Text(
                'Restrict debits and cards; incoming credits remain available.',
              ),
              trailing: _submitting
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _submitting
                  ? null
                  : widget.previewOnly
                      ? _showPreviewNotice
                      : _lockAccount,
            ),
          ),
          const SizedBox(height: 14),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Other security settings'),
              subtitle: Text(
                'Passcode and PIN changes, biometrics, and linked-device '
                'management need their approved change and device flows.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityPinDialog extends StatefulWidget {
  const _SecurityPinDialog();

  @override
  State<_SecurityPinDialog> createState() => _SecurityPinDialogState();
}

class _SecurityPinDialogState extends State<_SecurityPinDialog> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length >= 4) return;
    setState(() => _pin += digit);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Enter transaction PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirm it is you before locking your account.'),
            const SizedBox(height: 16),
            Semantics(
              label: '${_pin.length} of 4 PIN digits entered',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      index < _pin.length
                          ? Icons.circle
                          : Icons.circle_outlined,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final row in const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final digit in row)
                    _PinDigitButton(
                        digit: digit, onPressed: () => _addDigit(digit)),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Clear PIN',
                  onPressed:
                      _pin.isEmpty ? null : () => setState(() => _pin = ''),
                  icon: const Icon(Icons.clear),
                ),
                _PinDigitButton(digit: '0', onPressed: () => _addDigit('0')),
                IconButton(
                  tooltip: 'Delete last digit',
                  onPressed: _pin.isEmpty
                      ? null
                      : () => setState(
                          () => _pin = _pin.substring(0, _pin.length - 1)),
                  icon: const Icon(Icons.backspace_outlined),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed:
                _pin.length == 4 ? () => Navigator.pop(context, _pin) : null,
            child: const Text('Verify PIN'),
          ),
        ],
      );
}

class _PinDigitButton extends StatelessWidget {
  const _PinDigitButton({required this.digit, required this.onPressed});

  final String digit;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 64,
        height: 52,
        child: TextButton(
          onPressed: onPressed,
          child: Text(digit, style: Theme.of(context).textTheme.titleLarge),
        ),
      );
}
