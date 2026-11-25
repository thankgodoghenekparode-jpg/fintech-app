import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'business_home_adapter.dart';
import 'business_home_copy.dart';
import 'business_home_tokens.dart';

enum MerchantHomeAction {
  collect,
  paymentLink,
  invoice,
  refund,
  createBusiness,
}

/// S-MER-001, mobile Business Home.
///
/// The host supplies tenant context, copy, design-token metrics and action
/// callbacks. This feature does not own authentication, global navigation or
/// an API client.
class MerchantHomePage extends ConsumerWidget {
  const MerchantHomePage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    required this.onAction,
    required this.onSwitchBusiness,
    super.key,
  });

  final String tenantId;
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final ValueChanged<MerchantHomeAction> onAction;
  final VoidCallback onSwitchBusiness;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(merchantHomeSnapshotProvider(tenantId));
    return Scaffold(
      body: SafeArea(
        child: Semantics(
          namesRoute: true,
          label: copy.title,
          child: state.when(
            loading: () => _LoadingState(copy: copy, tokens: tokens),
            error: (error, stack) => _ErrorState(
              copy: copy,
              tokens: tokens,
              offline: error is MerchantHomeOfflineException,
              onRetry: () =>
                  ref.invalidate(merchantHomeSnapshotProvider(tenantId)),
            ),
            data: (snapshot) => snapshot == null
                ? _EmptyState(
                    copy: copy,
                    tokens: tokens,
                    onCreate: () => onAction(MerchantHomeAction.createBusiness),
                  )
                : _BusinessHomeContent(
                    snapshot: snapshot,
                    copy: copy,
                    tokens: tokens,
                    onAction: onAction,
                    onSwitchBusiness: onSwitchBusiness,
                  ),
          ),
        ),
      ),
    );
  }
}

class _BusinessHomeContent extends StatefulWidget {
  const _BusinessHomeContent({
    required this.snapshot,
    required this.copy,
    required this.tokens,
    required this.onAction,
    required this.onSwitchBusiness,
  });

  final MerchantHomeSnapshot snapshot;
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final ValueChanged<MerchantHomeAction> onAction;
  final VoidCallback onSwitchBusiness;

  @override
  State<_BusinessHomeContent> createState() => _BusinessHomeContentState();
}

class _BusinessHomeContentState extends State<_BusinessHomeContent> {
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final t = widget.tokens;
    final copy = widget.copy;

    return CustomScrollView(
      key: const ValueKey('merchant-home-content'),
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              t.pageGutter,
              t.smallGap,
              t.pageGutter,
              t.smallGap,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final avatar = CircleAvatar(
                  backgroundColor: color.primaryContainer,
                  foregroundColor: color.onPrimaryContainer,
                  child: Text(_initials(widget.snapshot.businessName)),
                );
                final businessSwitcher = Tooltip(
                  message: copy.switchBusiness,
                  child: TextButton(
                    onPressed: widget.onSwitchBusiness,
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 48),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.snapshot.businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: color.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                );

                if (constraints.maxWidth < 320 && widget.snapshot.isVerified) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          avatar,
                          SizedBox(width: t.elementGap),
                          Expanded(child: businessSwitcher),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 40 + t.elementGap,
                          top: t.smallGap,
                        ),
                        child: _VerifiedBadge(
                          label: copy.verified,
                          tokens: t,
                          compact: true,
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    avatar,
                    SizedBox(width: t.elementGap),
                    Expanded(child: businessSwitcher),
                    if (widget.snapshot.isVerified) ...[
                      SizedBox(width: t.smallGap),
                      _VerifiedBadge(label: copy.verified, tokens: t),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            t.pageGutter,
            t.elementGap,
            t.pageGutter,
            0,
          ),
          sliver: SliverList.list(
            children: [
              if (widget.snapshot.isRestricted) ...[
                _RestrictedBanner(copy: copy, tokens: t),
                SizedBox(height: t.sectionGap),
              ],
              _BalanceCard(
                snapshot: widget.snapshot,
                copy: copy,
                tokens: t,
                balanceVisible: _balanceVisible,
                onToggleBalance: () =>
                    setState(() => _balanceVisible = !_balanceVisible),
              ),
              SizedBox(height: t.sectionGap),
              _QuickActions(copy: copy, tokens: t, onAction: widget.onAction),
              SizedBox(height: t.sectionGap),
              _RecentPayments(snapshot: widget.snapshot, copy: copy, tokens: t),
              SizedBox(height: t.sectionGap),
            ],
          ),
        ),
      ],
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2);
  final initials = parts
      .map((part) => String.fromCharCode(part.runes.first).toUpperCase())
      .join();
  return initials;
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({
    required this.label,
    required this.tokens,
    this.compact = false,
  });
  final String label;
  final MerchantHomeTokens tokens;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.secondaryContainer,
        borderRadius: BorderRadius.circular(tokens.controlRadius),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? tokens.smallGap / 2 : tokens.smallGap,
          vertical: tokens.smallGap / 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 18, color: color.onSecondaryContainer),
            SizedBox(
                width: compact ? tokens.smallGap / 4 : tokens.smallGap / 2),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestrictedBanner extends StatelessWidget {
  const _RestrictedBanner({required this.copy, required this.tokens});
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(tokens.cardPadding),
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(tokens.controlRadius),
          border: Border.all(color: color.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: color.onSurfaceVariant),
            SizedBox(width: tokens.elementGap),
            Expanded(
              child: Text(
                copy.restricted,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.snapshot,
    required this.copy,
    required this.tokens,
    required this.balanceVisible,
    required this.onToggleBalance,
  });
  final MerchantHomeSnapshot snapshot;
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final amountStyle = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Container(
      padding: EdgeInsets.all(tokens.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  copy.availableBalance,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
              IconButton(
                tooltip: balanceVisible ? copy.hideBalance : copy.showBalance,
                onPressed: onToggleBalance,
                icon: Icon(
                  balanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ],
          ),
          Semantics(
            label: balanceVisible ? copy.availableBalance : copy.balanceHidden,
            child: Text(
              balanceVisible
                  ? copy.formatMoney(snapshot.availableBalanceKobo)
                  : '••••••••',
              style: amountStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: tokens.cardPadding),
          Divider(color: color.outlineVariant),
          SizedBox(height: tokens.smallGap),
          Row(
            children: [
              Icon(Icons.payments_outlined, color: color.primary),
              SizedBox(width: tokens.smallGap),
              Expanded(
                child: Text(
                  copy.todaySales,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                copy.formatMoney(snapshot.todaySalesKobo),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.copy,
    required this.tokens,
    required this.onAction,
  });
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final ValueChanged<MerchantHomeAction> onAction;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final actions = <(MerchantHomeAction, String, IconData)>[
      (MerchantHomeAction.collect, copy.collect, Icons.point_of_sale_outlined),
      (
        MerchantHomeAction.paymentLink,
        copy.paymentLinkAction,
        Icons.link_outlined,
      ),
      (MerchantHomeAction.invoice, copy.invoice, Icons.receipt_long_outlined),
      (
        MerchantHomeAction.refund,
        copy.refund,
        Icons.assignment_return_outlined,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(copy.quickActions, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: tokens.smallGap),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                if (index > 0) SizedBox(width: tokens.smallGap),
                Expanded(
                  child: Material(
                    key: ValueKey(
                      'business-home-action-${actions[index].$1.name}',
                    ),
                    color: color.surface,
                    borderRadius: BorderRadius.circular(tokens.controlRadius),
                    child: InkWell(
                      onTap: () => onAction(actions[index].$1),
                      borderRadius: BorderRadius.circular(tokens.controlRadius),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 96),
                        padding: EdgeInsets.all(tokens.smallGap),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            tokens.controlRadius,
                          ),
                          border: Border.all(color: color.outlineVariant),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: color.primaryContainer,
                              foregroundColor: color.onPrimaryContainer,
                              child: Icon(actions[index].$3),
                            ),
                            SizedBox(height: tokens.smallGap),
                            Text(
                              actions[index].$2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentPayments extends StatelessWidget {
  const _RecentPayments({
    required this.snapshot,
    required this.copy,
    required this.tokens,
  });
  final MerchantHomeSnapshot snapshot;
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(copy.recentPayments, style: theme.textTheme.titleMedium),
        SizedBox(height: tokens.smallGap),
        if (snapshot.recentPayments.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(tokens.cardPadding),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(tokens.cardRadius),
              border: Border.all(color: color.outlineVariant),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: color.onSurfaceVariant,
                ),
                SizedBox(height: tokens.smallGap),
                Text(copy.noPaymentsTitle, style: theme.textTheme.titleSmall),
                Text(
                  copy.noPaymentsBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(tokens.cardRadius),
              border: Border.all(color: color.outlineVariant),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokens.cardRadius),
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.recentPayments.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: color.outlineVariant),
                    _PaymentRow(
                      payment: snapshot.recentPayments[i],
                      copy: copy,
                      tokens: tokens,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.payment,
    required this.copy,
    required this.tokens,
  });
  final MerchantPaymentSummary payment;
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final (channel, icon) = switch (payment.channel) {
      MerchantPaymentChannel.qr => (copy.qrChannel, Icons.qr_code_2_outlined),
      MerchantPaymentChannel.paymentLink => (
          copy.paymentLinkChannel,
          Icons.link_outlined,
        ),
      MerchantPaymentChannel.bankTransfer => (
          copy.bankTransferChannel,
          Icons.account_balance_outlined,
        ),
    };
    final status = switch (payment.status) {
      MerchantPaymentStatus.settled => copy.settled,
      MerchantPaymentStatus.pending => copy.pending,
      MerchantPaymentStatus.failed => copy.failed,
    };
    final statusIcon = switch (payment.status) {
      MerchantPaymentStatus.settled => Icons.check_circle_outline,
      MerchantPaymentStatus.pending => Icons.schedule,
      MerchantPaymentStatus.failed => Icons.error_outline,
    };
    return Padding(
      padding: EdgeInsets.all(tokens.cardPadding),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.surfaceContainerLow,
            foregroundColor: color.primary,
            child: Icon(icon),
          ),
          SizedBox(width: tokens.elementGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.counterparty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$channel · ${copy.formatPaymentDate(payment.occurredAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: tokens.smallGap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                copy.formatMoney(payment.amountKobo),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Semantics(
                label: copy.paymentStatus,
                value: status,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 16, color: color.onSurfaceVariant),
                    SizedBox(width: tokens.smallGap / 2),
                    Text(
                      status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.copy, required this.tokens});
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Semantics(
      label: copy.loading,
      liveRegion: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(tokens.pageGutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _SkeletonBar(
                color: color.surfaceContainerLow,
                height: 48,
                radius: tokens.controlRadius,
              ),
              SizedBox(height: tokens.sectionGap),
              _SkeletonBar(
                color: color.surfaceContainerLow,
                height: 230,
                radius: tokens.cardRadius,
              ),
              SizedBox(height: tokens.sectionGap),
              _SkeletonBar(
                color: color.surfaceContainerLow,
                height: 96,
                radius: tokens.controlRadius,
              ),
              SizedBox(height: tokens.sectionGap),
              _SkeletonBar(
                color: color.surfaceContainerLow,
                height: 180,
                radius: tokens.cardRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    required this.color,
    required this.height,
    required this.radius,
  });
  final Color color;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.copy,
    required this.tokens,
    required this.onCreate,
  });
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(tokens.pageGutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: tokens.elementGap),
              Text(
                copy.emptyTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.smallGap),
              Text(copy.emptyBody, textAlign: TextAlign.center),
              SizedBox(height: tokens.sectionGap),
              FilledButton(
                  onPressed: onCreate, child: Text(copy.createBusiness)),
            ],
          ),
        ),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.copy,
    required this.tokens,
    required this.offline,
    required this.onRetry,
  });
  final MerchantHomeCopy copy;
  final MerchantHomeTokens tokens;
  final bool offline;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(tokens.pageGutter),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                offline ? Icons.wifi_off_outlined : Icons.cloud_off_outlined,
                size: 48,
                color: offline
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: tokens.elementGap),
              Text(
                offline ? copy.offlineTitle : copy.errorTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.smallGap),
              Text(
                offline ? copy.offlineBody : copy.errorBody,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.sectionGap),
              OutlinedButton(onPressed: onRetry, child: Text(copy.retry)),
            ],
          ),
        ),
      );
}
