import 'package:flutter/material.dart';

class LeaveCooperativeScreen extends StatefulWidget {
  const LeaveCooperativeScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  State<LeaveCooperativeScreen> createState() => _LeaveCooperativeScreenState();
}

class _LeaveCooperativeScreenState extends State<LeaveCooperativeScreen> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Leave cooperative')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Before you leave', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
                'Leaving may affect your savings settlement and any responsibilities you have to other members.'),
            const SizedBox(height: 8),
            Text('Group reference: ${widget.cooperativeId}',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 18),
            const _ObligationCard(
              icon: Icons.account_balance_outlined,
              title: 'Outstanding loans',
              detail: 'Loan status and settlement information are unavailable.',
            ),
            const SizedBox(height: 10),
            const _ObligationCard(
              icon: Icons.handshake_outlined,
              title: 'Guarantees',
              detail: 'Your guarantee obligations are unavailable.',
            ),
            const SizedBox(height: 10),
            const _ObligationCard(
              icon: Icons.savings_outlined,
              title: 'Savings settlement',
              detail: 'The amount and timing of any return are unavailable.',
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _reasonController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'You cannot submit a leave request until the app can show your obligations and settlement details and obtain PIN authorization. No request was sent.',
              ),
            ),
            const SizedBox(height: 12),
            const FilledButton(
              onPressed: null,
              child: Text('Request to leave'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObligationCard extends StatelessWidget {
  const _ObligationCard({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(detail),
        ),
      );
}
