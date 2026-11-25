import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final account = ref.watch(homeAccountProvider);
    return Scaffold(
      appBar: AppBar(title: Text(text.navMore)),
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
        data: (resource) => _MoreContent(account: resource.data),
      ),
    );
  }
}

class _MoreContent extends StatelessWidget {
  const _MoreContent({required this.account});

  final AccountSummary account;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/account-details'),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child: Text(_initials(account.accountName)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.accountName ?? text.accountNotProvided,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(text.accountTierLabel(
                              account.tier?.toString() ?? '—',
                            )),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          account.accountNumber == null
                              ? text.fundingNumberUnavailable
                              : '${text.homeAccountNumber}: ${account.accountNumber}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      if (account.accountNumber?.isNotEmpty == true)
                        IconButton(
                          tooltip: text.homeCopyAccountNumber,
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(
                              text: account.accountNumber!,
                            ));
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(text.fundingCopied)),
                            );
                          },
                          icon: const Icon(Icons.copy_outlined, size: 18),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        _GroupLabel(text.moreAccountPreferences),
        _MoreGroup(
          children: [
            _MoreRow(
              icon: Icons.badge_outlined,
              title: text.moreProfileKyc,
              subtitle: text.moreProfileSubtitle,
              onTap: () => context.push('/account-details'),
            ),
            _MoreRow(
              icon: Icons.tune,
              title: text.moreLimits,
              subtitle: _limitSummary(account, text),
              onTap: () => context.push('/more/limits'),
            ),
            _MoreRow(
              icon: Icons.receipt_long_outlined,
              title: text.moreStatements,
              subtitle: text.moreStatementsSubtitle,
              onTap: () => context.push('/more/statements'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _GroupLabel(text.moreSecurityControl),
        _MoreGroup(
          children: [
            _MoreRow(
              icon: Icons.notifications_outlined,
              title: text.homeNotifications,
              subtitle: text.moreNotificationsSubtitle,
              onTap: () => context.push('/notifications'),
            ),
            _MoreRow(
              icon: Icons.credit_card_outlined,
              title: text.moreCards,
              subtitle: text.moreCardsSubtitle,
              onTap: () => context.go('/cards'),
            ),
            _MoreRow(
              icon: Icons.security_outlined,
              title: text.moreSecurity,
              subtitle: text.moreSecuritySubtitle,
              onTap: () => _explain(context, text.moreSecurityBlocked),
            ),
            _MoreRow(
              icon: Icons.devices_outlined,
              title: text.moreDevices,
              subtitle: text.moreDevicesSubtitle,
              onTap: () => _explain(context, text.moreDevicesBlocked),
            ),
          ],
        ),
        const SizedBox(height: 22),
        _GroupLabel(text.moreSupportLegal),
        _MoreGroup(
          children: [
            _MoreRow(
              icon: Icons.payments_outlined,
              title: text.navPayments,
              subtitle: text.morePaymentsSubtitle,
              onTap: () => context.go('/payments'),
            ),
            _MoreRow(
              icon: Icons.add_circle_outline,
              title: text.fundingTitle,
              subtitle: text.fundingTransferSubtitle,
              onTap: () => context.push('/add-money'),
            ),
            _MoreRow(
              icon: Icons.help_outline,
              title: text.moreHelp,
              subtitle: text.moreHelpSubtitle,
              onTap: () => context.push('/help'),
            ),
            _MoreRow(
              icon: Icons.place_outlined,
              title: 'Branch and agent locator',
              subtitle: 'Find nearby agents and get directions',
              onTap: () => context.push('/locator'),
            ),
            _MoreRow(
              icon: Icons.description_outlined,
              title: text.moreLegal,
              subtitle: text.moreLegalSubtitle,
              onTap: () => context.push('/more/legal'),
            ),
            _MoreRow(
              icon: Icons.person_remove_outlined,
              title: 'Close account',
              subtitle: 'Review eligibility and submit a closure request',
              onTap: () => context.push('/more/close-account'),
            ),
          ],
        ),
      ],
    );
  }

  static String _initials(String? name) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'));
    final initials = parts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1).toUpperCase())
        .join();
    return initials.isEmpty ? '?' : initials;
  }

  static String _limitSummary(AccountSummary account, AppLocalizations text) {
    final daily = account.dailyOutLimitKobo;
    final per = account.perTxnLimitKobo;
    if (daily == null && per == null) return text.moreLimitsUnavailable;
    String format(int kobo) => '₦${(kobo / 100).toStringAsFixed(0)}';
    return [
      if (daily != null) text.moreDailyLimit(format(daily)),
      if (per != null) text.moreSingleLimit(format(per)),
    ].join(' • ');
  }

  static void _explain(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.commonDone),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 0.7,
              ),
        ),
      );
}

class _MoreGroup extends StatelessWidget {
  const _MoreGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 56),
              children[i],
            ],
          ],
        ),
      );
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        minVerticalPadding: 12,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: .3),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}
