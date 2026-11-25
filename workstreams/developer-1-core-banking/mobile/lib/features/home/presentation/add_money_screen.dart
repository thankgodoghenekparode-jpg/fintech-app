import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class AddMoneyScreen extends ConsumerWidget {
  const AddMoneyScreen({this.demo = false, super.key});

  final bool demo;

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
        title: Text(text.fundingTitle),
        actions: [
          IconButton(
            tooltip: text.fundingHelp,
            onPressed: () => _showHelp(context, text),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: account.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _LoadError(
          message: text.homeAccountLoadError,
          retryLabel: text.commonRetry,
          onRetry: () => ref.invalidate(homeAccountProvider),
        ),
        data: (resource) => _FundingContent(
          account: resource.data,
          demo: demo,
        ),
      ),
    );
  }

  static void _showHelp(BuildContext context, AppLocalizations text) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text.fundingHelp),
        content: Text(text.fundingHelpBody),
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

class _FundingContent extends StatelessWidget {
  const _FundingContent({required this.account, required this.demo});

  final AccountSummary account;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final number = account.accountNumber;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        if (demo) ...[
          Card(
            color: colors.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text.fundingDemoNotice)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Icon(Icons.bolt, color: colors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text.fundingRecommended,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Chip(
              avatar: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(text.fundingRealTime),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text.fundingBankTransfer,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(text.fundingTransferSubtitle),
                        ],
                      ),
                    ),
                    Icon(Icons.account_balance_outlined,
                        color: colors.primary, size: 30),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Text(text.homeAccountNumber),
                const SizedBox(height: 8),
                if (number == null || number.isEmpty)
                  Text(
                    text.fundingNumberUnavailable,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            number,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () => _copyNumber(context, number),
                          icon: const Icon(Icons.copy_outlined),
                          label: Text(text.fundingCopy),
                        ),
                      ],
                    ),
                  ),
                if (account.accountName?.isNotEmpty == true) ...[
                  const SizedBox(height: 16),
                  Text(text.accountNameLabel),
                  const SizedBox(height: 4),
                  Text(
                    account.accountName!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: colors.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(text.fundingTransferInstructions)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (number != null && number.isNotEmpty) ...[
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => _shareDetails(context, account),
            icon: const Icon(Icons.share_outlined),
            label: Text(text.fundingShare),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ],
    );
  }

  static Future<void> _copyNumber(BuildContext context, String number) async {
    await Clipboard.setData(ClipboardData(text: number));
    if (!context.mounted) return;
    final text = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text.fundingCopied)));
  }

  static Future<void> _shareDetails(
    BuildContext context,
    AccountSummary account,
  ) async {
    final text = AppLocalizations.of(context)!;
    final details = [
      if (account.accountName?.isNotEmpty == true)
        '${text.accountNameLabel}: ${account.accountName}',
      '${text.homeAccountNumber}: ${account.accountNumber}',
    ].join('\n');
    await SharePlus.instance.share(
      ShareParams(
        title: text.fundingShare,
        text: details,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
              ),
            ],
          ),
        ),
      );
}
