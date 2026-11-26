import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_models.dart';

class ReferralReviewPage extends StatefulWidget {
  const ReferralReviewPage({
    required this.adapter,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback? onThemeToggle;

  @override
  State<ReferralReviewPage> createState() => _ReferralReviewPageState();
}

class _ReferralReviewPageState extends State<ReferralReviewPage> {
  late Future<ReferralReviewSnapshot?> _queue;
  String? _submittingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _queue = widget.adapter.loadReferralReviews();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Referral review'),
          actions: [
            if (widget.onThemeToggle != null)
              IconButton(
                tooltip: 'Switch theme',
                onPressed: widget.onThemeToggle,
                icon: const Icon(Icons.contrast_outlined),
              ),
          ],
        ),
        body: FutureBuilder<ReferralReviewSnapshot?>(
          future: _queue,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading referral reviews',
                ),
              );
            }
            if (snapshot.hasError) {
              return _ReviewState(
                icon: Icons.error_outline,
                title: 'Referral queue could not be loaded',
                message: 'Check your Risk analyst access and try again.',
                action: TextButton.icon(
                  onPressed: () => setState(_load),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              );
            }
            final data = snapshot.data;
            if (data == null) {
              return const _ReviewState(
                icon: Icons.cloud_off_outlined,
                title: 'Referral queue unavailable',
                message:
                    'The host has not supplied flagged referral records. No queue-list endpoint is documented.',
              );
            }
            if (data.referrals.isEmpty) {
              return const _ReviewState(
                icon: Icons.fact_check_outlined,
                title: 'No flagged referrals',
                message: 'The host has not supplied referrals for review.',
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 960;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Text(
                          'Flagged referrals',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Review host-flagged referrals and their supplied signals.',
                        ),
                        const SizedBox(height: 20),
                        if (wide)
                          _ReviewTable(
                            referrals: data.referrals,
                            submittingId: _submittingId,
                            onDecide: _decide,
                          )
                        else
                          ...data.referrals.map(
                            (referral) => _ReviewCard(
                              referral: referral,
                              submitting: _submittingId == referral.id,
                              onDecide: (decision) =>
                                  _decide(referral, decision),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );

  Future<void> _decide(
    FlaggedReferral referral,
    ReferralReviewDecision decision,
  ) async {
    if (!referral.canReview || _submittingId != null) return;
    final reason = await _askReason(context, decision);
    if (reason == null || !mounted) return;
    setState(() => _submittingId = referral.id);
    try {
      await widget.adapter.decideReferral(
        referralId: referral.id,
        decision: decision,
        reason: reason.isEmpty ? null : reason,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Decision submitted to the host.')),
        );
        setState(_load);
      }
    } catch (error) {
      if (mounted) {
        final message = error is InsightsHostUnavailable
            ? error.message
            : 'Referral decision could not be submitted.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _submittingId = null);
    }
  }
}

Future<String?> _askReason(
  BuildContext context,
  ReferralReviewDecision decision,
) async =>
    (await showDialog<_ReviewDecisionResult>(
      context: context,
      builder: (_) => _ReviewDecisionDialog(decision: decision),
    ))
        ?.reason;

class _ReviewDecisionDialog extends StatefulWidget {
  const _ReviewDecisionDialog({required this.decision});
  final ReferralReviewDecision decision;

  @override
  State<_ReviewDecisionDialog> createState() => _ReviewDecisionDialogState();
}

class _ReviewDecisionDialogState extends State<_ReviewDecisionDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.decision == ReferralReviewDecision.approve
            ? 'Approve referral'
            : 'Reject referral'),
        content: TextField(
          controller: _controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              _ReviewDecisionResult(_controller.text.trim()),
            ),
            child: const Text('Confirm decision'),
          ),
        ],
      );
}

class _ReviewDecisionResult {
  const _ReviewDecisionResult(this.reason);
  final String reason;
}

class _ReviewTable extends StatelessWidget {
  const _ReviewTable({
    required this.referrals,
    required this.submittingId,
    required this.onDecide,
  });

  final List<FlaggedReferral> referrals;
  final String? submittingId;
  final Future<void> Function(FlaggedReferral, ReferralReviewDecision) onDecide;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Referral')),
              DataColumn(label: Text('Signals')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Decision')),
            ],
            rows: referrals
                .map(
                  (referral) => DataRow(
                    cells: [
                      DataCell(Text(referral.reference)),
                      DataCell(_Signals(signals: referral.signals)),
                      DataCell(_StatusText(text: referral.status)),
                      DataCell(
                        _DecisionButtons(
                          canReview: referral.canReview,
                          submitting: submittingId == referral.id,
                          onApprove: () => onDecide(
                              referral, ReferralReviewDecision.approve),
                          onReject: () =>
                              onDecide(referral, ReferralReviewDecision.reject),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.referral,
    required this.submitting,
    required this.onDecide,
  });

  final FlaggedReferral referral;
  final bool submitting;
  final ValueChanged<ReferralReviewDecision> onDecide;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      referral.reference,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _StatusText(text: referral.status),
                ],
              ),
              const SizedBox(height: 12),
              Text('Signals', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              _Signals(signals: referral.signals),
              const SizedBox(height: 14),
              _DecisionButtons(
                canReview: referral.canReview,
                submitting: submitting,
                onApprove: () => onDecide(ReferralReviewDecision.approve),
                onReject: () => onDecide(ReferralReviewDecision.reject),
              ),
            ],
          ),
        ),
      );
}

class _Signals extends StatelessWidget {
  const _Signals({required this.signals});
  final List<String> signals;

  @override
  Widget build(BuildContext context) => signals.isEmpty
      ? const Text('No signals provided by host')
      : Wrap(
          spacing: 8,
          runSpacing: 6,
          children: signals.map((signal) => Chip(label: Text(signal))).toList(),
        );
}

class _StatusText extends StatelessWidget {
  const _StatusText({required this.text});
  final String? text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 5),
          Flexible(child: Text(text ?? 'Not provided')),
        ],
      );
}

class _DecisionButtons extends StatelessWidget {
  const _DecisionButtons({
    required this.canReview,
    required this.submitting,
    required this.onApprove,
    required this.onReject,
  });

  final bool canReview;
  final bool submitting;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton(
            onPressed: canReview && !submitting ? onApprove : null,
            child: submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Approve'),
          ),
          OutlinedButton(
            onPressed: canReview && !submitting ? onReject : null,
            child: const Text('Reject'),
          ),
          if (!canReview) const Text('Review permission unavailable from host'),
        ],
      );
}

class _ReviewState extends StatelessWidget {
  const _ReviewState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(message),
                    if (action != null) ...[
                      const SizedBox(height: 12),
                      action!
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
