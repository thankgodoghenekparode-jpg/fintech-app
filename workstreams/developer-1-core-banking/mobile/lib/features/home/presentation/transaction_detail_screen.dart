import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final transaction = ref.watch(transactionDetailsProvider(transactionId));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.transactionDetailTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: transaction.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _TransactionDetailError(
              onRetry: () => ref.invalidate(
                transactionDetailsProvider(transactionId),
              ),
            ),
            data: (resource) => _TransactionDetailBody(
              transaction: resource.data,
              isStale: resource.isStale,
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionDetailBody extends StatelessWidget {
  const _TransactionDetailBody({
    required this.transaction,
    required this.isStale,
  });

  final TransactionSummary transaction;
  final bool isStale;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDebit = transaction.direction == 'D';
    final failed = transaction.status == 'FAILED';
    final amount = transaction.amountKobo == null
        ? '—'
        : _formatTransactionMoney(transaction.amountKobo!);
    return ListView(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 30,
          backgroundColor:
              failed ? colors.errorContainer : colors.primaryContainer,
          child: Icon(
            isDebit ? Icons.north_east : Icons.south_west,
            color: failed ? colors.onErrorContainer : colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${isDebit ? '−' : '+'}$amount',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Center(
          child: _StatusLabel(
            label: _transactionStatusLabel(text, transaction.status),
            color: _transactionStatusColor(colors, transaction.status),
          ),
        ),
        if (failed) ...[
          const SizedBox(height: 10),
          Text(
            transaction.failureCode?.isNotEmpty == true
                ? _failureReason(text, transaction.failureCode!)
                : text.transactionFailureGeneric,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              _DetailRow(
                  label: text.transactionCounterparty,
                  value: transaction.counterpartyName),
              _DetailRow(
                  label: text.transactionBank,
                  value: transaction.counterpartyBank),
              _DetailRow(
                  label: text.transactionNarration,
                  value: transaction.narration),
              _DetailRow(
                label: text.transactionFee,
                value: transaction.feeKobo == null
                    ? null
                    : _formatTransactionMoney(transaction.feeKobo!),
              ),
              _DetailRow(
                  label: text.transactionReference,
                  value: transaction.reference),
              _DetailRow(
                label: text.transactionDate,
                value: transaction.createdAt == null
                    ? null
                    : DateFormat('d MMM yyyy · h:mm a').format(
                        transaction.createdAt!.toLocal(),
                      ),
              ),
              _DetailRow(
                label: text.transactionBalanceAfter,
                value: transaction.balanceAfterKobo == null
                    ? null
                    : _formatTransactionMoney(transaction.balanceAfterKobo!),
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.go(
            '/transactions/${Uri.encodeComponent(transaction.id)}/receipt',
          ),
          icon: const Icon(Icons.receipt_long_outlined),
          label: Text(text.transactionReceipt),
        ),
        OutlinedButton.icon(
          onPressed: () => context.push(
            '/transactions/${Uri.encodeComponent(transaction.id)}/report',
          ),
          icon: const Icon(Icons.support_agent_outlined),
          label: Text(text.transactionReportProblem),
        ),
        if (isDebit)
          TextButton.icon(
            onPressed: () => context.go('/beneficiaries'),
            icon: const Icon(Icons.person_add_alt_outlined),
            label: Text(text.transactionSaveBeneficiary),
          ),
        if (isStale) ...[
          const SizedBox(height: 10),
          Text(text.transactionOfflineStale, textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String? value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  value!,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _TransactionDetailError extends StatelessWidget {
  const _TransactionDetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text.transactionDetailLoadError, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(text.homeRetry),
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(label),
        ),
      );
}

String _transactionStatusLabel(AppLocalizations text, String? status) =>
    switch (status) {
      'PENDING' => text.homeTxnPending,
      'SUCCESSFUL' => text.homeTxnSuccessful,
      'FAILED' => text.homeTxnFailed,
      'REVERSED' => text.homeTxnReversed,
      _ => text.homeStatusUnavailable,
    };

String _failureReason(AppLocalizations text, String code) => switch (code) {
      'TRF_INSUFFICIENT_FUNDS' => text.transactionFailureInsufficientFunds,
      'TRF_LIMIT_EXCEEDED' => text.transactionFailureLimit,
      'ACCOUNT_LOCKED' ||
      'ACCOUNT_RESTRICTED' =>
        text.transactionFailureAccountLocked,
      _ => text.transactionFailureGeneric,
    };

Color _transactionStatusColor(ColorScheme colors, String? status) =>
    switch (status) {
      'SUCCESSFUL' => colors.tertiaryContainer,
      'PENDING' => colors.secondaryContainer,
      'FAILED' => colors.errorContainer,
      _ => colors.surfaceContainerHigh,
    };

String _formatTransactionMoney(int amountKobo) => NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(amountKobo / 100);
