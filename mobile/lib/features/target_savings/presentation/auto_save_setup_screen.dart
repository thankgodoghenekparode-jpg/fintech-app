import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';
import '../../../core/formatting/money_amount.dart';
import '../../../core/network/api_client.dart';
import '../../../core/security/pin_entry_dialog.dart';
import '../data/target_savings_repository.dart';

class AutoSaveSetupScreen extends ConsumerStatefulWidget {
  const AutoSaveSetupScreen({required this.goalId, super.key});

  final String goalId;

  @override
  ConsumerState<AutoSaveSetupScreen> createState() =>
      _AutoSaveSetupScreenState();
}

class _AutoSaveSetupScreenState extends ConsumerState<AutoSaveSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _frequency = 'WEEKLY';
  DateTime? _startDate;
  bool _consent = false;
  bool _saving = false;
  bool _saveAttempted = false;
  bool _saved = false;
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

  Future<void> _chooseStartDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? today.add(const Duration(days: 1)),
      firstDate: tomorrow,
      lastDate: DateTime(today.year + 20),
    );
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked;
        _error = null;
      });
    }
  }

  Future<void> _save() async {
    if (!RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(widget.goalId)) {
      setState(() => _error = AppText.targetAutoSaveError);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_startDate == null) {
      setState(() => _error = AppText.targetAutoSaveDateRequired);
      return;
    }
    if (!_consent) {
      setState(() => _error = AppText.targetAutoSaveConsentRequired);
      return;
    }

    final amountKobo = _amountInKobo(_amountController.text);
    if (amountKobo == null) return;
    final pin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PinEntryDialog(),
    );
    if (!mounted || pin == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repository = ref.read(targetSavingsRepositoryProvider);
      final pinToken = await repository.verifyPin(pin);
      _saveAttempted = true;
      _idempotencyKey ??= repository.newIdempotencyKey();
      await repository.setAutoSave(
        goalId: widget.goalId,
        frequency: _frequency,
        amountKobo: amountKobo,
        startDate: _formatDate(_startDate!),
        pinToken: pinToken,
        idempotencyKey: _idempotencyKey!,
      );
      if (mounted) setState(() => _saved = true);
    } on ApiRequestFailure catch (failure) {
      if (mounted) {
        setState(() {
          if (failure.code != 'network_error') {
            _saveAttempted = false;
            _idempotencyKey = null;
          }
          _error = switch (failure.code) {
            'authentication_required' => AppText.authMissing,
            'service_unavailable' => AppText.apiUnconfigured,
            'invalid_pin_response' => AppText.targetPinError,
            'TGT_INSUFFICIENT' => AppText.targetAutoSaveInsufficient,
            'business_rule' => AppText.targetAutoSaveError,
            _ => AppText.targetAutoSaveError,
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppText.targetAutoSaveError);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_saved) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppText.targetAutoSaveSuccess)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Icon(Icons.check_circle_outline,
                    size: 64, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(AppText.targetAutoSaveSuccess,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(AppText.targetAutoSaveSuccessInfo,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Submitted schedule',
                    style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: const Text(AppText.targetAutoSaveFrequency),
                      trailing: Text(switch (_frequency) {
                        'DAILY' => AppText.targetFrequencyDaily,
                        'MONTHLY' => AppText.targetFrequencyMonthly,
                        _ => AppText.targetFrequencyWeekly,
                      }),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(AppText.targetAutoSaveAmount),
                      trailing: Text(
                        '${AppText.currencySymbol}${_amountController.text.trim()}',
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(AppText.targetAutoSaveStartDate),
                      trailing: Text(MaterialLocalizations.of(context)
                          .formatMediumDate(_startDate!)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/targets'),
                child: const Text(AppText.done),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope<Object?>(
      canPop: !_saveAttempted,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppText.targetAutoSaveTitle)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(AppText.targetAutoSaveTitle,
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(AppText.targetAutoSaveConsentInfo),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _frequency,
                decoration: const InputDecoration(
                    labelText: AppText.targetAutoSaveFrequency),
                items: const [
                  DropdownMenuItem(
                      value: 'DAILY',
                      child: Text(AppText.targetFrequencyDaily)),
                  DropdownMenuItem(
                      value: 'WEEKLY',
                      child: Text(AppText.targetFrequencyWeekly)),
                  DropdownMenuItem(
                      value: 'MONTHLY',
                      child: Text(AppText.targetFrequencyMonthly)),
                ],
                onChanged: _saveAttempted
                    ? null
                    : (value) => setState(() {
                          _frequency = value ?? 'WEEKLY';
                          _error = null;
                        }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                enabled: !_saveAttempted,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: AppText.targetAutoSaveAmount,
                  prefixText: '${AppText.currencySymbol} ',
                ),
                validator: _validateAmount,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _saveAttempted ? null : _chooseStartDate,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(_startDate == null
                    ? AppText.targetAutoSaveStartDate
                    : MaterialLocalizations.of(context)
                        .formatMediumDate(_startDate!)),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _consent,
                onChanged: _saveAttempted
                    ? null
                    : (value) => setState(() {
                          _consent = value;
                          _error = null;
                        }),
                title: const Text(AppText.targetAutoSaveConsent),
                subtitle: const Text(AppText.targetAutoSaveConsentDetail),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(AppText.targetAutoSavePreviewUnavailable,
                      style: theme.textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_saveAttempted
                        ? AppText.targetRetry
                        : AppText.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
