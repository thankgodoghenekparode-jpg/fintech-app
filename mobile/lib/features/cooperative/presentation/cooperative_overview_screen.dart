import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CooperativeOverviewScreen extends StatelessWidget {
  const CooperativeOverviewScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooperative overview'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Cooperative options',
            onSelected: (value) {
              if (value == 'approvals') {
                context.push('/coop/$cooperativeId/admin/approvals');
              } else if (value == 'leave') {
                context.push('/coop/$cooperativeId/leave');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'approvals',
                child: Text('Admin approvals'),
              ),
              PopupMenuItem(
                value: 'leave',
                child: Text('Leave cooperative'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Your cooperative', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
                'Cooperative name and verification status are unavailable until the overview response is defined.'),
            const SizedBox(height: 8),
            Text('Group reference: $cooperativeId',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Group details are unavailable. No balances, dues, or membership status are being displayed.',
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                const _UnavailableSummary(
                    label: 'My savings', icon: Icons.savings_outlined),
                const _UnavailableSummary(
                    label: 'My shares', icon: Icons.pie_chart_outline),
                const _UnavailableSummary(
                    label: 'Loan balance',
                    icon: Icons.account_balance_outlined),
                const _UnavailableSummary(
                    label: 'Next contribution', icon: Icons.event_outlined),
              ],
            ),
            const SizedBox(height: 22),
            Text('Quick actions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _UnavailableAction(
                  label: 'Contribute',
                  icon: Icons.payments_outlined,
                  onPressed: () => context.push(
                    '/coop/$cooperativeId/contributions',
                  ),
                ),
                _UnavailableAction(
                  label: 'Shares',
                  icon: Icons.pie_chart_outline,
                  onPressed: () => context.push('/coop/$cooperativeId/shares'),
                ),
                _UnavailableAction(
                  label: 'Borrow',
                  icon: Icons.request_quote_outlined,
                  onPressed: () => context.push('/coop/$cooperativeId/loans'),
                ),
                _UnavailableAction(
                  label: 'Statement',
                  icon: Icons.receipt_long_outlined,
                  onPressed: () =>
                      context.push('/coop/$cooperativeId/statement'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Card(
              child: ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: const Text('Announcements and meetings'),
                subtitle: const Text(
                    'Information is unavailable until the group feed contract is published.'),
                onTap: () => context.push('/coop/$cooperativeId/hub'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnavailableSummary extends StatelessWidget {
  const _UnavailableSummary({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              const Text('Unavailable'),
            ],
          ),
        ),
      );
}

class _UnavailableAction extends StatelessWidget {
  const _UnavailableAction({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
}
