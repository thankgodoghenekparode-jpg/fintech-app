import 'package:flutter/material.dart';

class AjoCircleUnavailableScreen extends StatelessWidget {
  const AjoCircleUnavailableScreen({
    required this.circleId,
    required this.title,
    required this.description,
    super.key,
  });

  final String circleId;
  final String title;
  final String description;

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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(height: 12),
                    Text('Details are unavailable',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                        'The API response for this view has no defined fields. No schedule, round, or payment details are displayed.'),
                    const SizedBox(height: 12),
                    Text('Circle reference: $circleId',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
