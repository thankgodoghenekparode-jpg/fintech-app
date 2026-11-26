import 'dart:ui' show FontFeature;

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';

import 'insights_adapter.dart';
import 'insights_formatters.dart';
import 'insights_models.dart';

typedef InsightsThemeToggle = VoidCallback;

class InsightsHomePage extends StatefulWidget {
  const InsightsHomePage({
    required this.adapter,
    required this.monthKey,
    required this.onOpenCategory,
    required this.onOpenSummary,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final String monthKey;
  final ValueChanged<InsightCategory> onOpenCategory;
  final VoidCallback onOpenSummary;
  final InsightsThemeToggle? onThemeToggle;

  @override
  State<InsightsHomePage> createState() => _InsightsHomePageState();
}

class _InsightsHomePageState extends State<InsightsHomePage> {
  late String _monthKey;
  late Future<InsightsMonth?> _month;
  bool _showTip = true;

  @override
  void initState() {
    super.initState();
    _monthKey = widget.monthKey;
    _load();
  }

  void _load() {
    _month = widget.adapter.loadMonth(_monthKey);
  }

  void _selectMonth(String key) {
    setState(() {
      _monthKey = key;
      _load();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('YourApp'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<InsightsMonth?>(
      future: _month,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingState();
        }
        if (snapshot.hasError) {
          return _ErrorState(onRetry: () => setState(_load));
        }
        final data = snapshot.data;
        if (data == null) return const _UnavailableState();
        if (!data.personalisedConsent) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _StateCard(
                icon: Icons.lock_outline,
                title: 'Personalised insights are off',
                body: 'Turn on consent in Preferences to see your spending insights.',
              ),
            ],
          );
        }
        if (!data.hasEnoughData) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonthSelector(
                data: data,
                selectedKey: _monthKey,
                onChanged: _selectMonth,
              ),
              const SizedBox(height: 24),
              const _StateCard(
                icon: Icons.insights_outlined,
                title: 'Not enough data yet',
                body: 'Your monthly view will appear when more transaction data is available.',
              ),
            ],
          );
        }
        return RefreshIndicator(
          onRefresh: () async => setState(_load),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _MonthSelector(
                data: data,
                selectedKey: _monthKey,
                onChanged: _selectMonth,
              ),
              const SizedBox(height: 16),
              _IncomeSpendCard(data: data),
              const SizedBox(height: 24),
              _SectionHeading(
                title: 'Spending by category',
                trailing: TextButton(
                  onPressed: widget.onOpenSummary,
                  child: const Text('Monthly summary'),
                ),
              ),
              const SizedBox(height: 8),
              if (data.categories.isEmpty)
                const _StateCard(
                  icon: Icons.pie_chart_outline,
                  title: 'No categories to show',
                  body: 'Category details will appear when available.',
                )
              else
                ...data.categories.map(
                  (category) => _CategoryTile(
                    category: category,
                    onTap: () => widget.onOpenCategory(category),
                  ),
                ),
              const SizedBox(height: 24),
              const _SectionHeading(title: 'Top merchants'),
              const SizedBox(height: 8),
              if (data.topMerchants.isEmpty)
                const _MutedText(
                  'Merchant details are not available for this month.',
                )
              else
                ...data.topMerchants.map(
                  (merchant) => _MerchantRow(merchant: merchant),
                ),
              if (_showTip && data.tip != null) ...[
                const SizedBox(height: 20),
                _TipCard(
                  text: data.tip!,
                  onDismiss: () => setState(() => _showTip = false),
                ),
              ],
            ],
          ),
        );
      },
    ),
  );
}

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({
    required this.adapter,
    required this.categoryId,
    required this.monthKey,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final String categoryId;
  final String monthKey;
  final InsightsThemeToggle? onThemeToggle;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late Future<InsightCategoryDetail?> _detail;
  final Set<String> _updating = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _detail = widget.adapter.loadCategory(
      categoryId: widget.categoryId,
      monthKey: widget.monthKey,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Category detail'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<InsightCategoryDetail?>(
      future: _detail,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const _LoadingState();
        if (snapshot.hasError)
          return _ErrorState(onRetry: () => setState(_load));
        final data = snapshot.data;
        if (data == null) return const _UnavailableState();
        if (!data.personalisedConsent) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: _StateCard(
              icon: Icons.lock_outline,
              title: 'Personalised insights are off',
              body: 'Turn on consent in Preferences to see category details.',
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              data.categoryName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MutedText('Total this month'),
                    const SizedBox(height: 8),
                    Text(
                      _money(data.totalKobo),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontSize: 32),
                    ),
                    if (data.trendText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        data.trendText!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionHeading(title: 'Transactions'),
            const SizedBox(height: 8),
            if (data.transactions.isEmpty)
              const _StateCard(
                icon: Icons.receipt_long_outlined,
                title: 'No transactions in this category',
                body: 'Transactions will appear here when available.',
              )
            else
              ...data.transactions.map(
                (transaction) => _TransactionRow(
                  transaction: transaction,
                  isUpdating: _updating.contains(transaction.id),
                  onRecategorise: () => _recategorise(transaction),
                ),
              ),
          ],
        );
      },
    ),
  );

  Future<void> _recategorise(InsightTransaction transaction) async {
    var categoryInput = '';
    final category = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-categorise transaction'),
        content: TextField(
          autofocus: true,
          onChanged: (value) => categoryInput = value,
          decoration: const InputDecoration(
            labelText: 'Category',
            hintText: 'Enter a category',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = categoryInput.trim();
              if (value.isNotEmpty) Navigator.pop(context, value);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (category == null || category.isEmpty || !mounted) return;
    setState(() => _updating.add(transaction.id));
    try {
      await widget.adapter.recategorise(
        transactionId: transaction.id,
        category: category,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category update sent to your bank.')),
        );
        setState(_load);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category could not be updated. Try again later.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _updating.remove(transaction.id));
    }
  }
}

class MonthlySummaryPage extends StatefulWidget {
  const MonthlySummaryPage({
    required this.adapter,
    required this.monthKey,
    this.onShare,
    this.onThemeToggle,
    super.key,
  });

  final SpendingInsightsAdapter adapter;
  final String monthKey;
  final VoidCallback? onShare;
  final InsightsThemeToggle? onThemeToggle;

  @override
  State<MonthlySummaryPage> createState() => _MonthlySummaryPageState();
}

class _MonthlySummaryPageState extends State<MonthlySummaryPage> {
  late Future<InsightsMonth?> _month;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _month = widget.adapter.loadMonth(widget.monthKey);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Monthly summary'),
      actions: [
        if (widget.onThemeToggle != null)
          IconButton(
            tooltip: 'Switch theme',
            onPressed: widget.onThemeToggle,
            icon: const Icon(Icons.contrast_outlined),
          ),
      ],
    ),
    body: FutureBuilder<InsightsMonth?>(
      future: _month,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const _LoadingState();
        if (snapshot.hasError)
          return _ErrorState(onRetry: () => setState(_load));
        final data = snapshot.data;
        if (data == null) return const _UnavailableState();
        if (!data.personalisedConsent) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: _StateCard(
              icon: Icons.lock_outline,
              title: 'Personalised insights are off',
              body: 'Turn on consent in Preferences to see a monthly summary.',
            ),
          );
        }
        if (!data.hasEnoughData) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: _StateCard(
              icon: Icons.insights_outlined,
              title: 'No summary available yet',
              body: 'A shareable summary will appear when more transaction data is available.',
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              data.monthLabel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _IncomeSpendCard(data: data),
            const SizedBox(height: 20),
            const _SectionHeading(title: 'Highlights'),
            const SizedBox(height: 8),
            if (data.highlights.isEmpty)
              const _MutedText('Highlights are not available for this month.')
            else
              ...data.highlights.map(
                (highlight) => _SummaryRow(text: highlight),
              ),
            if (data.comparisonText != null) ...[
              const SizedBox(height: 16),
              _SummaryRow(
                text: data.comparisonText!,
                icon: Icons.compare_arrows_outlined,
              ),
            ],
            if (data.savingsOpportunity != null) ...[
              const SizedBox(height: 16),
              _SummaryRow(
                text: data.savingsOpportunity!,
                icon: Icons.savings_outlined,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: widget.onShare,
              icon: const Icon(Icons.ios_share_outlined),
              label: const Text('Share summary'),
            ),
            if (widget.onShare == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: _MutedText(
                  'Sharing is provided by the host app and is not connected in this preview.',
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.data,
    required this.selectedKey,
    required this.onChanged,
  });
  final InsightsMonth data;
  final String selectedKey;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = data.availableMonths;
    if (options.length < 2) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Chip(
          avatar: const Icon(Icons.calendar_month_outlined, size: 18),
          label: Text(data.monthLabel),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        value: options.any((option) => option.key == selectedKey)
            ? selectedKey
            : null,
        hint: Text(data.monthLabel),
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(12),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option.key,
                child: Text(option.label),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class _IncomeSpendCard extends StatelessWidget {
  const _IncomeSpendCard({required this.data});
  final InsightsMonth data;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spend vs income',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _AmountCell(label: 'Spent', amount: data.spendKobo),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AmountCell(label: 'Income', amount: data.incomeKobo),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _AmountCell extends StatelessWidget {
  const _AmountCell({required this.label, required this.amount});
  final String label;
  final int? amount;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 4),
      Text(
        _money(amount),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ],
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});
  final InsightCategory category;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.label,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    _money(category.amountKobo),
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
              if (category.barFraction != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: category.barFraction!.clamp(0.0, 1.0).toDouble(),
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MerchantRow extends StatelessWidget {
  const _MerchantRow({required this.merchant});
  final InsightMerchant merchant;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: const Icon(Icons.storefront_outlined),
    ),
    title: Text(merchant.name),
    trailing: Text(
      _money(merchant.amountKobo),
      style: Theme.of(context).textTheme.labelLarge,
    ),
  );
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.onRecategorise,
    required this.isUpdating,
  });
  final InsightTransaction transaction;
  final VoidCallback onRecategorise;
  final bool isUpdating;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: const Icon(Icons.receipt_long_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchant,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  transaction.dateLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton.icon(
                  onPressed: isUpdating ? null : onRecategorise,
                  icon: isUpdating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Re-categorise'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _money(transaction.amountKobo),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    ),
  );
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text, required this.onDismiss});
  final String text;
  final VoidCallback onDismiss;
  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
          IconButton(
            tooltip: 'Dismiss tip',
            onPressed: onDismiss,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.trailing});
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.text,
    this.icon = Icons.check_circle_outline,
  });
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text),
    ),
  );
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(semanticsLabel: 'Loading insights'),
  );
}

class _UnavailableState extends StatelessWidget {
  const _UnavailableState();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(16),
    child: _StateCard(
      icon: Icons.cloud_off_outlined,
      title: 'Insights unavailable',
      body: 'Your host app has not provided this information.',
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(height: 12),
            Text(
              'Could not load insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Check your connection and try again.'),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MutedText extends StatelessWidget {
  const _MutedText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

String _money(int? kobo) => formatInsightsMoney(kobo);
