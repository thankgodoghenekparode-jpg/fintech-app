import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_formatters.dart';
import 'insights_models.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({
    required this.adapter,
    required this.onCreate,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback onCreate;
  final VoidCallback? onThemeToggle;

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  late Future<BudgetSnapshot?> _budgets;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _budgets = widget.adapter.loadBudgets();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Budgets'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<BudgetSnapshot?>(
      future: _budgets,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(semanticsLabel: 'Loading budgets'),
          );
        }
        if (snapshot.hasError) {
          return _BudgetState(
            icon: Icons.error_outline,
            title: 'Budgets could not be loaded',
            description: 'Check your connection and try again.',
            action: TextButton.icon(
              onPressed: () => setState(_load),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const _BudgetState(
            icon: Icons.cloud_off_outlined,
            title: 'Budgets unavailable',
            description: 'Your host app has not supplied budget information.',
          );
        }
        if (data.personalisedConsent == false) {
          return const _BudgetState(
            icon: Icons.lock_outline,
            title: 'Insights consent is off',
            description: 'Turn on personalised insights in Preferences to view this data.',
          );
        }
        if (data.budgets.isEmpty) {
          return _BudgetState(
            icon: Icons.pie_chart_outline,
            title: 'No budgets yet',
            description: 'Create a monthly budget to see its progress here.',
            action: FilledButton.icon(
              onPressed: widget.onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Add budget'),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              'Your monthly budgets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...data.budgets.map((budget) => _BudgetCard(budget: budget)),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Add budget'),
            ),
          ],
        );
      },
    ),
  );
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.budget});
  final BudgetEntry budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = budget.progressFraction;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    budget.category,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                if (budget.progressStatus != null)
                  _StatusLabel(text: budget.progressStatus!),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BudgetAmount(
                    label: 'Monthly budget',
                    amount: budget.amountKobo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BudgetAmount(
                    label: 'Remaining',
                    amount: budget.remainingKobo,
                  ),
                ),
              ],
            ),
            if (budget.spentKobo != null) ...[
              const SizedBox(height: 12),
              Text(
                'Spent ${formatInsightsMoney(budget.spentKobo)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (progress != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0).toDouble(),
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BudgetAmount extends StatelessWidget {
  const _BudgetAmount({required this.label, required this.amount});
  final String label;
  final int? amount;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 4),
      Text(
        formatInsightsMoney(amount),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  );
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.info_outline, size: 16),
      const SizedBox(width: 4),
      Text(text, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _BudgetState extends StatelessWidget {
  const _BudgetState({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(description),
                if (action != null) ...[const SizedBox(height: 16), action!],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({
    required this.adapter,
    required this.onComplete,
    this.lastMonthSuggestions = const [],
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final VoidCallback onComplete;
  final List<BudgetSuggestion> lastMonthSuggestions;
  final VoidCallback? onThemeToggle;

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _category = TextEditingController();
  final _amount = TextEditingController();
  final Set<int> _alerts = {};
  bool _submitting = false;
  bool _created = false;

  @override
  void dispose() {
    _category.dispose();
    _amount.dispose();
    super.dispose();
  }

  BudgetSuggestion? get _matchingSuggestion {
    final category = _category.text.trim().toLowerCase();
    if (category.isEmpty) return null;
    for (final suggestion in widget.lastMonthSuggestions) {
      if (suggestion.category.trim().toLowerCase() == category) {
        return suggestion;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Create budget'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: _created
        ? _BudgetCreated(onComplete: widget.onComplete)
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Text(
                  'Set a monthly amount for a category.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _category,
                  onChanged: (_) => setState(() {}),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Enter a category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a category.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Monthly amount',
                    prefixText: '₦ ',
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    final kobo = _parseNairaToKobo(value ?? '');
                    if (kobo == null || kobo <= 0) {
                      return 'Enter an amount greater than zero.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Alert thresholds',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose when you want an alert. These thresholds are configurable.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [80, 100]
                      .map(
                        (threshold) => FilterChip(
                          label: Text('$threshold%'),
                          selected: _alerts.contains(threshold),
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              _alerts.add(threshold);
                            } else {
                              _alerts.remove(threshold);
                            }
                          }),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                _SuggestionCard(
                  suggestion: _matchingSuggestion,
                  hasAnySuggestions: widget.lastMonthSuggestions.isNotEmpty,
                  onUse: (suggestion) {
                    _amount.text = _formatNairaInput(suggestion.amountKobo);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save budget'),
                ),
              ],
            ),
          ),
  );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amountKobo = _parseNairaToKobo(_amount.text)!;
    setState(() => _submitting = true);
    try {
      await widget.adapter.createBudget(
        category: _category.text.trim(),
        amountKobo: amountKobo,
        alerts: _alerts.toList()..sort(),
      );
      if (mounted) setState(() => _created = true);
    } catch (error) {
      if (mounted) {
        final message = error is InsightsHostUnavailable
            ? error.message
            : 'Budget could not be saved. Check your access and try again.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.hasAnySuggestions,
    required this.onUse,
  });

  final BudgetSuggestion? suggestion;
  final bool hasAnySuggestions;
  final ValueChanged<BudgetSuggestion> onUse;

  @override
  Widget build(BuildContext context) {
    final item = suggestion;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: item == null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hasAnySuggestions
                          ? 'A suggestion will appear when a matching category is entered.'
                          : 'A previous-month suggestion is unavailable because the host did not supply one.',
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Based on last month',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.sourceLabel}: ${formatInsightsMoney(item.amountKobo)}',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => onUse(item),
                      child: const Text('Use suggestion'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BudgetCreated extends StatelessWidget {
  const _BudgetCreated({required this.onComplete});
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle_outline, size: 32),
              const SizedBox(height: 12),
              Text(
                'Budget created',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('The host accepted the documented budget request.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onComplete,
                child: const Text('View budgets'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

int? _parseNairaToKobo(String input) {
  final value = input.trim().replaceAll(',', '');
  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final whole = int.tryParse(parts.first);
  if (whole == null) return null;
  final fraction = parts.length == 1 ? '00' : parts.last.padRight(2, '0');
  final kobo = int.tryParse('${parts.first}${fraction}');
  if (kobo == null) return null;
  // Keep the submitted integer exactly representable in Dart's Web runtime.
  if (kobo > 9007199254740991) return null;
  return kobo;
}

String _formatNairaInput(int kobo) {
  final absolute = kobo.abs();
  final whole = absolute ~/ 100;
  final fraction = (absolute % 100).toString().padLeft(2, '0');
  return '$whole.$fraction';
}
