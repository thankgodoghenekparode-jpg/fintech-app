// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_deadline_decision_models.dart';
import '../widgets/pas_components.dart';

class DeadlineDecisionPage extends StatefulWidget {
  const DeadlineDecisionPage(
      {required this.adapter, required this.planId, super.key});
  final PayAmSmallDeadlineDecisionAdapter adapter;
  final String planId;

  @override
  State<DeadlineDecisionPage> createState() => _DeadlineDecisionPageState();
}

class _DeadlineDecisionPageState extends State<DeadlineDecisionPage> {
  late Future<PasDeadlineDecisionContext> _future;
  PasDeadlineDecision? _selected;
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadDeadlineContext(widget.planId);
  }

  void _retry() => setState(() {
        _error = null;
        _future = widget.adapter.loadDeadlineContext(widget.planId);
      });

  Future<void> _submit(PasDeadlineDecisionContext data) async {
    final decision = _selected;
    if (decision == null || !data.option(decision).canConfirm(decision)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await widget.adapter.decide(
        PasDeadlineDecisionRequest(planId: widget.planId, decision: decision),
      );
      if (mounted) {
        setState(() => _success = result.previewOnly
            ? 'Preview only. No deadline decision was submitted.'
            : 'Your decision was submitted.');
      }
    } catch (_) {
      if (mounted) {
        setState(
            () => _error = 'We could not submit this decision. Try again.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              PasPageHeader(
                title: 'Vault deadline reached',
                subtitle: 'Pay Am Small · S-PAS-009',
                onBack: () => Navigator.maybePop(context),
                showDefaultAction: false,
              ),
              Expanded(
                child: FutureBuilder<PasDeadlineDecisionContext>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _LoadError(onRetry: _retry);
                    }
                    final data = snapshot.data!;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(PasSpacing.page,
                          PasSpacing.md, PasSpacing.page, PasSpacing.xl),
                      children: [
                        _VaultSummary(data: data),
                        const SizedBox(height: PasSpacing.lg),
                        PasSectionTitle('Choose a vault action',
                            trailing: Text(
                              _selected == null
                                  ? 'Action required'
                                  : 'Review terms',
                              style: Theme.of(context).textTheme.bodySmall,
                            )),
                        const SizedBox(height: PasSpacing.sm),
                        _OptionCard(
                          title: 'Extend the deadline',
                          option: data.extend,
                          decision: PasDeadlineDecision.extend,
                          selected: _selected == PasDeadlineDecision.extend,
                          onSelect:
                              data.extend.canConfirm(PasDeadlineDecision.extend)
                                  ? () => setState(() {
                                        _selected = PasDeadlineDecision.extend;
                                        _error = null;
                                      })
                                  : null,
                        ),
                        const SizedBox(height: PasSpacing.md),
                        _OptionCard(
                          title: 'Refund accumulated savings',
                          option: data.refund,
                          decision: PasDeadlineDecision.refund,
                          selected: _selected == PasDeadlineDecision.refund,
                          onSelect:
                              data.refund.canConfirm(PasDeadlineDecision.refund)
                                  ? () => setState(() {
                                        _selected = PasDeadlineDecision.refund;
                                        _error = null;
                                      })
                                  : null,
                        ),
                        if (data.additionalNotice != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _Notice(data.additionalNotice!),
                        ],
                      ],
                    );
                  },
                ),
              ),
              FutureBuilder<PasDeadlineDecisionContext>(
                future: _future,
                builder: (context, snapshot) {
                  final decision = _selected;
                  final canSubmit = snapshot.hasData &&
                      decision != null &&
                      snapshot.data!.option(decision).canConfirm(decision);
                  return _BottomAction(
                    label: _success == null ? 'Confirm decision' : 'Done',
                    enabled: _success != null || (canSubmit && !_submitting),
                    loading: _submitting,
                    message: _success ?? _error,
                    messageIsError: _success == null && _error != null,
                    onPressed: () {
                      if (_success != null) {
                        Navigator.maybePop(context, true);
                      } else if (snapshot.hasData) {
                        _submit(snapshot.data!);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
}

class _VaultSummary extends StatelessWidget {
  const _VaultSummary({required this.data});
  final PasDeadlineDecisionContext data;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.schedule_outlined,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: PasSpacing.sm),
              Expanded(
                  child: Text(data.statusLabel,
                      style: Theme.of(context).textTheme.labelLarge)),
            ]),
            const SizedBox(height: PasSpacing.md),
            Text(data.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PasSpacing.md),
            _Fact('Accumulated balance', data.savedLabel),
            const Divider(height: PasSpacing.lg),
            _Fact('Deadline', data.deadlineLabel),
          ]),
        ),
      );
}

class _OptionCard extends StatelessWidget {
  const _OptionCard(
      {required this.title,
      required this.option,
      required this.decision,
      required this.selected,
      required this.onSelect});
  final String title;
  final PasDeadlineDecisionOption option;
  final PasDeadlineDecision decision;
  final bool selected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final available = onSelect != null;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        side: BorderSide(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 2 : 1),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleSmall)),
              RadioGroup<PasDeadlineDecision>(
                groupValue: selected ? decision : null,
                onChanged: (value) {
                  if (available && value != null) onSelect!();
                },
                child: Radio<PasDeadlineDecision>(
                    value: decision, enabled: available),
              ),
            ]),
            if (option.consequence != null) ...[
              Text(option.consequence!,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: PasSpacing.md),
            ],
            if (decision == PasDeadlineDecision.extend) ...[
              _Fact('Extension fee', option.feeLabel),
              _Fact('New deadline', option.newDeadlineLabel),
            ] else
              _Fact('Refund amount', option.refundNetLabel),
            if (!available) ...[
              const SizedBox(height: PasSpacing.sm),
              Text(
                  option.unavailableReason ??
                      'Terms are unavailable. This option cannot be confirmed.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant)),
            ],
          ]),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: PasSpacing.xs),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          const SizedBox(width: PasSpacing.sm),
          Flexible(
              child: Text(value ?? 'Not provided',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()]))),
        ]),
      );
}

class _Notice extends StatelessWidget {
  const _Notice(this.text, {this.isError = false});
  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
          color: isError ? colors.errorContainer : colors.primaryContainer,
          borderRadius: BorderRadius.circular(PasSpacing.radiusMd)),
      child: Text(text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isError
                  ? colors.onErrorContainer
                  : colors.onPrimaryContainer)),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction(
      {required this.label,
      required this.enabled,
      required this.loading,
      this.message,
      this.messageIsError = false,
      required this.onPressed});
  final String label;
  final bool enabled;
  final bool loading;
  final String? message;
  final bool messageIsError;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(
            PasSpacing.page, PasSpacing.sm, PasSpacing.page, PasSpacing.md),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (message != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: PasSpacing.sm),
              child: _Notice(message!, isError: messageIsError),
            ),
          ],
          SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                  onPressed: enabled ? onPressed : null,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(label))),
        ]),
      );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(PasSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cloud_off_outlined, size: 40),
          const SizedBox(height: PasSpacing.md),
          const Text('Deadline decision details are unavailable.'),
          const SizedBox(height: PasSpacing.md),
          OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
        ]),
      ));
}
