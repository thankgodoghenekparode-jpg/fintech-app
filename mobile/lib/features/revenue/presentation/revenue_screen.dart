import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({
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

  static const _routes = <String, String?>{
    'Dues and levies': '/dues',
    'Due detail and pay': null,
    'Link to collector': '/dues/link',
    'Receipts': '/dues/receipts',
    'This isn’t mine': null,
    'Pay on behalf': '/dues/behalf',
    'Auto-pay settings': '/dues/autopay',
    'Report abuse': null,
    'Find payer': '/collect',
    'Record cash': null,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Revenue and dues')),
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
                    Text('Live billing information unavailable',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(
                        'The API does not define the response fields needed to show bills, payment status, fees, or receipts. Payment and collection actions require the shared session and PIN flows.'),
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
                  child: FilledButton(onPressed: null, child: Text(action)),
                ),
            ],
            if (title == 'Dues and levies' || title == 'Find payer') ...[
              const SizedBox(height: 12),
              for (final entry in _routes.entries)
                if (entry.key != title)
                  Card(
                    child: ListTile(
                      title: Text(entry.key),
                      subtitle: entry.value == null
                          ? const Text(AppText.revenueReferenceRequired)
                          : null,
                      trailing: Icon(entry.value == null
                          ? Icons.lock_outline
                          : Icons.chevron_right),
                      onTap: entry.value == null
                          ? null
                          : () => context.push(entry.value!),
                    ),
                  ),
            ],
          ],
        ),
      );
}
