import 'package:flutter/material.dart';

class AdminApprovalsScreen extends StatelessWidget {
  const AdminApprovalsScreen({required this.cooperativeId, super.key});

  final String cooperativeId;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin approvals'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Join requests'),
                Tab(text: 'Loans'),
                Tab(text: 'Withdrawals'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _ApprovalUnavailable(
                cooperativeId: cooperativeId,
                icon: Icons.person_add_alt_1_outlined,
                title: 'Join requests are unavailable',
                detail:
                    'The join-request list has no response schema, so applicant details and decisions are not shown.',
              ),
              _ApprovalUnavailable(
                cooperativeId: cooperativeId,
                icon: Icons.request_quote_outlined,
                title: 'Loan applications are unavailable',
                detail:
                    'The application queue has no response schema. Loan decisions also require PIN authorization and dual-control status.',
              ),
              _ApprovalUnavailable(
                cooperativeId: cooperativeId,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Withdrawal approvals are unavailable',
                detail:
                    'The API defines withdrawal creation and approval, but no pending-withdrawals list.',
              ),
            ],
          ),
        ),
      );
}

class _ApprovalUnavailable extends StatelessWidget {
  const _ApprovalUnavailable({
    required this.cooperativeId,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final String cooperativeId;
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Group reference: $cooperativeId',
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Icon(icon,
                      size: 36, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 14),
                  Text(title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(detail, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      );
}
