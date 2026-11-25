import 'package:flutter/material.dart';

class LoansOverviewScreen extends StatelessWidget {
  const LoansOverviewScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cooperative loans')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Borrowing and active loans',
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
                'Check eligibility and review any active loan obligations.'),
            const SizedBox(height: 8),
            Text('Group reference: $cooperativeId',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fact_check_outlined,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 10),
                        Text('Loan eligibility',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('Eligibility status is unavailable.'),
                    const SizedBox(height: 8),
                    const Text(
                        'Reasons and eligible-from date are unavailable.'),
                    const SizedBox(height: 8),
                    const Text(
                        'The eligibility response fields have not been defined.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Borrowing limits',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const _UnavailableRow(label: 'Maximum loan'),
                    const Divider(height: 20),
                    const _UnavailableRow(label: 'Savings multiplier'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Active loans', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                        'Loan records are unavailable because no member loan-list response is defined.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.handshake_outlined),
                title: Text('Guarantee obligations'),
                subtitle: Text('Guarantee details are unavailable.'),
                enabled: false,
              ),
            ),
            const SizedBox(height: 18),
            const FilledButton(
              onPressed: null,
              child: Text('Request a loan'),
            ),
            const SizedBox(height: 8),
            Text(
              'Loan requests are unavailable until eligibility and borrowing limits can be confirmed.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnavailableRow extends StatelessWidget {
  const _UnavailableRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const Text('Unavailable'),
        ],
      );
}
