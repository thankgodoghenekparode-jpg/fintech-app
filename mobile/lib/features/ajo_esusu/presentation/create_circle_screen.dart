import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';
import '../../../core/formatting/money_amount.dart';
import '../../../core/network/api_client.dart';
import '../data/ajo_repository.dart';

class CreateCircleScreen extends ConsumerStatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  ConsumerState<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends ConsumerState<CreateCircleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _slotsController = TextEditingController(text: '5');
  int _step = 0;
  String _frequency = 'WEEKLY';
  String _orderMethod = 'RANDOM';
  String _protectionMode = 'PROTECTED';
  DateTime _startDate = _today();
  bool _submitting = false;
  bool _created = false;
  bool _creationUncertain = false;
  String? _error;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _slotsController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_step == 0 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_step < 3) {
      setState(() {
        _error = null;
        _step++;
      });
    } else {
      _submit();
    }
  }

  Future<void> _chooseStartDate() async {
    final today = _today();
    final selected = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 60)),
    );
    if (selected != null && mounted) setState(() => _startDate = selected);
  }

  Future<void> _submit() async {
    final amountKobo = _amountToKobo(_amountController.text);
    final slots = int.tryParse(_slotsController.text);
    if (amountKobo == null ||
        slots == null ||
        slots < 2 ||
        !(_formKey.currentState?.validate() ?? false)) {
      setState(() => _step = 0);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(ajoRepositoryProvider).createCircle(
            name: _nameController.text.trim(),
            amountKobo: amountKobo,
            frequency: _frequency,
            slots: slots,
            startDate: _dateForApi(_startDate),
            orderMethod: _orderMethod,
            protectionMode: _protectionMode,
          );
      if (mounted) setState(() => _created = true);
    } on ApiRequestFailure catch (failure) {
      if (mounted) {
        setState(() {
          _creationUncertain = failure.code == 'network_error';
          _error = failure.code == 'authentication_required'
              ? AppText.authMissing
              : failure.code == 'service_unavailable'
                  ? AppText.apiUnconfigured
                  : failure.code == 'network_error'
                      ? AppText.circleCreateStatusUnknown
                      : AppText.circleCreateError;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppText.circleCreateError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final potEstimateKobo = _estimatedPotKobo();
    final finalRoundEstimate = _estimatedFinalRound();
    if (_created) return _success(context);
    if (_creationUncertain) return _creationStatusUnknown(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.createCircle),
        leading: IconButton(
          tooltip: AppText.back,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/ajo'),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _step,
            onStepContinue: _submitting ? null : _continue,
            onStepCancel: _step == 0
                ? null
                : () => setState(() {
                      _error = null;
                      _step--;
                    }),
            controlsBuilder: (context, details) => Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error != null) ...[
                    Text(
                      _error!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      FilledButton(
                        onPressed: details.onStepContinue,
                        child: Text(
                          _submitting
                              ? AppText.submitting
                              : _step == 3
                                  ? AppText.submit
                                  : AppText.continueLabel,
                        ),
                      ),
                      if (_step > 0) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text(AppText.back),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            steps: [
              Step(
                title: const Text(AppText.circleDetails),
                isActive: _step >= 0,
                content: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 60,
                      decoration: const InputDecoration(
                        labelText: AppText.circleName,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final length = value?.trim().length ?? 0;
                        return length >= 3 && length <= 60
                            ? null
                            : AppText.circleNameInvalid;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      onChanged: (_) => setState(() {}),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: AppText.roundContribution,
                        prefixText: '${AppText.currencySymbol} ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final amount = _amountToKobo(value ?? '');
                        return amount != null && amount > 0
                            ? null
                            : AppText.roundContributionInvalid;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _frequency,
                      decoration: const InputDecoration(
                        labelText: AppText.frequencyLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'DAILY',
                          child: Text(AppText.frequencyDaily),
                        ),
                        DropdownMenuItem(
                          value: 'WEEKLY',
                          child: Text(AppText.frequencyWeekly),
                        ),
                        DropdownMenuItem(
                          value: 'MONTHLY',
                          child: Text(AppText.frequencyMonthly),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        _frequency = value ?? _frequency;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _slotsController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: AppText.slotsLabel,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final slots = int.tryParse(value ?? '');
                        return slots != null && slots >= 2
                            ? null
                            : AppText.slotsInvalid;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _chooseStartDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          '${AppText.startDateLabel}: ${_dateForDisplay(_startDate)}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _planEstimate(),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppText.trustLimitInfo),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(AppText.payoutProtection),
                isActive: _step >= 1,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.protectionLabel,
                        style: Theme.of(context).textTheme.titleSmall),
                    RadioGroup<String>(
                      groupValue: _protectionMode,
                      onChanged: (value) => setState(
                        () => _protectionMode = value ?? 'PROTECTED',
                      ),
                      child: const Column(
                        children: [
                          RadioListTile<String>(
                            value: 'PROTECTED',
                            title: Text(AppText.protectedMode),
                          ),
                          RadioListTile<String>(
                            value: 'SAFEGUARDS_ONLY',
                            title: Text(AppText.safeguardsOnly),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _protectionMode == 'PROTECTED'
                          ? AppText.protectedInfo
                          : AppText.safeguardsInfo,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(AppText.payoutOrder),
                isActive: _step >= 2,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(AppText.orderStepInfo),
                    const SizedBox(height: 8),
                    RadioGroup<String>(
                      groupValue: _orderMethod,
                      onChanged: (value) => setState(
                        () => _orderMethod = value ?? 'RANDOM',
                      ),
                      child: const Column(
                        children: [
                          RadioListTile<String>(
                            value: 'RANDOM',
                            title: Text(AppText.orderRandom),
                          ),
                          RadioListTile<String>(
                            value: 'CHOSEN',
                            title: Text(AppText.orderChosen),
                          ),
                          RadioListTile<String>(
                            value: 'ORGANIZER',
                            title: Text(AppText.orderOrganizer),
                          ),
                        ],
                      ),
                    ),
                    if (_orderMethod == 'ORGANIZER') ...[
                      const SizedBox(height: 8),
                      const Text(AppText.orderOrganizerConsent),
                    ],
                  ],
                ),
              ),
              Step(
                title: const Text(AppText.circleReview),
                isActive: _step >= 3,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReviewRow(
                      label: AppText.circleName,
                      value: _nameController.text,
                    ),
                    _ReviewRow(
                      label: AppText.contributionDetails,
                      value:
                          '${AppText.currencySymbol} ${_amountController.text} · ${_frequencyLabel(_frequency)}',
                    ),
                    _ReviewRow(
                      label: AppText.memberCount,
                      value: _slotsController.text,
                    ),
                    _ReviewRow(
                      label: AppText.circlePotEstimate,
                      value: potEstimateKobo == null
                          ? 'Unavailable'
                          : _formatKobo(potEstimateKobo),
                    ),
                    _ReviewRow(
                      label: AppText.circleDurationEstimate,
                      value: finalRoundEstimate == null
                          ? 'Unavailable'
                          : _dateForDisplay(finalRoundEstimate),
                    ),
                    _ReviewRow(
                      label: AppText.startDateReview,
                      value: _dateForDisplay(_startDate),
                    ),
                    _ReviewRow(
                      label: AppText.orderReview,
                      value: _orderLabel(_orderMethod),
                    ),
                    _ReviewRow(
                      label: AppText.protectionReview,
                      value: _protectionMode == 'PROTECTED'
                          ? AppText.protectedMode
                          : AppText.safeguardsOnly,
                    ),
                    const SizedBox(height: 12),
                    const Text(AppText.circleCreateInfo),
                    const SizedBox(height: 8),
                    const Text(AppText.platformNoGuarantee),
                    const SizedBox(height: 8),
                    Text(
                      _protectionMode == 'PROTECTED'
                          ? AppText.protectedInfo
                          : AppText.safeguardsInfo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _success(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(AppText.createCircle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 56),
                const SizedBox(height: 16),
                Text(
                  AppText.circleCreated,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppText.circleCreatedInfo,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      _ReviewRow(
                        label: AppText.circleName,
                        value: _nameController.text.trim(),
                      ),
                      _ReviewRow(
                        label: AppText.contributionDetails,
                        value: '${AppText.currencySymbol} '
                            '${_amountController.text} '
                            '· ${_frequencyLabel(_frequency)}',
                      ),
                      _ReviewRow(
                        label: AppText.memberCount,
                        value: _slotsController.text,
                      ),
                      _ReviewRow(
                        label: AppText.orderReview,
                        value: _orderLabel(_orderMethod),
                      ),
                      _ReviewRow(
                        label: AppText.protectionReview,
                        value: _protectionMode == 'PROTECTED'
                            ? AppText.protectedMode
                            : AppText.safeguardsOnly,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/ajo'),
                  child: const Text(AppText.done),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _creationStatusUnknown(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(AppText.createCircle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.help_outline, size: 56),
                const SizedBox(height: 16),
                Text(
                  AppText.circleCreateStatusUnknownTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppText.circleCreateStatusUnknown,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/ajo'),
                  child: const Text(AppText.returnToAjo),
                ),
              ],
            ),
          ),
        ),
      );

  int? _amountToKobo(String input) {
    final value = input.trim();
    if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final whole = BigInt.tryParse(parts.first);
    if (whole == null) return null;
    final fraction = parts.length == 1 ? '00' : parts[1].padRight(2, '0');
    final kobo = whole * BigInt.from(100) + BigInt.parse(fraction);
    if (kobo <= BigInt.zero || kobo > BigInt.from(maxSafeKobo)) {
      return null;
    }
    return kobo.toInt();
  }

  String _dateForApi(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';

  String _dateForDisplay(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.year}';

  int? _estimatedPotKobo() {
    final contribution = _amountToKobo(_amountController.text);
    final slots = int.tryParse(_slotsController.text);
    if (contribution == null || slots == null || slots < 2) return null;
    final pot = BigInt.from(contribution) * BigInt.from(slots);
    if (pot > BigInt.from(maxSafeKobo)) return null;
    return pot.toInt();
  }

  DateTime? _estimatedFinalRound() {
    final slots = int.tryParse(_slotsController.text);
    if (slots == null || slots < 2 || slots > 10000) return null;
    final intervals = slots - 1;
    if (_frequency == 'DAILY') {
      return _startDate.add(Duration(days: intervals));
    }
    if (_frequency == 'WEEKLY') {
      return _startDate.add(Duration(days: intervals * 7));
    }
    final monthIndex = _startDate.year * 12 + _startDate.month - 1 + intervals;
    final year = monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = _startDate.day > lastDay ? lastDay : _startDate.day;
    return DateTime(year, month, day);
  }

  String _formatKobo(int value) {
    final whole = (value ~/ 100).toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
        );
    return '${AppText.currencySymbol}$whole.${(value % 100).toString().padLeft(2, '0')}';
  }

  Widget _planEstimate() {
    final potKobo = _estimatedPotKobo();
    final finalRound = _estimatedFinalRound();
    if (potKobo == null || finalRound == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppText.circlePotEstimate}: ${_formatKobo(potKobo)}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              '${AppText.circleDurationEstimate}: ${_dateForDisplay(finalRound)}',
            ),
            const SizedBox(height: 6),
            const Text(AppText.circlePlanEstimateNote),
          ],
        ),
      ),
    );
  }

  String _frequencyLabel(String value) => switch (value) {
        'DAILY' => AppText.frequencyDaily,
        'WEEKLY' => AppText.frequencyWeekly,
        _ => AppText.frequencyMonthly,
      };

  String _orderLabel(String value) => switch (value) {
        'RANDOM' => AppText.orderRandom,
        'CHOSEN' => AppText.orderChosen,
        _ => AppText.orderOrganizer,
      };
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 16),
            Expanded(child: Text(value.isEmpty ? '—' : value)),
          ],
        ),
      );
}
