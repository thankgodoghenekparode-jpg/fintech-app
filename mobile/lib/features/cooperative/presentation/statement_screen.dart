import 'package:flutter/material.dart';

class CooperativeStatementScreen extends StatefulWidget {
  const CooperativeStatementScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  State<CooperativeStatementScreen> createState() =>
      _CooperativeStatementScreenState();
}

class _CooperativeStatementScreenState
    extends State<CooperativeStatementScreen> {
  DateTimeRange? _range;

  Future<void> _chooseRange() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: today,
      initialDateRange: _range,
    );
    if (selected != null) setState(() => _range = selected);
  }

  String _rangeLabel(BuildContext context) {
    if (_range == null) return 'Choose date range';
    final dates = MaterialLocalizations.of(context);
    return '${dates.formatShortDate(_range!.start)} – ${dates.formatShortDate(_range!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My statement'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Savings'),
              Tab(text: 'Shares'),
              Tab(text: 'Loans'),
              Tab(text: 'Guarantees'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _chooseRange,
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(_rangeLabel(context)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const IconButton(
                      onPressed: null,
                      tooltip: 'Download PDF unavailable',
                      icon: Icon(Icons.download_outlined),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Group reference: ${widget.cooperativeId}',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    for (final section in const [
                      'Savings',
                      'Shares',
                      'Loans',
                      'Guarantees',
                    ])
                      _StatementUnavailable(section: section),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Statement response fields and PDF delivery are not defined yet. No statement data or file is available.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatementUnavailable extends StatelessWidget {
  const _StatementUnavailable({required this.section});

  final String section;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 36, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text('$section statement is unavailable',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              const Text(
                'The statement endpoint has no response schema.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
