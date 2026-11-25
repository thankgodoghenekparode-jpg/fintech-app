import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class AccountLimitsScreen extends ConsumerWidget {
  const AccountLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final account = ref.watch(homeAccountProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.limitsTitle),
        actions: [
          IconButton(
            tooltip: text.limitsInfoTitle,
            onPressed: () => _showInfo(context, text),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: account.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: FilledButton.icon(
            onPressed: () => ref.invalidate(homeAccountProvider),
            icon: const Icon(Icons.refresh),
            label: Text(text.commonRetry),
          ),
        ),
        data: (resource) => _LimitsContent(account: resource.data),
      ),
    );
  }

  static void _showInfo(BuildContext context, AppLocalizations text) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.limitsInfoTitle),
        content: Text(text.limitsInfoBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(text.commonDone),
          ),
        ],
      ),
    );
  }
}

class _LimitsContent extends StatelessWidget {
  const _LimitsContent({required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final currency = account.currency ?? 'NGN';
    final money = NumberFormat.currency(
      locale: 'en_NG',
      name: currency,
      symbol: currency == 'NGN' ? '\u20A6' : '$currency ',
      decimalDigits: 2,
    );
    String format(int? kobo) =>
        kobo == null ? text.limitsUnavailable : money.format(kobo / 100);

    final dailyLimit = account.dailyOutLimitKobo;
    final used = account.dailyUsedKobo;
    final remaining = dailyLimit == null || used == null
        ? null
        : (dailyLimit - used).clamp(0, dailyLimit).toInt();
    final progress = dailyLimit == null || dailyLimit <= 0 || used == null
        ? null
        : (used / dailyLimit).clamp(0.0, 1.0);
    final balanceUsage = account.balanceCapKobo == null ||
            account.balanceCapKobo! <= 0 ||
            account.ledgerBalanceKobo == null
        ? null
        : (account.ledgerBalanceKobo! / account.balanceCapKobo!)
            .clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  child: const Icon(Icons.verified_user_outlined),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text.limitsTierStatus),
                      const SizedBox(height: 4),
                      Text(
                        account.tier == null
                            ? text.limitsTierUnavailable
                            : text.limitsCurrentTier(account.tier.toString()),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _LimitCard(
          icon: Icons.swap_horiz,
          title: text.limitsDailyTransfer,
          value: format(dailyLimit),
          footer: dailyLimit == null || used == null || remaining == null
              ? text.limitsUsageUnavailable
              : text.limitsDailyUsage(
                  format(used),
                  format(remaining),
                ),
          progress: progress,
        ),
        _LimitCard(
          icon: Icons.send_outlined,
          title: text.limitsSingleTransfer,
          value: format(account.perTxnLimitKobo),
          footer: text.limitsSingleTransferDescription,
        ),
        _LimitCard(
          icon: Icons.account_balance_wallet_outlined,
          title: text.limitsBalanceCap,
          value: format(account.balanceCapKobo),
          footer: account.balanceCapKobo == null ||
                  account.ledgerBalanceKobo == null
              ? text.limitsBalanceUsageUnavailable
              : text.limitsBalanceUsage(
                  format(account.ledgerBalanceKobo),
                  '${((balanceUsage ?? 0) * 100).round()}',
                ),
          progress: balanceUsage,
        ),
        const SizedBox(height: 10),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(
                alpha: .32,
              ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text.limitsUpgradeTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(text.limitsUpgradeBody),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => _showUpgradeGap(context, text),
                    child: Text(text.limitsUpgradeAction),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static void _showUpgradeGap(BuildContext context, AppLocalizations text) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.limitsUpgradeTitle),
        content: Text(text.limitsUpgradeUnavailable),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(text.commonDone),
          ),
        ],
      ),
    );
  }
}

class _LimitCard extends StatelessWidget {
  const _LimitCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.footer,
    this.progress,
  });

  final IconData icon;
  final String title;
  final String value;
  final String footer;
  final double? progress;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title)),
                  Icon(icon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress),
              ],
              const SizedBox(height: 8),
              Text(footer),
            ],
          ),
        ),
      );
}
