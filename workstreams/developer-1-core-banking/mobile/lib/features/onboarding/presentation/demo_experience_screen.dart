import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class DemoExperienceScreen extends StatefulWidget {
  const DemoExperienceScreen({super.key});

  @override
  State<DemoExperienceScreen> createState() => _DemoExperienceScreenState();
}

class _DemoExperienceScreenState extends State<DemoExperienceScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_tab == 0 ? 'Good morning, Ada' : 'Your cards'),
        actions: [
          IconButton(
            tooltip: 'Exit demo',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo account · Sample data only. No real account, card, or transactions.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.push('/demo/screens'),
            icon: const Icon(Icons.grid_view_outlined),
            label: const Text('Browse implemented screens'),
          ),
          const SizedBox(height: 16),
          if (_tab == 0) ...[
            _BalancePanel(color: colors.primaryContainer),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.push('/demo/account-details'),
                icon: const Icon(Icons.account_balance_outlined),
                label: const Text('Account details'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.push('/demo/payments'),
                icon: const Icon(Icons.payments_outlined),
                label: const Text('Payments hub'),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.push('/demo/report-problem'),
                icon: const Icon(Icons.report_problem_outlined),
                label: const Text('Preview report a problem'),
              ),
            ),
            const SizedBox(height: 24),
            Text('Quick actions',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _DemoAction(Icons.swap_horiz, 'Send'),
                _DemoAction(Icons.receipt_long_outlined, 'Pay bills'),
                _DemoAction(
                  Icons.add_circle_outline,
                  'Add money',
                  onTap: () => context.push('/demo/add-money'),
                ),
                _DemoAction(Icons.credit_card_outlined, 'Cards'),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My cards', style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () => setState(() => _tab = 1),
                  child: const Text('Manage'),
                ),
              ],
            ),
            const _DemoCard(label: 'Everyday', last4: '6194', berry: true),
            const SizedBox(height: 12),
            const _DemoCard(label: 'Travel', last4: '2841', frozen: true),
            const SizedBox(height: 24),
            Text('Recent activity',
                style: Theme.of(context).textTheme.titleLarge),
            const _DemoTransaction(
              icon: Icons.shopping_bag_outlined,
              title: 'Market groceries',
              detail: 'Today · Completed',
              amount: '−₦18,500.00',
            ),
            const _DemoTransaction(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Salary',
              detail: 'Yesterday · Completed',
              amount: '+₦250,000.00',
              credit: true,
            ),
          ] else ...[
            Text('Virtual naira cards',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Sample cards shown for visual demonstration.'),
            const SizedBox(height: 16),
            const _DemoCard(label: 'Everyday', last4: '6194', berry: true),
            const SizedBox(height: 16),
            const _DemoCard(label: 'Travel', last4: '2841', frozen: true),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.add_card_outlined),
                title: Text('Create a card'),
                subtitle: Text('Card creation is unavailable in demo mode.'),
                enabled: false,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) {
          if (value == 2) {
            context.push('/demo/payments');
          } else {
            setState(() => _tab = value);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            label: 'Payments',
          ),
        ],
      ),
    );
  }
}

class _BalancePanel extends StatelessWidget {
  const _BalancePanel({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
        color: color,
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available balance'),
              SizedBox(height: 8),
              Text('₦428,650.00',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Demo account · 0123 456 789'),
            ],
          ),
        ),
      );
}

class _DemoAction extends StatelessWidget {
  const _DemoAction(this.icon, this.label, {this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 76,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                CircleAvatar(child: Icon(icon)),
                const SizedBox(height: 6),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.label,
    required this.last4,
    this.berry = false,
    this.frozen = false,
  });
  final String label;
  final String last4;
  final bool berry;
  final bool frozen;

  @override
  Widget build(BuildContext context) {
    final gradient = berry
        ? const [Color(0xff8A1B4B), Color(0xff541235)]
        : const [Color(0xff35445B), Color(0xff151C2B)];
    return AspectRatio(
      aspectRatio: 1.586,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: gradient),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(label,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  if (frozen)
                    const Chip(
                      avatar: Icon(Icons.lock_outline, size: 16),
                      label: Text('Frozen'),
                    ),
                ],
              ),
              const Spacer(),
              Text('••••  ••••  ••••  $last4',
                  style:
                      const TextStyle(color: Colors.white, letterSpacing: 1.4)),
              const SizedBox(height: 8),
              const Text('VIRTUAL NAIRA',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoTransaction extends StatelessWidget {
  const _DemoTransaction({
    required this.icon,
    required this.title,
    required this.detail,
    required this.amount,
    this.credit = false,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String amount;
  final bool credit;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(detail),
        trailing: Text(amount,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: credit ? Colors.green.shade700 : null,
            )),
      );
}
