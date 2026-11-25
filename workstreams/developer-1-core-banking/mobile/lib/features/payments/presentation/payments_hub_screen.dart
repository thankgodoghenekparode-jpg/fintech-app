import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../home/data/home_repository.dart';
import '../data/payments_repository.dart';

class PaymentsHubScreen extends ConsumerStatefulWidget {
  const PaymentsHubScreen({this.demo = false, super.key});

  final bool demo;

  @override
  ConsumerState<PaymentsHubScreen> createState() => _PaymentsHubScreenState();
}

class _PaymentsHubScreenState extends ConsumerState<PaymentsHubScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  VoidCallback? _open(String route) {
    if (widget.demo) {
      if (route == '/bills' || route == '/airtime') {
        return () => context.push('/demo/bills');
      }
      if (route == '/payment-unavailable') {
        return () => context.push('/demo/payment-unavailable');
      }
      return null;
    }
    return () => context.push(route);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final beneficiaries = ref.watch(beneficiariesProvider);
    final transactions = ref.watch(recentTransactionsProvider);
    final actions = _paymentActions(text);
    final filteredActions = actions
        .where((action) => action.label.toLowerCase().contains(_query))
        .toList(growable: false);
    final saved = beneficiaries.valueOrNull ?? const <BeneficiarySummary>[];
    final filteredRecipients = saved
        .where((item) =>
            item.displayName.toLowerCase().contains(_query) ||
            (item.bankCode ?? '').toLowerCase().contains(_query) ||
            (item.accountNumber ?? '').endsWith(_query))
        .toList(growable: false);
    final transfers = transactions.valueOrNull?.data
            .where(
                (item) => item.type?.toUpperCase().contains('TRANSFER') == true)
            .take(4)
            .toList(growable: false) ??
        const <TransactionSummary>[];

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: const Icon(Icons.account_circle_outlined),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to', style: Theme.of(context).textTheme.labelSmall),
            Text(text.paymentsTitle),
          ],
        ),
        actions: [
          IconButton(
            tooltip: text.paymentsHelpTooltip,
            onPressed: _open('/support'),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (widget.demo)
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DEMO DATA ONLY · Options and recipients below are fictional. Payment actions are disabled.',
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/demo/scheduled'),
                      icon: const Icon(Icons.event_repeat_outlined),
                      label: Text(text.paymentsScheduled),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/demo/bills'),
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: Text(text.paymentsBillsUtilities),
                    ),
                  ],
                ),
              ),
            ),
          TextField(
            controller: _searchController,
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: text.paymentsSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: text.paymentsClearSearch,
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          _SectionTitle(title: text.paymentsSendMoney),
          const SizedBox(height: 10),
          for (final action in filteredActions.where((item) => item.featured))
            _FeaturedPaymentAction(action: action, onTap: _open(action.route)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, _) {
              final cells = filteredActions
                  .where((item) => !item.featured && !item.isBill)
                  .toList(growable: false);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cells.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 112,
                ),
                itemBuilder: (context, index) => _PaymentActionCard(
                  action: cells[index],
                  onTap: _open(cells[index].route),
                ),
              );
            },
          ),
          if (_query.isNotEmpty &&
              filteredActions.isEmpty &&
              filteredRecipients.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(text.paymentsSearchEmpty),
            ),
          const SizedBox(height: 20),
          _SectionTitle(
            title: text.paymentsSavedRecipients,
            trailing: TextButton(
              onPressed: _open('/beneficiaries'),
              child: Text(text.paymentsViewAll),
            ),
          ),
          const SizedBox(height: 8),
          beneficiaries.when(
            skipLoadingOnRefresh: true,
            loading: () => const SizedBox(
              height: 78,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => _InlineError(
              message: text.paymentsRecipientsError,
              onRetry: () => ref.invalidate(beneficiariesProvider),
            ),
            data: (_) => filteredRecipients.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(text.paymentsNoRecipients),
                  )
                : SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredRecipients.take(5).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 14),
                      itemBuilder: (context, index) => _RecipientAvatar(
                        beneficiary: filteredRecipients[index],
                        onTap: _open('/send/recipient'),
                      ),
                    ),
                  ),
          ),
          if (filteredActions.any((item) => item.isBill)) ...[
            const SizedBox(height: 16),
            _SectionTitle(title: text.paymentsBillsUtilities),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      filteredActions.where((item) => item.isBill).length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 78,
                  ),
                  itemBuilder: (context, index) {
                    final billActions = filteredActions
                        .where((item) => item.isBill)
                        .toList(growable: false);
                    return _BillAction(
                      action: billActions[index],
                      onTap: _open(billActions[index].route),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          _SectionTitle(
            title: text.paymentsRecentTransfers,
            trailing: TextButton(
              onPressed: _open('/history'),
              child: Text(text.paymentsTransactionHistory),
            ),
          ),
          const SizedBox(height: 8),
          transactions.when(
            skipLoadingOnRefresh: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _InlineError(
              message: text.homeTransactionsLoadError,
              onRetry: () => ref.invalidate(recentTransactionsProvider),
            ),
            data: (_) => transfers.isEmpty
                ? Text(text.paymentsNoTransfers)
                : Card(
                    child: Column(
                      children: [
                        for (var index = 0;
                            index < transfers.length;
                            index++) ...[
                          if (index > 0) const Divider(height: 1),
                          _TransferRow(
                            transaction: transfers[index],
                            onTap: _open(
                              '/transactions/${Uri.encodeComponent(transfers[index].id)}',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _open('/send/recipient'),
              icon: const Icon(Icons.add),
              label: Text(text.paymentsNewPayment),
            ),
          ),
        ],
      ),
    );
  }
}

class BeneficiariesScreen extends ConsumerStatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  ConsumerState<BeneficiariesScreen> createState() =>
      _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends ConsumerState<BeneficiariesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _deleting = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _delete(BeneficiarySummary item) async {
    final text = AppLocalizations.of(context)!;
    final id = item.id;
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text.paymentsRecipientDeleteUnavailable)),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(text.paymentsRecipientDeleteTitle),
        content: Text(text.paymentsRecipientDeletePrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(text.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(text.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting.add(id));
    try {
      await ref.read(paymentsRepositoryProvider).deleteBeneficiary(id);
      ref.invalidate(beneficiariesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.paymentsRecipientDeleted)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text.paymentsRecipientDeleteError)),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final beneficiaries = ref.watch(beneficiariesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.paymentsSavedRecipients),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/send/recipient'),
            icon: const Icon(Icons.add),
            label: Text(text.commonAdd),
          ),
        ],
      ),
      body: beneficiaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _InlineError(
          message: text.paymentsRecipientsError,
          onRetry: () => ref.invalidate(beneficiariesProvider),
        ),
        data: (items) {
          final query = _query.toLowerCase();
          final filtered = items
              .where(
                (item) =>
                    item.displayName.toLowerCase().contains(query) ||
                    (item.bankCode ?? '').toLowerCase().contains(query) ||
                    (item.accountNumber ?? '').toLowerCase().contains(query),
              )
              .toList(growable: false);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: text.paymentsBeneficiarySearch,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: text.paymentsClearSearch,
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(items.isEmpty
                            ? text.paymentsNoRecipients
                            : text.paymentsSearchEmpty))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text(item.initials)),
                            title: Text(item.displayName.isEmpty
                                ? text.paymentsRecipientFallback
                                : item.displayName),
                            subtitle: Text(
                                '${item.bankCode ?? ''} · ${item.maskedAccountSuffix}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.favourite)
                                  const Icon(Icons.star, color: Colors.amber),
                                if (item.favourite) const SizedBox(width: 8),
                                IconButton(
                                  tooltip: text.paymentsRecipientDeleteAction,
                                  onPressed: item.id == null ||
                                          _deleting.contains(item.id)
                                      ? null
                                      : () => _delete(item),
                                  icon: _deleting.contains(item.id)
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2))
                                      : const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                            onTap: () => context.push('/send/recipient'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PaymentFlowUnavailableScreen extends StatelessWidget {
  const PaymentFlowUnavailableScreen({
    required this.title,
    this.bankCatalogBlock = false,
    super.key,
  });

  final String title;
  final bool bankCatalogBlock;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 42),
              const SizedBox(height: 16),
              Text(
                bankCatalogBlock
                    ? text.paymentsBankCatalogBlock
                    : text.paymentsFeatureUnavailable,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentAction {
  const _PaymentAction({
    required this.label,
    required this.icon,
    required this.route,
    this.subtitle,
    this.featured = false,
    this.isBill = false,
    this.stageTwo = false,
  });

  final String label;
  final String? subtitle;
  final IconData icon;
  final String route;
  final bool featured;
  final bool isBill;
  final bool stageTwo;
}

List<_PaymentAction> _paymentActions(AppLocalizations text) => [
      _PaymentAction(
        label: text.paymentsSendBank,
        subtitle: text.paymentsSendBankSubtitle,
        icon: Icons.account_balance_outlined,
        route: '/send/recipient',
        featured: true,
      ),
      _PaymentAction(
        label: text.paymentsSendSaved,
        icon: Icons.person_outline,
        route: '/beneficiaries',
      ),
      _PaymentAction(
        label: text.paymentsScanPay,
        icon: Icons.qr_code_scanner,
        route: '/qr',
      ),
      _PaymentAction(
        label: text.paymentsRequestMoney,
        subtitle: text.paymentsRequestSubtitle,
        icon: Icons.currency_exchange,
        route: '/request',
      ),
      _PaymentAction(
        label: text.paymentsAirtimeData,
        icon: Icons.phone_iphone,
        route: '/airtime',
        isBill: true,
      ),
      _PaymentAction(
        label: text.paymentsElectricity,
        icon: Icons.bolt_outlined,
        route: '/bills',
        isBill: true,
      ),
      _PaymentAction(
        label: text.paymentsInternetTv,
        icon: Icons.tv_outlined,
        route: '/bills',
        isBill: true,
      ),
      _PaymentAction(
        label: text.paymentsBetting,
        icon: Icons.sports_soccer_outlined,
        route: '/bills',
        isBill: true,
      ),
      _PaymentAction(
        label: text.paymentsDuesLevies,
        icon: Icons.account_balance_wallet_outlined,
        route: '/payment-unavailable',
        isBill: true,
        stageTwo: true,
      ),
      _PaymentAction(
        label: text.paymentsAllBills,
        icon: Icons.grid_view_outlined,
        route: '/bills',
        isBill: true,
      ),
      _PaymentAction(
        label: text.paymentsScheduled,
        icon: Icons.event_repeat_outlined,
        route: '/scheduled',
      ),
    ];

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class _FeaturedPaymentAction extends StatelessWidget {
  const _FeaturedPaymentAction({required this.action, required this.onTap});
  final _PaymentAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.primaryContainer,
                child: Icon(action.icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action.label,
                        style: Theme.of(context).textTheme.titleMedium),
                    if (action.subtitle != null) Text(action.subtitle!),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentActionCard extends StatelessWidget {
  const _PaymentActionCard({required this.action, required this.onTap});
  final _PaymentAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(action.icon),
                Text(action.label,
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
        ),
      );
}

class _BillAction extends StatelessWidget {
  const _BillAction({required this.action, required this.onTap});
  final _PaymentAction action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox.expand(
            child: Column(
              children: [
                CircleAvatar(child: Icon(action.icon)),
                const SizedBox(height: 6),
                Text(action.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),
        if (action.stageTwo)
          Positioned(
            top: -4,
            right: -4,
            child: Chip(
              label: Text(text.paymentsStage2),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }
}

class _RecipientAvatar extends StatelessWidget {
  const _RecipientAvatar({required this.beneficiary, required this.onTap});
  final BeneficiarySummary beneficiary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 82,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            children: [
              CircleAvatar(
                radius: 26,
                child: Text(beneficiary.initials),
              ),
              const SizedBox(height: 5),
              Text(
                beneficiary.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                beneficiary.maskedAccountSuffix,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      );
}

class _TransferRow extends StatelessWidget {
  const _TransferRow({required this.transaction, required this.onTap});
  final TransactionSummary transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final status = transaction.status?.toUpperCase();
    final amount = transaction.amountKobo == null
        ? '—'
        : NumberFormat.currency(locale: 'en_NG', symbol: '₦')
            .format(transaction.amountKobo! / 100);
    return ListTile(
      leading: CircleAvatar(
        child: Icon(status == 'FAILED' ? Icons.close : Icons.north_east),
      ),
      title: Text(transaction.counterpartyName ?? text.homeTransactionGeneric,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text([
        transaction.counterpartyBank,
        transaction.createdAt == null
            ? null
            : DateFormat('d MMM · h:mm a')
                .format(transaction.createdAt!.toLocal()),
        status == null ? null : _statusLabel(text, status),
      ].whereType<String>().join(' · ')),
      trailing: Text(amount),
      onTap: onTap,
    );
  }
}

String _statusLabel(AppLocalizations text, String status) => switch (status) {
      'SUCCESSFUL' => text.homeTxnSuccessful,
      'PENDING' => text.homeTxnPending,
      'FAILED' => text.homeTxnFailed,
      'REVERSED' => text.homeTxnReversed,
      _ => status,
    };

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(child: Text(message)),
              IconButton(
                tooltip: AppLocalizations.of(context)!.commonRetry,
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      );
}
