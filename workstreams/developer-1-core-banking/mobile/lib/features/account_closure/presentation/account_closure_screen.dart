import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import '../data/account_closure_repository.dart';

class AccountClosureScreen extends ConsumerStatefulWidget {
  const AccountClosureScreen({this.previewOnly = false, super.key});

  final bool previewOnly;

  @override
  ConsumerState<AccountClosureScreen> createState() =>
      _AccountClosureScreenState();
}

class _AccountClosureScreenState extends ConsumerState<AccountClosureScreen> {
  final _feedback = TextEditingController();
  String? _reason;
  String? _error;
  ClosureRequest? _request;
  bool _submitting = false;
  String? _idempotencyKey;

  static const _reasons = <(String, String)>[
    ('OTHER_BANKING_SERVICE', 'I found another banking service'),
    ('MOVING_ABROAD', 'Moving abroad or no longer need a naira account'),
    ('FEES_OR_SERVICE', 'I am dissatisfied with charges or service'),
    ('TEMPORARY_CLOSURE', 'Temporary closure or opening another account'),
    ('OTHER', 'Other reason'),
  ];

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final eligibility = ref.read(closureEligibilityProvider).valueOrNull;
    if (eligibility == null ||
        !eligibility.eligible ||
        eligibility.blockers.isNotEmpty ||
        _reason == null) {
      return;
    }
    final pin = await _requestPin();
    if (pin == null || !mounted) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final pinToken =
          await ref.read(homeRepositoryProvider).verifyTransactionPin(pin);
      final result =
          await ref.read(accountClosureRepositoryProvider).submitRequest(
                reason: _reason!,
                feedback: _feedback.text,
                pinToken: pinToken,
                idempotencyKey: _idempotencyKey ??= _newIdempotencyKey(),
              );
      if (!mounted) return;
      setState(() {
        _request = result;
        _submitting = false;
        _idempotencyKey = null;
      });
      ref.invalidate(closureEligibilityProvider);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error =
            'We could not submit the closure request. Check your PIN and try again.';
      });
      ref.invalidate(closureEligibilityProvider);
    }
  }

  Future<String?> _requestPin() => showDialog<String>(
        context: context,
        builder: (context) => const _PinConfirmationDialog(),
      );

  String _newIdempotencyKey() {
    final random = Random.secure();
    final suffix =
        List.generate(20, (_) => random.nextInt(16).toRadixString(16)).join();
    return 'closure-${DateTime.now().toUtc().microsecondsSinceEpoch}-$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final eligibility = ref.watch(closureEligibilityProvider);
    final canSubmit = !widget.previewOnly &&
        eligibility.valueOrNull?.eligible == true &&
        eligibility.valueOrNull!.blockers.isEmpty &&
        _reason != null &&
        _request == null &&
        !_submitting;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Close account'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (widget.previewOnly)
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Demo preview - sample eligibility only'),
                subtitle: Text(
                    'No PIN is requested and no closure request can be submitted.'),
              ),
            ),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              leading: const Icon(Icons.heart_broken_outlined),
              title: const Text('We are sorry to see you go'),
              subtitle: const Text(
                  'Review your account and active products first. A request is reviewed by the bank; this screen does not close your account immediately.'),
            ),
          ),
          const SizedBox(height: 18),
          Text('Closure eligibility',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          eligibility.when(
            skipLoadingOnRefresh: true,
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, stack) => Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title:
                    const Text('Could not check account closure requirements.'),
                trailing: IconButton(
                  tooltip: text.commonRetry,
                  onPressed: () => ref.invalidate(closureEligibilityProvider),
                  icon: const Icon(Icons.refresh),
                ),
              ),
            ),
            data: (result) => _EligibilityCard(
              result: result,
              onAction: _openBlockerAction,
            ),
          ),
          const SizedBox(height: 18),
          Text('Reason for leaving (required)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Card(
            child: RadioGroup<String>(
              groupValue: _reason,
              onChanged: (value) {
                if (_request != null) return;
                setState(() {
                  _reason = value;
                  _idempotencyKey = null;
                });
              },
              child: Column(
                children: [
                  for (var index = 0; index < _reasons.length; index++) ...[
                    if (index > 0) const Divider(height: 1),
                    RadioListTile<String>(
                      value: _reasons[index].$1,
                      title: Text(_reasons[index].$2),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _feedback,
            enabled: _request == null,
            onChanged: (_) => _idempotencyKey = null,
            maxLength: 500,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Feedback (optional)',
              hintText: 'Share your experience or suggestions',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Review before submitting'),
              subtitle: const Text(
                  'Submitting sends a closure request for review. Your account remains open unless the bank later confirms closure.'),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          if (_request case final request?) ...[
            const SizedBox(height: 12),
            Card(
              color: request.status == 'BLOCKED'
                  ? Theme.of(context).colorScheme.errorContainer
                  : Theme.of(context).colorScheme.tertiaryContainer,
              child: ListTile(
                leading: Icon(request.status == 'BLOCKED'
                    ? Icons.block_outlined
                    : Icons.check_circle_outline),
                title: Text(request.status == 'BLOCKED'
                    ? 'Request blocked'
                    : 'Closure request submitted'),
                subtitle: Text('Reference: ${request.requestId}'),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: canSubmit ? _submit : null,
              icon: _submitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_outline),
              label: Text(
                  _submitting ? text.commonLoading : 'Submit closure request'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.previewOnly
                ? 'This preview uses sample eligibility data. Connect the backend to check a real account.'
                : 'Eligibility is rechecked when you submit. Your PIN is verified for this request only.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _openBlockerAction(ClosureBlocker blocker) {
    const allowedRoutes = {'/account-details', '/more/limits', '/help'};
    final route = blocker.actionRoute;
    if (route != null && allowedRoutes.contains(route)) context.push(route);
  }
}

class _EligibilityCard extends StatelessWidget {
  const _EligibilityCard({required this.result, required this.onAction});

  final ClosureEligibility result;
  final ValueChanged<ClosureBlocker> onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (result.blockers.isEmpty) {
      return Card(
        color:
            result.eligible ? colors.tertiaryContainer : colors.errorContainer,
        child: ListTile(
          leading: Icon(result.eligible
              ? Icons.check_circle_outline
              : Icons.info_outline),
          title: Text(result.eligible
              ? 'No closure blockers reported'
              : 'Closure eligibility is not confirmed'),
          subtitle: Text('Checked ${result.checkedAt.toLocal()}'),
        ),
      );
    }
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < result.blockers.length; index++) ...[
            if (index > 0) const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(result.blockers[index].title),
              subtitle: Text(result.blockers[index].detail),
              trailing: result.blockers[index].actionLabel == null
                  ? null
                  : TextButton(
                      onPressed: () => onAction(result.blockers[index]),
                      child: Text(result.blockers[index].actionLabel!),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PinConfirmationDialog extends StatefulWidget {
  const _PinConfirmationDialog();

  @override
  State<_PinConfirmationDialog> createState() => _PinConfirmationDialogState();
}

class _PinConfirmationDialogState extends State<_PinConfirmationDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Confirm with transaction PIN'),
        content: TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: '4-digit PIN',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _controller.text.length == 4
                ? () => Navigator.of(context).pop(_controller.text)
                : null,
            child: const Text('Verify PIN'),
          ),
        ],
      );
}
