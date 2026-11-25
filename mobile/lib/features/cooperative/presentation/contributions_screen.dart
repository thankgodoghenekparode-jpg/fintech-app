import 'package:flutter/material.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My contributions')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Plans and payments', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
                'Review your contribution plan, upcoming dues, and payment history.'),
            const SizedBox(height: 8),
            Text('Group reference: $cooperativeId',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 18),
            const _UnavailableSection(
              icon: Icons.event_repeat_outlined,
              title: 'Contribution plans',
              detail:
                  'Plan amounts, schedules, and auto-deduct status are unavailable until the plan response fields are defined.',
            ),
            const SizedBox(height: 12),
            const _UnavailableSection(
              icon: Icons.receipt_long_outlined,
              title: 'Dues and payment history',
              detail:
                  'Due amounts and payment statuses are unavailable until the dues response fields are defined.',
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.payment_outlined),
              label: const Text('Pay contribution'),
            ),
            const SizedBox(height: 8),
            Text(
              'Payment needs a plan and due amount, plus PIN authorization. The data contracts for those steps are not available yet.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnavailableSection extends StatelessWidget {
  const _UnavailableSection({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(detail),
            ],
          ),
        ),
      );
}
