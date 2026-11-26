import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_formatters.dart';
import 'insights_models.dart';

class RewardBudgetAndCostPage extends StatefulWidget {
  const RewardBudgetAndCostPage({
    required this.adapter,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback? onThemeToggle;

  @override
  State<RewardBudgetAndCostPage> createState() =>
      _RewardBudgetAndCostPageState();
}

class _RewardBudgetAndCostPageState extends State<RewardBudgetAndCostPage> {
  late Future<RewardCostSnapshot?> _budget;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _budget = widget.adapter.loadRewardCost();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Reward budget and cost'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<RewardCostSnapshot?>(
      future: _budget,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading reward budget and cost',
            ),
          );
        }
        if (snapshot.hasError) {
          return _CostState(
            icon: Icons.error_outline,
            title: 'Budget and cost could not be loaded',
            message: 'Check your Finance access and try again.',
            action: TextButton.icon(
              onPressed: () => setState(_load),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const _CostState(
            icon: Icons.cloud_off_outlined,
            title: 'Budget and cost unavailable',
            message: 'The host app has not supplied reward budget information.',
          );
        }
        if (!_hasData(data)) {
          return const _CostState(
            icon: Icons.insert_chart_outlined,
            title: 'No budget or spend data available',
            message: 'No dashboard values or alerts were provided by the host.',
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1360),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'Reward budget and cost',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (data.status != null) ...[
                      const SizedBox(height: 8),
                      _CostStatus(text: data.status!),
                    ],
                    if (data.exhaustedMessage != null) ...[
                      const SizedBox(height: 16),
                      _ExhaustedBanner(message: data.exhaustedMessage!),
                    ],
                    const SizedBox(height: 20),
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _BudgetSpendPanel(data: data)),
                          const SizedBox(width: 20),
                          Expanded(child: _AlertsPanel(alerts: data.alerts)),
                        ],
                      )
                    else ...[
                      _BudgetSpendPanel(data: data),
                      const SizedBox(height: 16),
                      _AlertsPanel(alerts: data.alerts),
                    ],
                    const SizedBox(height: 20),
                    const _PauseUnavailablePanel(),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

bool _hasData(RewardCostSnapshot data) =>
    data.budgetKobo != null ||
    data.spendKobo != null ||
    data.budgetFraction != null ||
    data.spendFraction != null ||
    data.status != null ||
    data.exhaustedMessage != null ||
    data.alerts.isNotEmpty;

class _BudgetSpendPanel extends StatelessWidget {
  const _BudgetSpendPanel({required this.data});
  final RewardCostSnapshot data;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget vs spend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          _BudgetSpendBar(
            label: 'Budget',
            amountKobo: data.budgetKobo,
            fraction: data.budgetFraction,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          _BudgetSpendBar(
            label: 'Spend',
            amountKobo: data.spendKobo,
            fraction: data.spendFraction,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    ),
  );
}

class _BudgetSpendBar extends StatelessWidget {
  const _BudgetSpendBar({
    required this.label,
    required this.amountKobo,
    required this.fraction,
    required this.color,
  });

  final String label;
  final int? amountKobo;
  final double? fraction;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Text(
            formatInsightsMoney(amountKobo),
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ],
      ),
      const SizedBox(height: 8),
      if (fraction == null)
        const Text('Chart value unavailable')
      else
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: fraction!.clamp(0.0, 1.0).toDouble(),
            minHeight: 12,
            color: color,
            backgroundColor: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
          ),
        ),
    ],
  );
}

class _AlertsPanel extends StatelessWidget {
  const _AlertsPanel({required this.alerts});
  final List<RewardCostAlert> alerts;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alerts', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (alerts.isEmpty)
            const Text('No reward budget alerts were provided by the host.')
          else
            ...alerts.map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert.message),
                          if (alert.status != null)
                            Text(
                              alert.status!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _CostStatus extends StatelessWidget {
  const _CostStatus({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.info_outline, size: 18),
      const SizedBox(width: 6),
      Flexible(child: Text(text)),
    ],
  );
}

class _ExhaustedBanner extends StatelessWidget {
  const _ExhaustedBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_outlined),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}

class _PauseUnavailablePanel extends StatelessWidget {
  const _PauseUnavailablePanel();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pause and resume controls are unavailable because no corresponding host operation is documented.',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.pause_circle_outline),
            label: const Text('Pause / resume unavailable'),
          ),
        ],
      ),
    ),
  );
}

class _CostState extends StatelessWidget {
  const _CostState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(message),
                if (action != null) ...[const SizedBox(height: 12), action!],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
