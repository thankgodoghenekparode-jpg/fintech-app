import 'package:flutter/material.dart';

import '../../../core/i18n/app_text.dart';

class TargetGoalUnavailableScreen extends StatelessWidget {
  const TargetGoalUnavailableScreen({
    required this.title,
    required this.description,
    this.goalId,
    super.key,
  });

  final String title;
  final String description;
  final String? goalId;

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
                    Text(AppText.targetGoalUnavailableTitle,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(AppText.targetGoalUnavailableInfo),
                    if (goalId != null) ...[
                      const SizedBox(height: 12),
                      Text('Goal reference: $goalId',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
