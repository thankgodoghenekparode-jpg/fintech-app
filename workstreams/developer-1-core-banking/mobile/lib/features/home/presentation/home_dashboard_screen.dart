import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class HomeDashboardScreen extends ConsumerStatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  ConsumerState<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends ConsumerState<HomeDashboardScreen> {
  bool _showBalance = true;

  Future<void> _refresh() async {
    await Future.wait([
      ref
          .refresh(homeAccountProvider.future)
          .then<void>((_) {}, onError: (_) {}),
      ref
          .refresh(recentTransactionsProvider.future)
          .then<void>((_) {}, onError: (_) {}),
      ref.refresh(homeCardsProvider.future).then<void>((_) {}, onError: (_) {}),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final account = ref.watch(homeAccountProvider);
    final transactions = ref.watch(recentTransactionsProvider);
    final cards = ref.watch(homeCardsProvider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _HomeHeader(
            name: account.valueOrNull?.data.accountName,
            onNotifications: () => context.go('/notifications'),
          ),
          const SizedBox(height: 18),
          account.when(
            skipLoadingOnRefresh: true,
            skipError: true,
            loading: () => const _BalanceSkeleton(),
            error: (error, stackTrace) => _HomeErrorCard(
              message: text.homeAccountLoadError,
              onRetry: () => ref.invalidate(homeAccountProvider),
            ),
            data: (resource) => _BalanceCard(
              account: resource.data,
              showBalance: _showBalance,
              isStale: resource.isStale,
              updatedAt: resource.updatedAt,
              onToggleVisibility: () =>
                  setState(() => _showBalance = !_showBalance),
              onAccountDetails: () => context.push('/account-details'),
              onCopyAccount: () => _copyAccountNumber(
                context,
                resource.data.accountNumber,
                text,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _QuickActions(
            onSend: () => context.go('/payments'),
            onBills: () => context.go('/payments'),
            onAddMoney: () => context.go('/add-money'),
            onCards: () => context.go('/cards'),
            onSavings: () => context.go('/save-borrow'),
          ),
          const SizedBox(height: 24),
          _SectionHeading(
            title: text.homeCards,
            action: text.homeManageCards(cards.valueOrNull?.data.length ?? 0),
            onAction: () => context.go('/cards'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: cards.when(
              skipLoadingOnRefresh: true,
              skipError: true,
              loading: () => const _CardSkeleton(),
              error: (error, stackTrace) => Center(
                child: _InlineError(
                  message: text.homeCardsLoadError,
                  onRetry: () => ref.invalidate(homeCardsProvider),
                ),
              ),
              data: (resource) => _CardCarousel(
                cards: resource.data,
                isStale: resource.isStale,
                updatedAt: resource.updatedAt,
                onManage: () => context.go('/cards'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeading(
            title: text.homeRecentActivity,
            action: text.homeSeeAll,
            onAction: () => context.go('/history'),
          ),
          const SizedBox(height: 12),
          transactions.when(
            skipLoadingOnRefresh: true,
            skipError: true,
            loading: () => const _ActivitySkeleton(),
            error: (error, stackTrace) => _InlineError(
              message: text.homeTransactionsLoadError,
              onRetry: () => ref.invalidate(recentTransactionsProvider),
            ),
            data: (resource) => _ActivityList(
              transactions: resource.data,
              isStale: resource.isStale,
              updatedAt: resource.updatedAt,
              onTransactionTap: (transaction) {
                if (transaction.id.isNotEmpty) {
                  context.push(
                    '/transactions/${Uri.encodeComponent(transaction.id)}',
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _copyAccountNumber(
    BuildContext context,
    String? accountNumber,
    AppLocalizations text,
  ) async {
    if (accountNumber == null || accountNumber.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: accountNumber));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text.homeAccountNumberCopied)),
      );
    }
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.name, required this.onNotifications});

  final String? name;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final greetingName = name?.trim().split(RegExp(r'\s+')).first;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: Text(_initials(name)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            greetingName == null || greetingName.isEmpty
                ? text.homeGreetingGeneric
                : text.homeGreetingName(greetingName),
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          tooltip: text.homeNotifications,
          onPressed: onNotifications,
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.account,
    required this.showBalance,
    required this.isStale,
    required this.updatedAt,
    required this.onToggleVisibility,
    required this.onAccountDetails,
    required this.onCopyAccount,
  });

  final AccountSummary account;
  final bool showBalance;
  final bool isStale;
  final DateTime updatedAt;
  final VoidCallback onToggleVisibility;
  final VoidCallback onAccountDetails;
  final VoidCallback onCopyAccount;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final currency = account.currency ?? 'NGN';
    final available = showBalance
        ? _formatMoney(account.availableBalanceKobo, currency)
        : '••••••';
    final ledger = showBalance
        ? _formatMoney(account.ledgerBalanceKobo, currency)
        : '••••••';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text.homeAvailableBalance,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip:
                      showBalance ? text.homeHideBalance : text.homeShowBalance,
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    showBalance
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                if (account.status != null)
                  _StatusLabel(
                    label: _accountStatusLabel(text, account.status!),
                    color: _accountStatusColor(color, account.status!),
                  ),
              ],
            ),
            Text(
              available,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${text.homeLedgerBalance}: $ledger',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (account.tier != null)
                  Text(text.homeTier(account.tier.toString()),
                      style: theme.textTheme.labelMedium),
              ],
            ),
            if (account.accountNumber?.isNotEmpty == true) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${text.homeAccountNumber}: ${account.accountNumber}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    tooltip: text.homeCopyAccountNumber,
                    onPressed: onCopyAccount,
                    icon: const Icon(Icons.copy_outlined, size: 18),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.accountDetailsTitle,
                    onPressed: onAccountDetails,
                    icon: const Icon(Icons.open_in_new, size: 18),
                  ),
                ],
              ),
            ],
            if (account.balanceCapKobo != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  text.homeBalanceCap(
                    showBalance
                        ? _formatMoney(account.balanceCapKobo, currency)
                        : '••••••',
                  ),
                  style: theme.textTheme.labelSmall,
                ),
              ),
            if (isStale)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  text.homeOfflineLastUpdated(
                    DateFormat('h:mm a').format(updatedAt.toLocal()),
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onSend,
    required this.onBills,
    required this.onAddMoney,
    required this.onCards,
    required this.onSavings,
  });

  final VoidCallback onSend;
  final VoidCallback onBills;
  final VoidCallback onAddMoney;
  final VoidCallback onCards;
  final VoidCallback onSavings;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final actions = [
      (text.homeQuickSend, Icons.north_east, onSend),
      (text.homeQuickBills, Icons.receipt_long_outlined, onBills),
      (text.homeQuickAddMoney, Icons.add, onAddMoney),
      (text.homeQuickCards, Icons.credit_card_outlined, onCards),
      (text.homeQuickSavings, Icons.savings_outlined, onSavings),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (label, icon, action) in actions)
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: SizedBox(
                width: 62,
                child: Column(
                  children: [
                    IconButton.filledTonal(
                      onPressed: action,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(52, 52),
                        maximumSize: const Size(52, 52),
                      ),
                      icon: Icon(icon),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardCarousel extends StatelessWidget {
  const _CardCarousel({
    required this.cards,
    required this.isStale,
    required this.updatedAt,
    required this.onManage,
  });

  final List<CardSummary> cards;
  final bool isStale;
  final DateTime updatedAt;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final card in cards)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _VirtualCardTile(card: card),
          ),
        _CreateCardTile(onTap: onManage),
        if (cards.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(
              child: Text(text.homeNoCards),
            ),
          ),
        if (isStale)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                text.homeOfflineLastUpdated(
                  DateFormat('h:mm a').format(updatedAt.toLocal()),
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
      ],
    );
  }
}

class _VirtualCardTile extends StatelessWidget {
  const _VirtualCardTile({required this.card});

  final CardSummary card;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final background = switch (card.theme) {
      'BERRY' => colors.primary,
      'MIDNIGHT' => colors.inverseSurface,
      'CORAL' => const Color(0xFFB34F3C),
      'FOREST' => const Color(0xFF1D6A53),
      'SAND' => const Color(0xFF93754C),
      'SLATE' => const Color(0xFF516274),
      _ => colors.secondaryContainer,
    };
    final foreground =
        card.theme == null ? colors.onSecondaryContainer : Colors.white;
    return SizedBox(
      width: 276,
      child: Card(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      card.label?.isNotEmpty == true
                          ? card.label!
                          : text.homeQuickCards,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusLabel(
                    label: _cardStatusLabel(text, card.status),
                    color: foreground.withValues(alpha: 0.18),
                    foreground: foreground,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                card.last4?.isNotEmpty == true ? '••••  ${card.last4}' : '••••',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: foreground,
                  letterSpacing: 2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text.appTitle,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foreground.withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateCardTile extends StatelessWidget {
  const _CreateCardTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return SizedBox(
      width: 148,
      child: Card.outlined(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, size: 36),
              const SizedBox(height: 8),
              Text(text.homeCreateCard, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({
    required this.transactions,
    required this.isStale,
    required this.updatedAt,
    required this.onTransactionTap,
  });

  final List<TransactionSummary> transactions;
  final bool isStale;
  final DateTime updatedAt;
  final ValueChanged<TransactionSummary> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    if (transactions.isEmpty) {
      return Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Text(text.homeNoTransactions, textAlign: TextAlign.center),
        ),
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < transactions.length; index++) ...[
            _TransactionRow(
              transaction: transactions[index],
              onTap: () => onTransactionTap(transactions[index]),
            ),
            if (index < transactions.length - 1) const Divider(height: 1),
          ],
          if (isStale)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text.homeOfflineLastUpdated(
                    DateFormat('h:mm a').format(updatedAt.toLocal()),
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction, required this.onTap});

  final TransactionSummary transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final debit = transaction.direction == 'D';
    final colors = Theme.of(context).colorScheme;
    final status = transaction.status;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor:
            debit ? colors.errorContainer : colors.tertiaryContainer,
        child: Icon(
          debit ? Icons.north_east : Icons.south_west,
          color: debit ? colors.onErrorContainer : colors.onTertiaryContainer,
        ),
      ),
      title: Text(
        _activityTitle(transaction, text),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${debit ? '−' : '+'}${_formatMoney(transaction.amountKobo, 'NGN')}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          _StatusLabel(
            label: _transactionStatusLabel(text, status),
            color: _transactionStatusColor(colors, status),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          TextButton(onPressed: onAction, child: Text(action)),
        ],
      );
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({
    required this.label,
    required this.color,
    this.foreground,
  });

  final String label;
  final Color color;
  final Color? foreground;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground ?? Theme.of(context).colorScheme.onSurface,
              ),
        ),
      );
}

class _HomeErrorCard extends StatelessWidget {
  const _HomeErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 8),
              _RetryButton(onPressed: onRetry),
            ],
          ),
        ),
      );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(message, textAlign: TextAlign.center),
            _RetryButton(onPressed: onRetry),
          ],
        ),
      );
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: Text(text.homeRetry),
    );
  }
}

class _BalanceSkeleton extends StatelessWidget {
  const _BalanceSkeleton();

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SkeletonBar(width: 140, height: 14),
              const SizedBox(height: 18),
              const _SkeletonBar(width: 220, height: 32),
              const SizedBox(height: 18),
              const _SkeletonBar(width: 190, height: 12),
              const SizedBox(height: 16),
              const _SkeletonBar(width: double.infinity, height: 1),
              const SizedBox(height: 16),
              const _SkeletonBar(width: 250, height: 14),
            ],
          ),
        ),
      );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) => const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SkeletonBar(width: 130, height: 14),
              _SkeletonBar(width: 160, height: 22),
              _SkeletonBar(width: 96, height: 12),
            ],
          ),
        ),
      );
}

class _ActivitySkeleton extends StatelessWidget {
  const _ActivitySkeleton();

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          children: [
            for (var index = 0; index < 5; index++) ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    _SkeletonBar(width: 42, height: 42, shape: BoxShape.circle),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBar(width: 132, height: 14),
                          SizedBox(height: 8),
                          _SkeletonBar(width: 180, height: 12),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    _SkeletonBar(width: 66, height: 14),
                  ],
                ),
              ),
              if (index < 4) const Divider(height: 1),
            ],
          ],
        ),
      );
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  });

  final double width;
  final double height;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(height / 2)
              : null,
          shape: shape,
        ),
        child: SizedBox(width: width, height: height),
      );
}

String _initials(String? name) {
  final parts = name?.trim().split(RegExp(r'\s+')) ?? const <String>[];
  final initials = parts
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part.characters.first.toUpperCase())
      .join();
  return initials.isEmpty ? 'Y' : initials;
}

String _activityTitle(
  TransactionSummary transaction,
  AppLocalizations text,
) {
  final counterparty = transaction.counterpartyName?.trim();
  if (counterparty != null && counterparty.isNotEmpty) return counterparty;
  final narration = transaction.narration?.trim();
  if (narration != null && narration.isNotEmpty) return narration;
  return text.homeTransactionGeneric;
}

String _formatMoney(int? amountKobo, String currency) {
  if (amountKobo == null) return '—';
  final amount = amountKobo / 100;
  if (currency == 'NGN') {
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(amount);
  }
  return NumberFormat.currency(locale: 'en_NG', name: currency).format(amount);
}

String _accountStatusLabel(AppLocalizations text, String status) =>
    switch (status) {
      'ACTIVE' => text.homeStatusActive,
      'LOCKED' => text.homeStatusLocked,
      'RESTRICTED' => text.homeStatusRestricted,
      'DORMANT' => text.homeStatusDormant,
      'CLOSED' => text.homeStatusClosed,
      _ => text.homeStatusUnavailable,
    };

Color _accountStatusColor(ColorScheme colors, String status) =>
    switch (status) {
      'ACTIVE' => colors.tertiaryContainer,
      'LOCKED' || 'RESTRICTED' || 'CLOSED' => colors.errorContainer,
      _ => colors.surfaceContainerHigh,
    };

String _cardStatusLabel(AppLocalizations text, String? status) =>
    switch (status) {
      'CREATING' => text.homeCardCreating,
      'ACTIVE' => text.homeCardActive,
      'FROZEN' => text.homeCardFrozen,
      'EXPIRED' => text.homeCardExpired,
      'DELETED' => text.homeCardDeleted,
      _ => text.homeStatusUnavailable,
    };

String _transactionStatusLabel(AppLocalizations text, String? status) =>
    switch (status) {
      'PENDING' => text.homeTxnPending,
      'SUCCESSFUL' => text.homeTxnSuccessful,
      'FAILED' => text.homeTxnFailed,
      'REVERSED' => text.homeTxnReversed,
      _ => text.homeStatusUnavailable,
    };

Color _transactionStatusColor(ColorScheme colors, String? status) =>
    switch (status) {
      'SUCCESSFUL' => colors.tertiaryContainer,
      'PENDING' => colors.secondaryContainer,
      'FAILED' => colors.errorContainer,
      _ => colors.surfaceContainerHigh,
    };
