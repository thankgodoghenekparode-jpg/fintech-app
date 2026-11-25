import 'package:flutter/material.dart';

class SharesScreen extends StatelessWidget {
  const SharesScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My shares')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Shares and certificate',
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Review your cooperative shareholding and certificate.'),
            const SizedBox(height: 8),
            Text('Group reference: $cooperativeId',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Share details are unavailable until the service defines its response fields. No share value or certificate information is shown.',
              ),
            ),
            const SizedBox(height: 16),
            const _ShareMetric(
                label: 'Shares held', icon: Icons.pie_chart_outline),
            const SizedBox(height: 10),
            const _ShareMetric(label: 'Unit price', icon: Icons.sell_outlined),
            const SizedBox(height: 10),
            const _ShareMetric(
                label: 'Total value',
                icon: Icons.account_balance_wallet_outlined),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress to share limit',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                        'Share limit and your progress are unavailable.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Card(
              child: ListTile(
                leading: Icon(Icons.workspace_premium_outlined),
                title: Text('Share certificate'),
                subtitle: Text('Certificate details are unavailable.'),
                trailing: Icon(Icons.chevron_right),
                enabled: false,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Share history', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Share transactions are unavailable.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareMetric extends StatelessWidget {
  const _ShareMetric({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(label),
          trailing: const Text('Unavailable'),
        ),
      );
}
