import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class DemoPreviewCatalogScreen extends StatelessWidget {
  const DemoPreviewCatalogScreen({super.key});

  static const _available = <_DemoPreviewItem>[
    _DemoPreviewItem(
        'Home and cards', 'Sample account data', Icons.home_outlined, '/demo'),
    _DemoPreviewItem('Payments hub', 'Sample beneficiaries and activity',
        Icons.payments_outlined, '/demo/payments'),
    _DemoPreviewItem('Bills and utilities', 'Local demo flow',
        Icons.receipt_long_outlined, '/demo/bills'),
    _DemoPreviewItem('Account details', 'Clearly labeled sample data',
        Icons.account_balance_outlined, '/demo/account-details'),
    _DemoPreviewItem('Add money', 'Account details preview',
        Icons.add_card_outlined, '/demo/add-money'),
    _DemoPreviewItem('Transaction report', 'Preview only; no ticket submitted',
        Icons.report_problem_outlined, '/demo/report-problem'),
    _DemoPreviewItem('Card management', 'Sample cards; no card API calls',
        Icons.credit_card_outlined, '/preview/cards'),
    _DemoPreviewItem('Account limits', 'Sample account values',
        Icons.speed_outlined, '/demo/limits'),
    _DemoPreviewItem('Legal and privacy', 'Draft documents only',
        Icons.policy_outlined, '/demo/legal'),
    _DemoPreviewItem(
        'Branch and agent locator',
        'Screen preview; live search needs backend',
        Icons.place_outlined,
        '/demo/locator'),
    _DemoPreviewItem(
        'Help Centre',
        'Guidance articles; ticket actions need backend',
        Icons.help_outline,
        '/demo/help'),
    _DemoPreviewItem(
        'Close account',
        'Sample blocker; request submission disabled',
        Icons.person_remove_outlined,
        '/demo/close-account'),
    _DemoPreviewItem(
        'Offline state',
        'Preview of the read-only connection guard',
        Icons.wifi_off_outlined,
        '/demo/offline'),
  ];

  static const _backendRequired = <String>[
    'Statements archive and PDF requests',
    'Live account dashboard and transaction history',
    'Notifications and read state',
    'Support ticket creation and replies',
    'Live agent search results',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Implemented screen previews'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Demo mode - sample data only'),
                subtitle: Text(
                  'Preview screens without signing in. No real account, payments, cards, consent, or support requests are created.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Open previews',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final item in _available)
              Card(
                child: ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  subtitle: Text(item.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(item.route),
                ),
              ),
            const SizedBox(height: 18),
            Text('Needs a connected backend',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final label in _backendRequired)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cloud_off_outlined),
                  title: Text(label),
                  subtitle: const Text('Connect the API to load live data.'),
                ),
              ),
          ],
        ),
      );
}

class _DemoPreviewItem {
  const _DemoPreviewItem(this.title, this.note, this.icon, this.route);

  final String title;
  final String note;
  final IconData icon;
  final String route;
}
