// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_vault_models.dart';
import '../pay_am_small_copy.dart';
import '../widgets/pas_components.dart';

class MyPlansPage extends StatefulWidget {
  const MyPlansPage({
    required this.adapter,
    required this.copy,
    required this.onOpenVault,
    super.key,
  });

  final PayAmSmallPlansAdapter adapter;
  final PayAmSmallCopy copy;
  final ValueChanged<String> onOpenVault;

  @override
  State<MyPlansPage> createState() => _MyPlansPageState();
}

class _MyPlansPageState extends State<MyPlansPage> {
  late Future<PasPlanListData> _future;
  PasPlanGroup _group = PasPlanGroup.vault;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadPlans();
  }

  void _retry() {
    setState(() {
      _future = widget.adapter.loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PasPageHeader(
                title: 'My Installment Plans',
                subtitle: 'Pay Am Small · S-PAS-005',
                onBack: () => Navigator.maybePop(context),
                showDefaultAction: false,
              ),
              Expanded(
                child: FutureBuilder<PasPlanListData>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _PlansError(onRetry: _retry);
                    }
                    final data = snapshot.data!;
                    final entries = data.entries
                        .where((entry) => entry.group == _group)
                        .toList(growable: false);
                    return RefreshIndicator(
                      onRefresh: () async => _retry(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          PasSpacing.page,
                          PasSpacing.sm,
                          PasSpacing.page,
                          PasSpacing.xxl,
                        ),
                        children: [
                          _PlansSummary(data: data),
                          const SizedBox(height: PasSpacing.xl),
                          _PlanGroupTabs(
                            selected: _group,
                            onChanged: (group) =>
                                setState(() => _group = group),
                          ),
                          const SizedBox(height: PasSpacing.xl),
                          if (entries.isEmpty)
                            _EmptyPlans(group: _group)
                          else
                            for (final plan in entries) ...[
                              _PlanCard(
                                plan: plan,
                                onOpen: plan.group == PasPlanGroup.vault
                                    ? () => widget.onOpenVault(plan.id)
                                    : null,
                              ),
                              const SizedBox(height: PasSpacing.lg),
                            ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class _PlansSummary extends StatelessWidget {
  const _PlansSummary({required this.data});

  final PasPlanListData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final foreground = dark ? colors.onSurface : colors.onPrimary;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.lg),
      decoration: BoxDecoration(
        gradient: dark
            ? LinearGradient(
                colors: [colors.surfaceContainer, colors.surfaceContainerHigh],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [colors.primary, colors.onPrimaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(PasSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: foreground),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL LOCKED ASSET VALUE',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: dark
                                      ? colors.onSurfaceVariant
                                      : colors.onPrimary.withValues(alpha: .84),
                                  letterSpacing: 1,
                                ),
                      ),
                      const SizedBox(height: PasSpacing.xs),
                      Text(
                        data.totalValueLabel,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.lock_outline,
                  color: dark ? colors.primary : foreground,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.md),
            Divider(color: foreground.withValues(alpha: .22)),
            Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Total Saved So Far',
                    value: data.totalSavedLabel,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: PasSpacing.md),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Active Portfolio',
                    value:
                        '${data.activeVaultCountLabel} vaults · ${data.creditCountLabel} credit',
                    color: foreground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: .84),
                ),
          ),
          const SizedBox(height: PasSpacing.xs),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      );
}

class _PlanGroupTabs extends StatelessWidget {
  const _PlanGroupTabs({required this.selected, required this.onChanged});

  final PasPlanGroup selected;
  final ValueChanged<PasPlanGroup> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          _tab(context, PasPlanGroup.vault, 'Vaults', Icons.shield_outlined),
          _tab(context, PasPlanGroup.credit, 'Credit', Icons.credit_card),
          _tab(context, PasPlanGroup.completed, 'Completed',
              Icons.check_circle_outline),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    PasPlanGroup group,
    String label,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;
    final active = selected == group;
    return Expanded(
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
          onTap: () => onChanged(group),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            decoration: BoxDecoration(
              color: active ? colors.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: active ? colors.primary : null),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: active ? colors.primary : null,
                          fontWeight: active ? FontWeight.w700 : null,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onOpen});

  final PasPlanListEntry plan;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final progress = plan.progress;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusBadge(label: plan.status),
                const SizedBox(width: PasSpacing.sm),
                Expanded(
                  child: Text(
                    plan.vendorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _VaultImage(image: plan.image, size: 64),
                const SizedBox(width: PasSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: PasSpacing.xs),
                      Text(plan.deadlineLabel,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PasSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.amountSummary,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (progress != null) ...[
                    const SizedBox(height: PasSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        minHeight: 8,
                        backgroundColor: colors.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: PasSpacing.xs),
                    Text(plan.progressLabel, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            if (plan.nextPaymentLabel != null ||
                plan.autoDebitLabel != null) ...[
              const SizedBox(height: PasSpacing.md),
              Row(
                children: [
                  Icon(Icons.event_outlined, size: 18, color: colors.secondary),
                  const SizedBox(width: PasSpacing.xs),
                  Expanded(
                    child: Text(
                      [
                        if (plan.nextPaymentLabel != null)
                          plan.nextPaymentLabel!,
                        if (plan.nextPaymentDateLabel != null)
                          plan.nextPaymentDateLabel!,
                      ].join(' · '),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (plan.autoDebitLabel != null)
                    Text(plan.autoDebitLabel!,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: colors.primary)),
                ],
              ),
            ],
            const SizedBox(height: PasSpacing.md),
            OutlinedButton.icon(
              key: ValueKey('open-vault-${plan.id}'),
              onPressed: onOpen,
              icon: const Icon(Icons.visibility_outlined),
              label:
                  Text(onOpen == null ? 'Details unavailable' : 'View Vault'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 170),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined,
              size: 15, color: colors.onPrimaryContainer),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onPrimaryContainer,
                    )),
          ),
        ],
      ),
    );
  }
}

class _VaultImage extends StatelessWidget {
  const _VaultImage({required this.image, required this.size});
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fallback = ColoredBox(
      color: colors.primaryContainer,
      child: Icon(Icons.inventory_2_outlined, color: colors.primary),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
      child: SizedBox(
        width: size,
        height: size,
        child: image == null
            ? fallback
            : Image(
                image: image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : fallback,
              ),
      ),
    );
  }
}

class _EmptyPlans extends StatelessWidget {
  const _EmptyPlans({required this.group});
  final PasPlanGroup group;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.savings_outlined,
                size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: PasSpacing.md),
            Text(
              switch (group) {
                PasPlanGroup.vault => 'No vault plans yet',
                PasPlanGroup.credit => 'No credit plans yet',
                PasPlanGroup.completed => 'No completed plans yet',
              },
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
}

class _PlansError extends StatelessWidget {
  const _PlansError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 40),
              const SizedBox(height: PasSpacing.md),
              const Text('We couldn’t load your plans.'),
              const SizedBox(height: PasSpacing.md),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}
