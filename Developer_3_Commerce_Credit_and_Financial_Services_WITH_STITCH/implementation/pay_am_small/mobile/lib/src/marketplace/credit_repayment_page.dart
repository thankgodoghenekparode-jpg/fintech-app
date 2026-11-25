// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_batch6_models.dart';
import '../pas_vault_models.dart';
import '../widgets/pas_components.dart';

class CreditRepaymentPage extends StatefulWidget {
  const CreditRepaymentPage({
    super.key,
    required this.adapter,
    required this.planId,
    this.onBack,
  });
  final PayAmSmallCreditRepaymentAdapter adapter;
  final String planId;
  final VoidCallback? onBack;

  @override
  State<CreditRepaymentPage> createState() => _CreditRepaymentPageState();
}

class _CreditRepaymentPageState extends State<CreditRepaymentPage> {
  late Future<PasCreditRepaymentContext?> _future;
  bool _busy = false;
  String? _message;
  bool? _autoDebitEnabled;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadCredit(widget.planId);
  }

  void _retry() => setState(() {
        _message = null;
        _future = widget.adapter.loadCredit(widget.planId);
      });

  Future<void> _repay(PasCreditRepaymentContext data) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      // Use only the integer amount supplied by the host. Display labels are
      // never parsed and the feature performs no financial calculation.
      await widget.adapter.repay(PasRepaymentRequest(
        planId: data.planId,
        amountKobo: data.repaymentAmountKobo!,
      ));
      if (mounted) setState(() => _message = 'Repayment request submitted.');
    } catch (_) {
      if (mounted)
        setState(
            () => _message = 'Repayment could not be completed. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleAutoDebit(
    PasCreditRepaymentContext data,
    bool enabled,
  ) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await widget.adapter.setAutoDebit(
        PasAutoDebitRequest(planId: data.planId, enabled: enabled),
      );
      if (mounted) {
        setState(() {
          _autoDebitEnabled = enabled;
          _message = 'Auto-debit setting updated.';
        });
      }
    } catch (_) {
      if (mounted)
        setState(
            () => _message = 'Auto-debit could not be updated. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            PasPageHeader(
              title: 'Credit repayment',
              subtitle: 'Vendor-funded credit',
              onBack: widget.onBack ?? () => Navigator.maybePop(context),
              showDefaultAction: false,
            ),
            Expanded(
              child: FutureBuilder<PasCreditRepaymentContext?>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _state('Credit information is unavailable.', _retry);
                  }
                  final data = snapshot.data;
                  if (data == null)
                    return _state('No credit plan was provided.');
                  return _content(data);
                },
              ),
            ),
          ]),
        ),
      );

  Widget _content(PasCreditRepaymentContext data) {
    final colors = Theme.of(context).colorScheme;
    return Column(children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(PasSpacing.page),
          children: [
            if (data.overdueNoticeLabel != null) ...[
              Container(
                padding: const EdgeInsets.all(PasSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
                ),
                child: Text(
                  data.overdueNoticeLabel!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(height: PasSpacing.md),
            ],
            Card(
                child: Padding(
              padding: const EdgeInsets.all(PasSpacing.md),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.planLabel,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: PasSpacing.xs),
                    Text(data.vendorLabel,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: PasSpacing.lg),
                    Text('Outstanding balance',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text(data.outstandingBalanceLabel,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ]),
            )),
            const SizedBox(height: PasSpacing.md),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(PasSpacing.md),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Repayment information',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: PasSpacing.sm),
                    Text(data.repaymentLabel,
                        style: Theme.of(context).textTheme.bodyLarge),
                    if (data.nextRepaymentDateLabel != null) ...[
                      const SizedBox(height: PasSpacing.xs),
                      Text(data.nextRepaymentDateLabel!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ]),
            )),
            if (data.schedule.isNotEmpty) ...[
              const SizedBox(height: PasSpacing.md),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(PasSpacing.md),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Repayment schedule',
                          style: Theme.of(context).textTheme.titleSmall),
                      for (final item in data.schedule)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.label),
                          subtitle: Text([
                            item.statusLabel,
                            if (item.dateLabel != null) item.dateLabel!
                          ].join(' · ')),
                          trailing: Text(item.amountLabel),
                        ),
                    ]),
              )),
            ],
            Card(
              color: colors.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(PasSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user_outlined,
                        color: colors.onPrimaryContainer),
                    const SizedBox(width: PasSpacing.sm),
                    Expanded(
                      child: Text(
                        data.vendorTermsLabel ??
                            'Vendor-funded credit terms are unavailable until supplied and confirmed by the host.',
                        style: TextStyle(color: colors.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!data.repaymentAvailable) ...[
              const SizedBox(height: PasSpacing.md),
              Container(
                padding: const EdgeInsets.all(PasSpacing.md),
                decoration: BoxDecoration(
                    color: colors.errorContainer,
                    borderRadius: BorderRadius.circular(PasSpacing.radiusMd)),
                child: Text(
                    'Vendor-funded credit repayment is unavailable until host eligibility and required legal approval are confirmed.',
                    style: TextStyle(color: colors.onErrorContainer)),
              ),
            ],
            if (data.autoDebitAvailable)
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Auto-debit'),
                value: _autoDebitEnabled ?? data.autoDebitEnabled,
                onChanged: !data.autoDebitControlAvailable || _busy
                    ? null
                    : (value) => _toggleAutoDebit(data, value),
              ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: PasSpacing.md),
                child: Text(_message!, key: const ValueKey('repaymentMessage')),
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
            PasSpacing.page, PasSpacing.sm, PasSpacing.page, PasSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed:
                data.repaymentAvailable && !_busy ? () => _repay(data) : null,
            child: _busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Make repayment'),
          ),
        ),
      ),
    ]);
  }

  Widget _state(String message, [VoidCallback? retry]) => Center(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center),
            if (retry != null) ...[
              const SizedBox(height: PasSpacing.md),
              OutlinedButton(onPressed: retry, child: const Text('Try again')),
            ],
          ]),
        ),
      );
}
