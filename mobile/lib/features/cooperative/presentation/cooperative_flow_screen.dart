import 'package:flutter/material.dart';

class CooperativeFlowUnavailableScreen extends StatelessWidget {
  const CooperativeFlowUnavailableScreen({
    required this.cooperativeId,
    required this.title,
    required this.description,
    this.recordId,
    super.key,
  });

  final String cooperativeId;
  final String title;
  final String description;
  final String? recordId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(height: 12),
                    Text('Transaction details unavailable',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Text(
                        'Service data and the shared PIN security flow are not connected for this screen. Amounts, repayment terms, and confirmation actions are unavailable.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Cooperative reference: $cooperativeId',
                style: Theme.of(context).textTheme.bodySmall),
            if (recordId != null) ...[
              const SizedBox(height: 4),
              Text('Request reference: $recordId',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      );
}
