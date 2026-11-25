import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';
import '../../../core/formatting/money_amount.dart';
import '../../../core/network/api_client.dart';
import '../../../core/security/pin_entry_dialog.dart';
import '../data/target_savings_repository.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _deposit = TextEditingController();
  final _form = GlobalKey<FormState>();
  int _step = 0;
  String _mode = 'FLEXIBLE';
  String _theme = 'General';
  DateTime? _targetDate;
  String _planFrequency = 'WEEKLY';
  bool _submitting = false;
  bool _created = false;
  bool _createAttempted = false;
  String? _idempotencyKey;
  String? _error;

  static const _steps = AppText.targetGoalSteps;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _deposit.dispose();
    super.dispose();
  }

  int? _amountInKobo(String value) =>
      parseNairaToKobo(value, maxKobo: maxSafeKobo);

  String? _validateAmount(String? value) =>
      _amountInKobo(value ?? '') == null ? AppText.targetAmountInvalid : null;

  void _next() {
    if (_step == 0 && !(_form.currentState?.validate() ?? false)) return;
    if (_step == 1 && _targetDate == null) {
      setState(() => _error = AppText.targetDateRequired);
      return;
    }
    if (_step == 3 && _deposit.text.isNotEmpty) {
      if (_amountInKobo(_deposit.text) == null) {
        setState(() => _error = AppText.targetDepositInvalid);
        return;
      }
    }
    if (_step < _steps.length - 1) {
      setState(() {
        _error = null;
        _step++;
      });
    }
  }

  Future<void> _submit() async {
    final targetKobo = _amountInKobo(_target.text);
    final depositKobo =
        _deposit.text.trim().isEmpty ? null : _amountInKobo(_deposit.text);
    if (_name.text.trim().length < 2 || targetKobo == null) {
      setState(() {
        _error = AppText.targetAmountInvalid;
        _step = 0;
      });
      return;
    }
    if (_deposit.text.trim().isNotEmpty && depositKobo == null) {
      setState(() {
        _error = AppText.targetDepositInvalid;
        _step = 3;
      });
      return;
    }
    if (_targetDate == null) {
      setState(() {
        _error = AppText.targetDateRequired;
        _step = 1;
      });
      return;
    }

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
      _createAttempted = true;
      _idempotencyKey ??= repository.newIdempotencyKey();
      await repository.createGoal(
        name: _name.text.trim(),
        targetKobo: targetKobo,
        mode: _mode,
        theme: _theme,
        pinToken: pinToken,
        idempotencyKey: _idempotencyKey!,
        targetDate: _formatDate(_targetDate!),
        firstDepositKobo: depositKobo,
      );
      if (mounted) setState(() => _created = true);
    } on ApiRequestFailure catch (failure) {
      if (mounted) {
        setState(() {
          if (failure.code != 'network_error') {
            _createAttempted = false;
            _idempotencyKey = null;
          }
          _error = switch (failure.code) {
            'authentication_required' => AppText.authMissing,
            'service_unavailable' => AppText.apiUnconfigured,
            'invalid_pin_response' => AppText.targetPinError,
            _ => AppText.targetCreateError,
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppText.targetCreateError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? today.add(const Duration(days: 30)),
      firstDate: tomorrow,
      lastDate: DateTime(today.year + 20),
    );
    if (date != null) setState(() => _targetDate = date);
  }

  int _periodsUntilTarget(DateTime targetDate) {
    final today = DateUtils.dateOnly(DateTime.now());
    final days = targetDate.difference(today).inDays;
    if (_planFrequency == 'DAILY') return days;
    if (_planFrequency == 'WEEKLY') return (days / 7).ceil();
    var months =
        (targetDate.year - today.year) * 12 + targetDate.month - today.month;
    if (targetDate.day < today.day) months--;
    return months < 1 ? 1 : months;
  }

  String? _contributionEstimate() {
    final targetKobo = _amountInKobo(_target.text);
    if (targetKobo == null || _targetDate == null) return null;
    final depositKobo =
        _deposit.text.trim().isEmpty ? 0 : (_amountInKobo(_deposit.text) ?? 0);
    final remaining = targetKobo - depositKobo;
    if (remaining <= 0) return '${AppText.currencySymbol}0.00';
    final periods = _periodsUntilTarget(_targetDate!);
    if (periods <= 0) return null;
    final perPeriodKobo = (remaining + periods - 1) ~/ periods;
    final naira = perPeriodKobo ~/ 100;
    final kobo = (perPeriodKobo % 100).toString().padLeft(2, '0');
    final whole = naira.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
        );
    return '${AppText.currencySymbol}$whole.$kobo';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_created) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppText.targetCreateSuccess)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Icon(Icons.check_circle_outline,
                    size: 64, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(AppText.targetCreateSuccess,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                AppText.targetCreateAutoSaveNotEnabled,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Submitted details',
                    style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _reviewRow('Goal', _name.text.trim()),
                    _reviewRow(
                      'Target',
                      '${AppText.currencySymbol}${_target.text.trim()}',
                    ),
                    _reviewRow('Theme', _theme),
                    _reviewRow(
                      'Target date',
                      _targetDate == null
                          ? AppText.targetNoDate
                          : MaterialLocalizations.of(context)
                              .formatMediumDate(_targetDate!),
                    ),
                    _reviewRow(
                      'Mode',
                      _mode == 'LOCKED' ? 'Locked' : 'Flexible',
                    ),
                    _reviewRow(
                      'First deposit',
                      _deposit.text.trim().isEmpty
                          ? AppText.targetNoDeposit
                          : '${AppText.currencySymbol}${_deposit.text.trim()}',
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
      canPop: !_createAttempted,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppText.createSavingsGoalTitle)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                  '${AppText.targetStep} ${_step + 1} of ${_steps.length}: ${_steps[_step]}',
                  style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: (_step + 1) / _steps.length),
              const SizedBox(height: 24),
              if (_step == 0) _goalStep(theme),
              if (_step == 1) _planStep(theme),
              if (_step == 2) _modeStep(theme),
              if (_step == 3) _fundingStep(theme),
              if (_step == 4) _reviewStep(theme),
              const SizedBox(height: 28),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                const SizedBox(height: 12),
              ],
              if (_step > 0)
                OutlinedButton(
                  onPressed:
                      _createAttempted ? null : () => setState(() => _step--),
                  child: const Text('Back'),
                ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _submitting
                    ? null
                    : _step == 4
                        ? _submit
                        : _next,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_step == 4
                        ? AppText.createTargetSavingsGoal
                        : AppText.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalStep(ThemeData theme) => Form(
        key: _form,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppText.targetGoalQuestion,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextFormField(
            controller: _name,
            maxLength: 40,
            decoration:
                const InputDecoration(labelText: AppText.targetGoalName),
            validator: (value) => (value?.trim().length ?? 0) < 2
                ? AppText.targetGoalNameInvalid
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _target,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
            ],
            decoration: const InputDecoration(
                labelText: AppText.targetAmount,
                prefixText: '${AppText.currencySymbol} '),
            validator: _validateAmount,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _theme,
            decoration: const InputDecoration(labelText: AppText.targetTheme),
            items: AppText.targetThemes
                .map((label) =>
                    DropdownMenuItem(value: label, child: Text(label)))
                .toList(),
            onChanged: (value) => setState(() => _theme = value ?? 'General'),
          ),
        ]),
      );

  Widget _planStep(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.targetDateQuestion,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          const Text(AppText.targetDateInfo),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(_targetDate == null
                ? AppText.targetDateAdd
                : MaterialLocalizations.of(context)
                    .formatMediumDate(_targetDate!)),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _planFrequency,
            decoration: const InputDecoration(
                labelText: AppText.targetPlanEstimateFrequency),
            items: const [
              DropdownMenuItem(value: 'DAILY', child: Text('Daily')),
              DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
              DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
            ],
            onChanged: (value) =>
                setState(() => _planFrequency = value ?? 'WEEKLY'),
          ),
          if (_contributionEstimate() case final estimate?) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppText.targetPlanEstimatePrefix}: $estimate',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    const Text(AppText.targetPlanEstimateInfo),
                  ],
                ),
              ),
            ),
          ],
        ],
      );

  Widget _modeStep(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.targetModeQuestion,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          _modeCard(
              'FLEXIBLE', AppText.targetFlexible, AppText.targetFlexibleInfo),
          const SizedBox(height: 12),
          _modeCard('LOCKED', AppText.targetLocked, AppText.targetLockedInfo),
          const SizedBox(height: 12),
          const Text(AppText.targetWithdrawalInfo),
        ],
      );

  Widget _modeCard(String value, String title, String detail) {
    final selected = _mode == value;
    return Semantics(
      button: true,
      selected: selected,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ListTile(
          onTap: () => setState(() => _mode = value),
          leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off),
          title: Text(title),
          subtitle: Text(detail),
        ),
      ),
    );
  }

  Widget _fundingStep(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.targetFundingPlan, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(AppText.targetAutoSaveUnavailable),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _deposit,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
            ],
            decoration: const InputDecoration(
              labelText: AppText.targetFirstDeposit,
              prefixText: '${AppText.currencySymbol} ',
              helperText: AppText.targetDepositPinInfo,
            ),
          ),
        ],
      );

  Widget _reviewStep(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.targetReview, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Card(
            child: Column(children: [
              _reviewRow('Goal', _name.text.trim()),
              _reviewRow(
                  'Target', '${AppText.currencySymbol}${_target.text.trim()}'),
              _reviewRow('Theme', _theme),
              _reviewRow(
                  'Target date',
                  _targetDate == null
                      ? AppText.targetNoDate
                      : MaterialLocalizations.of(context)
                          .formatMediumDate(_targetDate!)),
              if (_contributionEstimate() case final estimate?)
                _reviewRow(
                    '${AppText.targetPlanEstimatePrefix} (${_planFrequency.toLowerCase()})',
                    estimate),
              _reviewRow('Mode', _mode == 'LOCKED' ? 'Locked' : 'Flexible'),
              _reviewRow(
                  'Automatic saving', AppText.targetAutoSaveNotConfigured),
              _reviewRow(
                  'First deposit',
                  _deposit.text.trim().isEmpty
                      ? AppText.targetNoDeposit
                      : '${AppText.currencySymbol}${_deposit.text.trim()}'),
            ]),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              AppText.targetCreateNeedsPin,
            ),
          ),
        ],
      );

  Widget _reviewRow(String title, String value) => ListTile(
        dense: true,
        title: Text(title),
        trailing: Text(value, textAlign: TextAlign.end),
      );
}
