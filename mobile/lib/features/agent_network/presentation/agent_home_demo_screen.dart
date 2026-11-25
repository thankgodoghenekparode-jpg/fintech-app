import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AgentHomeDemoScreen extends StatefulWidget {
  const AgentHomeDemoScreen({super.key});

  @override
  State<AgentHomeDemoScreen> createState() => _AgentHomeDemoScreenState();
}

class _AgentHomeDemoScreenState extends State<AgentHomeDemoScreen> {
  bool _balanceVisible = true;
  String _activityFilter = 'All';

  static const _activities = <_AgentActivity>[
    _AgentActivity(
      name: 'Musa Garba',
      type: 'Cash-In',
      time: '14:32',
      amount: '₦25,000.00',
      commission: '+₦150.00 Comm.',
      reference: '',
      icon: Icons.south_rounded,
    ),
    _AgentActivity(
      name: 'Chidinma Nwosu',
      type: 'Cash-Out',
      time: '13:50',
      amount: '₦15,000.00',
      commission: '+₦100.00 Comm.',
      reference: '#CO-8921',
      icon: Icons.north_rounded,
    ),
    _AgentActivity(
      name: 'Float Top-up',
      type: 'Direct Transfer',
      time: '11:15',
      amount: '+₦200,000.00',
      commission: '',
      reference: 'GTBank Ref #8491',
      icon: Icons.account_balance_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shownActivities = _activities.where((activity) {
      if (_activityFilter == 'All') return true;
      return activity.type == _activityFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F8),
        leading: IconButton(
          tooltip: 'Back to design previews',
          onPressed: () => context.go('/design-previews'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Agent terminal'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _demoNotice(),
          const SizedBox(height: 14),
          _agentIdentity(),
          const SizedBox(height: 16),
          _floatCard(context),
          const SizedBox(height: 12),
          _floatHealthCard(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Primary Operations',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              Text('Fast Terminal Mode',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: const Color(0xFF564146))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _operationCard(
                  context,
                  title: 'Cash-In',
                  detail: 'Start Deposit',
                  label: 'Instant',
                  icon: Icons.payments_outlined,
                  route: '/agent/cash-in',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _operationCard(
                  context,
                  title: 'Cash-Out',
                  detail: 'Redeem Code',
                  label: 'PIN Required',
                  icon: Icons.dialpad_rounded,
                  route: '/agent/cash-out',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _shortcut(context, Icons.currency_exchange, 'Earnings',
                  '/agent/history'),
              _shortcut(
                  context, Icons.receipt_long, 'Day-End', '/agent/day-end'),
              _shortcut(context, Icons.point_of_sale, 'POS Sync', null),
              _shortcut(context, Icons.qr_code_2, 'Agent QR', null),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("Today's Agent Operations",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              TextButton(
                onPressed: () => context.go('/agent/history'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final filter in ['All', 'Cash-In', 'Cash-Out'])
                ChoiceChip(
                  label: Text(filter),
                  selected: _activityFilter == filter,
                  onSelected: (_) => setState(() => _activityFilter = filter),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (final activity in shownActivities) _activityCard(activity),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.headset_mic_outlined,
                  color: Color(0xFF8E1B4A)),
              title: const Text('Need Field Operator Help?'),
              subtitle: const Text('Lagos Field Rep: 0800-YOURAPP-AGN'),
              trailing: OutlinedButton(
                onPressed: () => _showContactOptions(context),
                child: const Text('Contact'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _demoNotice() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDCED6)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.visibility_outlined, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Design sample - not live account data. Money actions are disabled in this demo.',
              ),
            ),
          ],
        ),
      );

  Widget _agentIdentity() => Card(
        color: Colors.white,
        child: ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFD9E1),
                foregroundColor: Color(0xFF6D0033),
                child:
                    Text('AP', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          title: const Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text('Alaba Express Pay'),
              Chip(
                label: Text('Tier 3'),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          subtitle: const Text('Lagos Terminal  ·  Online'),
          trailing: IconButton(
            tooltip: 'Notifications (demo only)',
            onPressed: () => _showDemoMessage(context),
            icon: const Icon(Icons.notifications_none),
          ),
        ),
      );

  Widget _floatCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF8E1B4A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x338E1B4A),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('AGENT FLOAT WALLET BALANCE',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      setState(() => _balanceVisible = !_balanceVisible),
                  color: Colors.white,
                  tooltip: _balanceVisible ? 'Hide balance' : 'Show balance',
                  icon: Icon(_balanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _balanceVisible ? '₦485,250.00' : '₦••••••••',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => context.go('/agent/float'),
                  icon: const Icon(Icons.bolt, size: 18),
                  label: const Text('Top Up'),
                  style: FilledButton.styleFrom(
                    foregroundColor: const Color(0xFF6D0033),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white30, height: 24),
            const Row(
              children: [
                Expanded(
                  child: _FloatStat(
                      label: 'Physical Cash in Till', value: '₦214,000.00'),
                ),
                Expanded(
                  child: _FloatStat(
                      label: "Today's Commission", value: '+₦6,850.00'),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _floatHealthCard() => const Card(
        color: Colors.white,
        child: ListTile(
          leading: Icon(Icons.verified_user_outlined, color: Colors.green),
          title: Text('Float Healthy'),
          subtitle: Text('Min. safety buffer ₦100,000 maintained'),
          trailing: Icon(Icons.info_outline),
        ),
      );

  Widget _operationCard(
    BuildContext context, {
    required String title,
    required String detail,
    required String label,
    required IconData icon,
    required String route,
  }) =>
      Card(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go(route),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: const Color(0xFF8E1B4A), size: 28),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                Text(detail,
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 8),
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF6D0033),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );

  Widget _shortcut(
          BuildContext context, IconData icon, String label, String? route) =>
      Expanded(
        child: TextButton(
          onPressed: route == null
              ? () => _showDemoMessage(context)
              : () => context.go(route),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      );

  Widget _activityCard(_AgentActivity activity) => Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFFF0F2),
            foregroundColor: const Color(0xFF8E1B4A),
            child: Icon(activity.icon),
          ),
          title: Text(activity.name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            [
              activity.type,
              activity.time,
              activity.reference,
              activity.commission,
              'Successful',
            ].where((value) => value.isNotEmpty).join('  ·  '),
          ),
          trailing: Text(activity.amount,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      );

  void _showDemoMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This sample screen is read-only.')),
    );
  }

  void _showContactOptions(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Field operator support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lagos Field Rep'),
            SizedBox(height: 4),
            SelectableText('0800-YOURAPP-AGN'),
            SizedBox(height: 12),
            Text(
                'Supplied sample contact. Calls are not placed from this demo.'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(
                const ClipboardData(text: '0800-YOURAPP-AGN'),
              );
              if (!context.mounted) return;
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sample contact copied.')),
              );
            },
            icon: const Icon(Icons.copy_outlined),
            label: const Text('Copy contact'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _FloatStat extends StatelessWidget {
  const _FloatStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _AgentActivity {
  const _AgentActivity({
    required this.name,
    required this.type,
    required this.time,
    required this.amount,
    required this.commission,
    required this.reference,
    required this.icon,
  });

  final String name;
  final String type;
  final String time;
  final String amount;
  final String commission;
  final String reference;
  final IconData icon;
}
