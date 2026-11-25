import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../data/home_repository.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  final List<TransactionSummary> _items = [];
  String? _cursor;
  String? _status;
  String? _type;
  String? _from;
  String? _to;
  Object? _error;
  bool _loading = true;
  bool _loadingMore = false;
  int _requestGeneration = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300 &&
        !_loading &&
        !_loadingMore &&
        _cursor != null) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (!reset && (_loadingMore || _cursor == null)) return;
    final generation = reset ? ++_requestGeneration : _requestGeneration;
    setState(() {
      if (reset) {
        _loading = true;
        _loadingMore = false;
        _items.clear();
        _cursor = null;
      } else {
        _loadingMore = true;
      }
      _error = null;
    });
    try {
      final page = await ref.read(homeRepositoryProvider).getTransactionPage(
            cursor: reset ? null : _cursor,
            status: _status,
            type: _type,
            from: _from,
            to: _to,
            query: _searchController.text,
          );
      if (!mounted || generation != _requestGeneration) return;
      setState(() {
        _items.addAll(page.items);
        _cursor = page.nextCursor;
      });
    } catch (error) {
      if (mounted && generation == _requestGeneration) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted && generation == _requestGeneration) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  Future<void> _chooseDates() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (range == null || !mounted) return;
    setState(() {
      _from = DateFormat('yyyy-MM-dd').format(range.start);
      _to = DateFormat('yyyy-MM-dd').format(range.end);
    });
    await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: text.commonBack,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(text.homeRecentActivity),
        actions: [
          IconButton(
            tooltip: text.historyExport,
            onPressed: () => context.push('/more/statements'),
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 350),
                      () => _load(reset: true),
                    );
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: text.historySearch,
                    suffixIcon: IconButton(
                      tooltip: text.historyDateRange,
                      onPressed: _chooseDates,
                      icon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_items
                        .map((item) => item.type)
                        .whereType<String>()
                        .toSet()
                        .isNotEmpty) ...[
                      ChoiceChip(
                        label: Text(_type ?? text.historyAllTypes),
                        selected: true,
                        onSelected: (_) => _selectType(),
                      ),
                      const SizedBox(width: 8),
                    ],
                    ChoiceChip(
                      label: Text(_status == null
                          ? text.historyAllStatuses
                          : _statusLabel(text, _status!)),
                      selected: true,
                      onSelected: (_) => _selectStatus(),
                    ),
                    const SizedBox(width: 8),
                    if (_from != null)
                      InputChip(
                        label: Text('$_from – $_to'),
                        onDeleted: () {
                          setState(() {
                            _from = null;
                            _to = null;
                          });
                          _load(reset: true);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null && _items.isEmpty
                    ? _HistoryError(
                        message: text.homeTransactionsLoadError,
                        retryText: text.commonRetry,
                        onRetry: () => _load(reset: true),
                      )
                    : _items.isEmpty
                        ? Center(child: Text(text.historyEmpty))
                        : RefreshIndicator(
                            onRefresh: () => _load(reset: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: _items.length +
                                  (_loadingMore ? 1 : 0) +
                                  (_error != null ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= _items.length) {
                                  if (_error != null) {
                                    return TextButton(
                                      onPressed: _load,
                                      child: Text(text.commonRetry),
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                                final item = _items[index];
                                final previousDate = index == 0
                                    ? null
                                    : _dateLabel(_items[index - 1].createdAt);
                                final date = _dateLabel(item.createdAt);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (date != previousDate)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 16, 0, 6),
                                        child: Text(
                                          date,
                                          style: theme.textTheme.labelLarge,
                                        ),
                                      ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        child: Icon(item.direction == 'C'
                                            ? Icons.south_west
                                            : Icons.north_east),
                                      ),
                                      title: Text(
                                        item.counterpartyName ??
                                            item.type ??
                                            text.transactionDetailTitle,
                                      ),
                                      subtitle: Text(item.subtitle),
                                      trailing: Text(_amount(item)),
                                      onTap: item.id.isEmpty
                                          ? null
                                          : () => context.push(
                                              '/transactions/${Uri.encodeComponent(item.id)}'),
                                    ),
                                    const Divider(height: 1),
                                  ],
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStatus() async {
    final text = AppLocalizations.of(context)!;
    final selected = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final value in <String?>[
              null,
              'PENDING',
              'SUCCESSFUL',
              'FAILED',
              'REVERSED',
            ])
              ListTile(
                title: Text(value == null
                    ? text.historyAllStatuses
                    : _statusLabel(text, value)),
                onTap: () => Navigator.pop(context, value ?? ''),
              ),
          ],
        ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _status = selected.isEmpty ? null : selected);
    await _load(reset: true);
  }

  Future<void> _selectType() async {
    final text = AppLocalizations.of(context)!;
    final types = _items
        .map((item) => item.type)
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final value in ['', ...types])
              ListTile(
                title: Text(value.isEmpty ? text.historyAllTypes : value),
                onTap: () => Navigator.pop(context, value),
              ),
          ],
        ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => _type = selected.isEmpty ? null : selected);
    await _load(reset: true);
  }

  String _amount(TransactionSummary item) {
    final amount = item.amountKobo;
    if (amount == null) return '—';
    final sign = item.direction == 'C' ? '+' : '−';
    return '$sign${NumberFormat.currency(locale: 'en_NG', symbol: '₦').format(amount / 100)}';
  }

  String _dateLabel(DateTime? date) => date == null
      ? '—'
      : DateFormat('EEEE, d MMMM yyyy').format(date.toLocal());
}

String _statusLabel(AppLocalizations text, String status) => switch (status) {
      'PENDING' => text.historyPending,
      'SUCCESSFUL' => text.historySuccessful,
      'FAILED' => text.historyFailed,
      'REVERSED' => text.historyReversed,
      _ => status,
    };

class _HistoryError extends StatelessWidget {
  const _HistoryError({
    required this.message,
    required this.retryText,
    required this.onRetry,
  });

  final String message;
  final String retryText;
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
              FilledButton(onPressed: onRetry, child: Text(retryText)),
            ],
          ),
        ),
      );
}
