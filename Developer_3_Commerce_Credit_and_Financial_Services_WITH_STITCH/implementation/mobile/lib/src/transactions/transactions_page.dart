import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../business_home/business_home_tokens.dart';
import '../money_operations/money_operation_components.dart';

enum TransactionFlow { incoming, outgoing }

enum TransactionFilter { all, collections, payouts }

enum MerchantTransactionState { pending, completed, failed, reversed }

class MerchantTransactionRow {
  const MerchantTransactionRow({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amountKobo,
    required this.flow,
    required this.state,
    this.canRefund = false,
  });
  final String id, title, subtitle;
  final int amountKobo;
  final TransactionFlow flow;
  final MerchantTransactionState state;
  final bool canRefund;
}

class VerifiedPayoutDestination {
  const VerifiedPayoutDestination({required this.id, required this.label});
  final String id, label;
}

class TransactionsSnapshot {
  const TransactionsSnapshot({
    required this.availableBalanceKobo,
    required this.transactions,
    this.verifiedDestinations = const [],
    this.mayRequestPayout = false,
    this.payoutBlockedReason,
  });
  final int availableBalanceKobo;
  final List<MerchantTransactionRow> transactions;
  final List<VerifiedPayoutDestination> verifiedDestinations;
  final bool mayRequestPayout;
  final String? payoutBlockedReason;
}

abstract interface class MerchantTransactionsAdapter {
  Future<TransactionsSnapshot> load({
    required String tenantId,
    DateTime? from,
    DateTime? to,
  });
  Future<void> requestPayout({
    required String tenantId,
    required int amountKobo,
    required String destinationId,
  });
}

final merchantTransactionsAdapterProvider =
    Provider<MerchantTransactionsAdapter>(
      (ref) => throw StateError(
        'MerchantTransactionsAdapter must be provided by host.',
      ),
    );

class PayoutOperationException implements Exception {
  const PayoutOperationException({
    required this.outcomeUnknown,
    this.isOffline = false,
    this.message,
  });
  final bool outcomeUnknown, isOffline;
  final String? message;
}

abstract interface class TransactionsCopy {
  String get title;
  String get back;
  String get balance;
  String get payout;
  String get all;
  String get collections;
  String get payouts;
  String get empty;
  String get loadingError;
  String get retry;
  String get pending;
  String get completed;
  String get failed;
  String get reversed;
  String get payoutTitle;
  String get amount;
  String get destination;
  String get confirmPayout;
  String get submitting;
  String get payoutPending;
  String get payoutError;
  String get offlineError;
  String get unknownOutcome;
  String get blocked;
  String get statement;
  String get dateFilter;
  String formatMoney(int kobo);
}

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({
    required this.tenantId,
    required this.copy,
    required this.tokens,
    this.onBack,
    this.onOpenRefund,
    this.onStatement,
    super.key,
  });
  final String tenantId;
  final TransactionsCopy copy;
  final MerchantHomeTokens tokens;
  final VoidCallback? onBack;
  final ValueChanged<String>? onOpenRefund;
  final VoidCallback? onStatement;
  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  late Future<TransactionsSnapshot> _future;
  TransactionFilter _filter = TransactionFilter.all;
  DateTime? _from, _to;
  String? _payoutMessage;
  bool _payoutUnknown = false;
  bool _submitting = false;
  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<TransactionsSnapshot> _load() => ref
      .read(merchantTransactionsAdapterProvider)
      .load(tenantId: widget.tenantId, from: _from, to: _to);
  void _refresh({bool clearMessage = true}) => setState(() {
    if (clearMessage) _payoutMessage = null;
    _future = _load();
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(widget.tokens.pageGutter),
            child: Row(
              children: [
                IconButton(
                  tooltip: widget.copy.back,
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    widget.copy.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (widget.onStatement != null)
                  IconButton(
                    tooltip: widget.copy.statement,
                    onPressed: widget.onStatement,
                    icon: const Icon(Icons.description_outlined),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<TransactionsSnapshot>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError || !snapshot.hasData)
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.copy.loadingError),
                        TextButton(
                          onPressed: _refresh,
                          child: Text(widget.copy.retry),
                        ),
                      ],
                    ),
                  );
                final data = snapshot.data!;
                final rows = data.transactions
                    .where(
                      (row) =>
                          _filter == TransactionFilter.all ||
                          (_filter == TransactionFilter.collections &&
                              row.flow == TransactionFlow.incoming) ||
                          (_filter == TransactionFilter.payouts &&
                              row.flow == TransactionFlow.outgoing),
                    )
                    .toList();
                return ListView(
                  padding: EdgeInsets.all(widget.tokens.pageGutter),
                  children: [
                    Card.outlined(
                      child: Padding(
                        padding: EdgeInsets.all(widget.tokens.cardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.copy.balance,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: widget.tokens.smallGap),
                            Text(
                              widget.copy.formatMoney(
                                data.availableBalanceKobo,
                              ),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: widget.tokens.elementGap),
                    FilledButton.icon(
                      onPressed:
                          data.mayRequestPayout &&
                              data.verifiedDestinations.isNotEmpty &&
                              !_payoutUnknown
                          ? () => _showPayout(data)
                          : null,
                      icon: const Icon(Icons.account_balance_outlined),
                      label: Text(widget.copy.payout),
                    ),
                    if (!data.mayRequestPayout ||
                        data.verifiedDestinations.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: widget.tokens.smallGap),
                        child: Text(
                          data.payoutBlockedReason ?? widget.copy.blocked,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    if (_payoutMessage != null)
                      Padding(
                        padding: EdgeInsets.only(top: widget.tokens.smallGap),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(_payoutMessage!),
                        ),
                      ),
                    SizedBox(height: widget.tokens.sectionGap),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<TransactionFilter>(
                          segments: [
                            ButtonSegment(
                              value: TransactionFilter.all,
                              label: Text(widget.copy.all),
                            ),
                            ButtonSegment(
                              value: TransactionFilter.collections,
                              label: Text(widget.copy.collections),
                            ),
                            ButtonSegment(
                              value: TransactionFilter.payouts,
                              label: Text(widget.copy.payouts),
                            ),
                          ],
                          selected: {_filter},
                          onSelectionChanged: (v) =>
                              setState(() => _filter = v.single),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: widget.copy.dateFilter,
                            onPressed: _chooseDateRange,
                            icon: Icon(
                              _from == null
                                  ? Icons.date_range_outlined
                                  : Icons.event_available_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.tokens.elementGap),
                    if (rows.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(widget.tokens.cardPadding),
                        child: Center(child: Text(widget.copy.empty)),
                      )
                    else
                      ...rows.map(
                        (row) => Card.outlined(
                          margin: EdgeInsets.only(
                            bottom: widget.tokens.smallGap,
                          ),
                          child: ListTile(
                            title: Text(row.title),
                            subtitle: Text(
                              '${row.subtitle}\n${_stateLabel(row.state)}',
                            ),
                            isThreeLine: true,
                            leading: Icon(
                              row.flow == TransactionFlow.incoming
                                  ? Icons.south_west
                                  : Icons.north_east,
                            ),
                            trailing: Text(
                              '${row.flow == TransactionFlow.incoming ? '+' : '−'}${widget.copy.formatMoney(row.amountKobo)}',
                            ),
                            onTap: row.canRefund && widget.onOpenRefund != null
                                ? () => widget.onOpenRefund!(row.id)
                                : null,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );

  String _stateLabel(MerchantTransactionState state) => switch (state) {
    MerchantTransactionState.pending => widget.copy.pending,
    MerchantTransactionState.completed => widget.copy.completed,
    MerchantTransactionState.failed => widget.copy.failed,
    MerchantTransactionState.reversed => widget.copy.reversed,
  };

  Future<void> _chooseDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _from == null || _to == null
          ? null
          : DateTimeRange(start: _from!, end: _to!),
    );
    if (range == null || !mounted) return;
    setState(() {
      _from = DateTime(range.start.year, range.start.month, range.start.day);
      _to = DateTime(
        range.end.year,
        range.end.month,
        range.end.day,
        23,
        59,
        59,
      );
      _future = _load();
    });
  }

  Future<void> _showPayout(TransactionsSnapshot data) async {
    final amount = TextEditingController();
    String? destination = data.verifiedDestinations.first.id;
    String? error;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            widget.tokens.pageGutter,
            widget.tokens.sectionGap,
            widget.tokens.pageGutter,
            MediaQuery.viewInsetsOf(context).bottom + widget.tokens.sectionGap,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.copy.payoutTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: widget.copy.amount),
                onChanged: (_) => setSheet(() => error = null),
              ),
              SizedBox(height: widget.tokens.elementGap),
              DropdownButtonFormField<String>(
                value: destination,
                decoration: InputDecoration(labelText: widget.copy.destination),
                items: data.verifiedDestinations
                    .map(
                      (d) =>
                          DropdownMenuItem(value: d.id, child: Text(d.label)),
                    )
                    .toList(),
                onChanged: (v) => setSheet(() => destination = v),
              ),
              if (error != null)
                Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              SizedBox(height: widget.tokens.elementGap),
              FilledButton(
                onPressed: _submitting
                    ? null
                    : () async {
                        final kobo = parseNairaToKobo(amount.text);
                        if (kobo == null || destination == null) {
                          setSheet(() => error = widget.copy.payoutError);
                          return;
                        }
                        setState(() => _submitting = true);
                        try {
                          await ref
                              .read(merchantTransactionsAdapterProvider)
                              .requestPayout(
                                tenantId: widget.tenantId,
                                amountKobo: kobo,
                                destinationId: destination!,
                              );
                          if (context.mounted) Navigator.pop(context);
                          if (mounted) {
                            setState(
                              () => _payoutMessage = widget.copy.payoutPending,
                            );
                            _refresh(clearMessage: false);
                          }
                        } on PayoutOperationException catch (e) {
                          if (mounted)
                            setState(() {
                              _payoutUnknown = e.outcomeUnknown;
                              _payoutMessage = e.outcomeUnknown
                                  ? widget.copy.unknownOutcome
                                  : e.isOffline
                                  ? widget.copy.offlineError
                                  : (e.message ?? widget.copy.payoutError);
                            });
                          if (context.mounted) Navigator.pop(context);
                        } catch (_) {
                          if (mounted)
                            setState(() {
                              _payoutUnknown = true;
                              _payoutMessage = widget.copy.unknownOutcome;
                            });
                          if (context.mounted) Navigator.pop(context);
                        } finally {
                          if (mounted) setState(() => _submitting = false);
                        }
                      },
                child: Text(
                  _submitting
                      ? widget.copy.submitting
                      : widget.copy.confirmPayout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
