import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreDemoScreen extends StatelessWidget {
  const MoreDemoScreen({super.key});

  static const _sections = <({String title, String screenId, IconData icon})>[
    (
      title: 'Agent Network',
      screenId: 'S-AGT-001',
      icon: Icons.storefront_outlined
    ),
    (title: 'Ajo / Esusu', screenId: 'S-AJO-001', icon: Icons.groups_outlined),
    (
      title: 'Cooperatives',
      screenId: 'S-COOP-001',
      icon: Icons.account_balance_outlined
    ),
    (
      title: 'Revenue',
      screenId: 'S-REV-001',
      icon: Icons.receipt_long_outlined
    ),
    (
      title: 'Target Savings',
      screenId: 'S-TGT-001',
      icon: Icons.savings_outlined
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('More')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Explore the sections included in this sample demo. Content is supplied design data; no account actions are sent.',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                  child: Text(
                    'Available sections',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                for (final section in _sections)
                  Card(
                    child: ListTile(
                      leading: Icon(section.icon),
                      title: Text(section.title),
                      subtitle:
                          Text('Supplied demo screen · ${section.screenId}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push('/design-preview/${section.screenId}'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 4,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/design-preview/S-AGT-001?from=bottom-navigation');
              case 1:
                context.go('/design-preview/S-REV-001?from=bottom-navigation');
              case 2:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('No Cards screen was supplied for this demo.'),
                  ),
                );
              case 3:
                context.go('/design-preview/S-TGT-001?from=bottom-navigation');
              case 4:
                context.go('/more');
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.send_outlined),
              label: 'Payments',
            ),
            NavigationDestination(
              icon: Icon(Icons.credit_card_outlined),
              label: 'Cards',
            ),
            NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              label: 'Save & Borrow',
            ),
            NavigationDestination(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      );
}
