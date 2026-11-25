import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentNetworkScreen extends StatelessWidget {
  const AgentNetworkScreen({
    required this.title,
    required this.description,
    this.fields = const [],
    this.actions = const [],
    super.key,
  });

  final String title;
  final String description;
  final List<String> fields;
  final List<String> actions;

  static const _routes = <String, String>{
    'Agent home': '/agent',
    'Cash-in': '/agent/cash-in',
    'Cash-out': '/agent/cash-out',
    'Float top-up': '/agent/float',
    'Commission and history': '/agent/history',
    'Day-end summary': '/agent/day-end',
    'Become an agent': '/agent/apply',
    'Find an agent': '/agents/nearby',
    'Cash-in at an agent': '/agents/cash-in',
    'Request cash-out': '/agents/cash-out',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Agent Network')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 18),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Live account information unavailable',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(
                        'The API does not define the response fields for this screen. Actions that move money or change account state are disabled until the response and session contracts are integrated.'),
                  ],
                ),
              ),
            ),
            if (fields.isNotEmpty) ...[
              const SizedBox(height: 18),
              for (final field in fields) ...[
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: field),
                ),
                const SizedBox(height: 12),
              ],
              for (final action in actions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilledButton(
                    onPressed: null,
                    child: Text(action),
                  ),
                ),
            ],
            if (title == 'Agent home' || title == 'Find an agent') ...[
              const SizedBox(height: 12),
              for (final entry in _routes.entries)
                if (entry.key != title)
                  Card(
                    child: ListTile(
                      title: Text(entry.key),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(entry.value),
                    ),
                  ),
            ],
          ],
        ),
      );
}
