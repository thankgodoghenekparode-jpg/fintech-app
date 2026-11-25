import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';
import '../../../core/formatting/money_amount.dart';
import '../../../core/network/api_client.dart';
import '../../../core/security/pin_entry_dialog.dart';
import '../data/target_savings_repository.dart';

class TargetGoalTopUpScreen extends ConsumerStatefulWidget {
  const TargetGoalTopUpScreen({required this.goalId, super.key});

  final String goalId;

  @override
  ConsumerState<TargetGoalTopUpScreen> createState() =>
      _TargetGoalTopUpScreenState();
}

class _TargetGoalTopUpScreenState extends ConsumerState<TargetGoalTopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _submitting = false;
  bool _complete = false;
  bool _attempted = false;
  int _completedAmountKobo = 0;
  String? _idempotencyKey;
  String? _error;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int? _amountInKobo(String value) => parseNairaToKobo(value);

  String? _validateAmount(String? value) =>
      _amountInKobo(value ?? '') == null ? AppText.targetAmountInvalid : null;

  String _formatAmount(int kobo) {
    final whole = (kobo ~/ 100).toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
        );
    return '${AppText.currencySymbol}$whole.${(kobo % 100).toString().padLeft(2, '0')}';
  }

  Future<void> _submit() async {
    if (!RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(widget.goalId)) {
      setState(() => _error = AppText.targetTopUpError);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amountKobo = _amountInKobo(_amountController.text);
    if (amountKobo == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppText.targetTopUpConfirm),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatAmount(amountKobo),
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Text(AppText.targetTopUpConfirmInfo),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppText.targetPinCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(AppText.continueLabel)),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    final pin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PinEntryDialog(),
    );
    if (!mounted || pin == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repository = ref.read(targetSavingsRepositoryProvider);
      final pinToken = await repository.verifyPin(pin);
      _attempted = true;
      _idempotencyKey ??= repository.newIdempotencyKey();
      await repository.topUp(
        goalId: widget.goalId,
        amountKobo: amountKobo,
        pinToken: pinToken,
        idempotencyKey: _idempotencyKey!,
      );
      if (mounted) {
        setState(() {
          _completedAmountKobo = amountKobo;
          _complete = true;
        });
      }
    } on ApiRequestFailure catch (failure) {
      if (mounted) {
        setState(() {
          if (failure.code != 'network_error') {
            _attempted = false;
            _idempotencyKey = null;
          }
          _error = switch (failure.code) {
            'authentication_required' => AppText.authMissing,
            'service_unavailable' => AppText.apiUnconfigured,
            'invalid_pin_response' => AppText.targetPinError,
            'business_rule' => AppText.targetTopUpError,
            _ => AppText.targetTopUpError,
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppText.targetTopUpError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_complete) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppText.targetTopUpSuccess)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Icon(Icons.check_circle_outline,
                    size: 64, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(AppText.targetTopUpSuccess,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(AppText.targetTopUpSuccessInfo,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Submitted top-up',
                    style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  title: const Text(AppText.targetTopUpSubmittedAmount),
                  trailing: Text(
                    _formatAmount(_completedAmountKobo),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: () => context.go('/targets'),
                  child: const Text(AppText.done)),
            ],
          ),
        ),
      );
    }

    return PopScope<Object?>(
      canPop: !_attempted,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppText.targetTopUpTitle)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(AppText.targetTopUpTitle,
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Goal reference: ${widget.goalId}',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                enabled: !_attempted,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                ],
                decoration: const InputDecoration(
                  labelText: AppText.targetTopUpAmount,
                  prefixText: '${AppText.currencySymbol} ',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [500, 1000, 5000, 10000]
                    .map((amount) => ActionChip(
                          label: Text(_formatAmount(amount * 100)),
                          onPressed: _attempted
                              ? null
                              : () => setState(() =>
                                  _amountController.text = amount.toString()),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(AppText.targetTopUpBalanceUnavailable),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_attempted
                        ? AppText.targetTopUpRetry
                        : AppText.targetTopUpTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
