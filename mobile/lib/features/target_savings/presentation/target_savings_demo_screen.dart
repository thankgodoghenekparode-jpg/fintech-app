import 'package:flutter/material.dart';

import '../../../core/i18n/app_text.dart';

class TargetSavingsDemoScreen extends StatelessWidget {
  const TargetSavingsDemoScreen({super.key});

  static const _goals = [
    _DemoGoal(
      name: 'December Rent in Lekki',
      category: 'Housing & Living',
      savedKobo: 24000000,
      targetKobo: 35000000,
      progress: 68,
      daysLeft: 42,
      mode: 'Locked',
      icon: Icons.apartment_outlined,
      note:
          'Auto-save: ₦25,000 on 1st Nov · Strict lock: 2.5% penalty applies on early emergency withdrawal',
    ),
    _DemoGoal(
      name: 'Emergency Buffer Fund',
      category: 'Safety Net',
      savedKobo: 8000000,
      targetKobo: 10000000,
      progress: 80,
      daysLeft: 18,
      mode: 'Flexible',
      icon: Icons.health_and_safety_outlined,
      note: 'Auto-save paused · Free withdrawal anytime · 0 penalty',
    ),
    _DemoGoal(
      name: 'New Laptop for Coding',
      category: 'Work & Tech Equipment',
      savedKobo: 2000000,
      targetKobo: 10000000,
      progress: 20,
      daysLeft: 75,
      mode: 'Locked',
      icon: Icons.laptop_mac_outlined,
      note: 'Next auto-save: ₦10,000 on 5th Nov',
    ),
  ];

  String _formatNaira(int kobo) {
    final naira = (kobo / 100).toStringAsFixed(2).split('.');
    final whole = naira.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '${AppText.currencySymbol}$whole.${naira.last}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.targetSavings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppText.targetSavingsIntro,
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(AppText.targetSavingsDescription,
              style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.tertiaryContainer,
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Design sample — not account data'),
              subtitle: Text(
                'Illustrative values copied from the supplied Target Savings Stitch home reference. Actions are disabled in this view.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.targetSavingsTotal,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_formatNaira(34000000),
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  const Text('3 active goals · design sample'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(AppText.targetSavingsGoals, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final goal in _goals) ...[
            _goalCard(context, goal),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.add),
            label: const Text(AppText.createTargetSavingsGoal),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(BuildContext context, _DemoGoal goal) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(goal.icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.name, style: theme.textTheme.titleMedium),
                      Text(goal.category, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Chip(label: Text(goal.mode)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress'),
                Text('${goal.progress}%', style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: goal.progress / 100),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountLabel(context, 'Saved so far', goal.savedKobo),
                _amountLabel(context, 'Target amount', goal.targetKobo,
                    alignEnd: true),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                Text('${goal.daysLeft} days left'),
              ],
            ),
            const SizedBox(height: 4),
            Text(goal.note, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _amountLabel(
    BuildContext context,
    String label,
    int amountKobo, {
    bool alignEnd = false,
  }) =>
      Column(
        crossAxisAlignment:
            alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(_formatNaira(amountKobo),
              style: Theme.of(context).textTheme.titleSmall),
        ],
      );
}

class _DemoGoal {
  const _DemoGoal({
    required this.name,
    required this.category,
    required this.savedKobo,
    required this.targetKobo,
    required this.progress,
    required this.daysLeft,
    required this.mode,
    required this.icon,
    required this.note,
  });

  final String name;
  final String category;
  final int savedKobo;
  final int targetKobo;
  final int progress;
  final int daysLeft;
  final String mode;
  final IconData icon;
  final String note;
}
