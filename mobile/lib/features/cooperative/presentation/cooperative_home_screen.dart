import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_text.dart';

class CooperativeHomeScreen extends StatelessWidget {
  const CooperativeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.cooperativesHome),
        actions: [
          IconButton(
            tooltip: AppText.cooperativeHowTitle,
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.cooperativeHowTitle,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    const Text(AppText.cooperativeHowInfo),
                  ],
                ),
              ),
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(child: Text(AppText.cooperativeSavingsSummary)),
                      Icon(Icons.visibility_outlined,
                          semanticLabel: 'Summary visibility'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(AppText.cooperativeSummaryUnavailable,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      )),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  const _SummaryRow(
                    icon: Icons.groups_outlined,
                    label: AppText.activeCooperatives,
                    value: AppText.cooperativeSummaryUnavailable,
                  ),
                  const SizedBox(height: 8),
                  const _SummaryRow(
                    icon: Icons.calendar_month_outlined,
                    label: AppText.nextContribution,
                    value: AppText.cooperativeSummaryUnavailable,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Group summary data is unavailable until the service defines its response fields.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/coop/new'),
                    icon: const Icon(Icons.add),
                    label: const Text(AppText.openCreateCooperative),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/coop/join'),
                    icon: const Icon(Icons.link),
                    label: const Text('Join with a code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppText.myCooperatives,
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(AppText.membershipDescription,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Chip(label: Text('Unavailable')),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.people_outline,
                        size: 40, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(AppText.cooperativeEmptyTitle,
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    const Text(AppText.cooperativeEmptyInfo,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.menu_book_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppText.cooperativeHowTitle,
                              style: theme.textTheme.titleSmall),
                          const SizedBox(height: 6),
                          const Text(AppText.cooperativeHowInfo),
                        ],
                      ),
                    ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, semanticLabel: label),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      );
}
