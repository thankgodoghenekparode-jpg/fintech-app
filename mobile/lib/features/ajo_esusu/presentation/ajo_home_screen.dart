import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';

class AjoHomeScreen extends StatelessWidget {
  const AjoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajo / Esusu'),
        actions: [
          IconButton(
            tooltip: AppText.ajoHowTitle,
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => const _HowAjoWorksSheet(),
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text('Save together, one round at a time',
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text(
                'Join a trusted circle, contribute on schedule, and take turns receiving the group pot.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.ajoPooledValue,
                      style: theme.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(AppText.ajoUnavailable,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      )),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  const _AjoSummaryRow(
                    icon: Icons.groups_outlined,
                    label: AppText.ajoActiveCircles,
                  ),
                  const SizedBox(height: 8),
                  const _AjoSummaryRow(
                    icon: Icons.event_outlined,
                    label: AppText.ajoNextPayout,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Circle totals and schedules are unavailable because the service response is not defined.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/ajo/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create a circle'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/ajo/join'),
                    icon: const Icon(Icons.link),
                    label: const Text('Join with a code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(AppText.ajoSummaryTitle,
                      style: theme.textTheme.titleLarge),
                ),
                const Chip(label: Text(AppText.ajoUnavailable)),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Icon(Icons.groups_outlined,
                        size: 40, color: theme.colorScheme.primary),
                    const SizedBox(height: 10),
                    Text(AppText.ajoNoCircles,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    const Text(AppText.ajoNoCirclesInfo,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.mail_outline),
                title: Text(AppText.ajoPendingInvitations),
                subtitle: Text(AppText.ajoUnavailable),
                trailing: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.ajoHowTitle,
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 10),
                    const _HowAjoStep(number: '1', text: AppText.ajoHowStepOne),
                    const _HowAjoStep(number: '2', text: AppText.ajoHowStepTwo),
                    const _HowAjoStep(number: '3', text: AppText.ajoHowStepThree),
                    const SizedBox(height: 8),
                    const Text(AppText.platformNoGuarantee),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AjoSummaryRow extends StatelessWidget {
  const _AjoSummaryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, semanticLabel: label),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(AppText.ajoUnavailable,
              style: Theme.of(context).textTheme.labelLarge),
        ],
      );
}

class _HowAjoWorksSheet extends StatelessWidget {
  const _HowAjoWorksSheet();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.ajoHowTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text(AppText.ajoHowStepOne),
            const SizedBox(height: 10),
            const Text(AppText.ajoHowStepTwo),
            const SizedBox(height: 10),
            const Text(AppText.ajoHowStepThree),
            const SizedBox(height: 10),
            const Text(AppText.platformNoGuarantee),
          ],
        ),
      );
}

class _HowAjoStep extends StatelessWidget {
  const _HowAjoStep({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 13, child: Text(number)),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      );
}
