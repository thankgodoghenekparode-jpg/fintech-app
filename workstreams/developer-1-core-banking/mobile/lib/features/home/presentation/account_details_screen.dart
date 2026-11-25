import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({this.demo = false, super.key});

  final bool demo;

  @override
  ConsumerState<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final _summaryKey = GlobalKey();
  bool _sharing = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final account = ref.watch(homeAccountProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.accountDetailsTitle),
        actions: [
          IconButton(
            tooltip: text.accountShareTitle,
            onPressed: widget.demo || _sharing || account.valueOrNull == null
                ? null
                : () => _shareText(account.valueOrNull!.data),
            icon: const Icon(Icons.share_outlined),
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
            label: Text(text.homeAccountLoadError),
          ),
        ),
        data: (resource) => _content(context, resource.data, text),
      ),
      bottomNavigationBar: account.valueOrNull == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.demo || _sharing
                            ? null
                            : () => _shareText(account.valueOrNull!.data),
                        icon: const Icon(Icons.share_outlined),
                        label: Text(text.accountShareText),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: widget.demo || _sharing
                            ? null
                            : () => _shareImage(account.valueOrNull!.data),
                        icon: _sharing
                            ? const SizedBox.square(
                                dimension: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.image_outlined),
                        label: Text(text.accountShareImage),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _content(
    BuildContext context,
    AccountSummary account,
    AppLocalizations text,
  ) {
    final hasLimits = account.perTxnLimitKobo != null ||
        account.dailyOutLimitKobo != null ||
        account.balanceCapKobo != null;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        if (widget.demo)
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'DEMO DATA ONLY · This is fictional account information, not connected to a bank.',
              ),
            ),
          ),
        RepaintBoundary(
          key: _summaryKey,
          child: _AccountSummaryCard(
            account: account,
            text: text,
            demo: widget.demo,
            onCopyNumber:
                widget.demo ? null : () => _copyAccountNumber(account),
          ),
        ),
        if (hasLimits) ...[
          const SizedBox(height: 20),
          _AccountLimitsCard(account: account, text: text),
        ],
      ],
    );
  }

  Future<void> _copyAccountNumber(AccountSummary account) async {
    final number = account.accountNumber;
    if (number == null || number.isEmpty) return;
    final text = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: number));
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text.accountCopied)));
    }
  }

  String _shareContent(AccountSummary account) => [
        if (account.accountName?.isNotEmpty == true)
          '${AppLocalizations.of(context)!.accountNameLabel}: ${account.accountName}',
        if (account.accountNumber?.isNotEmpty == true)
          '${AppLocalizations.of(context)!.accountNumberLabel}: ${account.accountNumber}',
        if (account.tier != null)
          AppLocalizations.of(context)!
              .accountTierLabel(account.tier.toString()),
      ].join('\n');

  Future<void> _shareText(AccountSummary account) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: AppLocalizations.of(context)!.accountShareTitle,
          text: _shareContent(account),
          sharePositionOrigin: _shareOrigin(),
        ),
      );
    } catch (_) {
      _showShareError();
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _shareImage(AccountSummary account) async {
    if (_sharing) return;
    final text = AppLocalizations.of(context)!;
    final shareContent = _shareContent(account);
    final origin = _shareOrigin();
    setState(() => _sharing = true);
    try {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final renderObject = _summaryKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) throw StateError('No image');
      final image = await renderObject.toImage(pixelRatio: 3);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw StateError('No image data');
        final bytes = data.buffer.asUint8List();
        await SharePlus.instance.share(
          ShareParams(
            title: text.accountShareTitle,
            text: shareContent,
            files: [
              XFile.fromData(
                bytes,
                name: 'account_details.png',
                mimeType: 'image/png',
              ),
            ],
            fileNameOverrides: const ['account_details.png'],
            sharePositionOrigin: origin,
          ),
        );
      } finally {
        image.dispose();
      }
    } catch (_) {
      _showShareError();
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Rect? _shareOrigin() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  void _showShareError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.accountShareFailed)),
    );
  }
}

class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard({
    required this.account,
    required this.text,
    required this.onCopyNumber,
    required this.demo,
  });

  final AccountSummary account;
  final AppLocalizations text;
  final VoidCallback? onCopyNumber;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 6, color: colors.primary),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (account.tier != null)
                      Chip(
                        avatar: Icon(Icons.verified_outlined,
                            size: 18, color: colors.primary),
                        label: Text(
                          text.accountTierLabel(account.tier.toString()),
                        ),
                      ),
                    Chip(
                      avatar: Icon(Icons.account_balance_outlined,
                          size: 18, color: colors.primary),
                      label: Text(
                          demo ? 'Demo account' : text.accountBankUnavailable),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  text.accountNameLabel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  account.accountName ?? text.accountNotProvided,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (account.status?.isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(text.accountStatusLabel(account.status!)),
                ],
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text.accountNumberLabel),
                            const SizedBox(height: 4),
                            SelectableText(
                              account.accountNumber ?? text.accountNotProvided,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFeatures: const [
                                      ui.FontFeature.tabularFigures(),
                                    ],
                                    letterSpacing: 1.1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: text.accountCopyNumber,
                        onPressed: account.accountNumber?.isNotEmpty == true
                            ? onCopyNumber
                            : null,
                        icon: const Icon(Icons.copy_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text.accountBankUnavailableHelper,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountLimitsCard extends StatelessWidget {
  const _AccountLimitsCard({required this.account, required this.text});

  final AccountSummary account;
  final AppLocalizations text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currency = account.currency ?? 'NGN';
    final dailyLimit = account.dailyOutLimitKobo;
    final used = account.dailyUsedKobo;
    final progress = dailyLimit == null || dailyLimit <= 0 || used == null
        ? null
        : (used / dailyLimit).clamp(0.0, 1.0).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text.accountLimitsTitle(account.tier?.toString() ?? '—'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (dailyLimit != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Text(text.accountDailyTransferLimit)),
                  Text(_money(dailyLimit, currency),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              if (progress != null && used != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(text.accountDailyUsed(_money(used, currency))),
                    ),
                    Text(text.accountDailyRemaining(
                      _money(
                        (dailyLimit - used).clamp(0, dailyLimit).toInt(),
                        currency,
                      ),
                    )),
                  ],
                ),
              ],
            ],
            if (account.balanceCapKobo != null ||
                account.perTxnLimitKobo != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  if (account.balanceCapKobo != null)
                    Expanded(
                      child: _LimitValue(
                        label: text.accountMaximumBalance,
                        value: _money(account.balanceCapKobo!, currency),
                      ),
                    ),
                  if (account.balanceCapKobo != null &&
                      account.perTxnLimitKobo != null)
                    const SizedBox(width: 10),
                  if (account.perTxnLimitKobo != null)
                    Expanded(
                      child: _LimitValue(
                        label: text.accountSingleTransferMax,
                        value: _money(account.perTxnLimitKobo!, currency),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LimitValue extends StatelessWidget {
  const _LimitValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      );
}

String _money(int kobo, String currency) => NumberFormat.currency(
      locale: 'en_NG',
      name: currency,
      symbol: currency == 'NGN' ? '₦' : currency,
      decimalDigits: 0,
    ).format(kobo / 100);
