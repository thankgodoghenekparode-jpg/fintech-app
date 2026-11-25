// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_vault_models.dart';
import '../widgets/pas_components.dart';

class VaultDetailPage extends StatefulWidget {
  const VaultDetailPage({
    required this.adapter,
    required this.planId,
    this.onAddMoney,
    this.onWithdraw,
    this.onDeadlineDecision,
    super.key,
  });

  final PayAmSmallVaultAdapter adapter;
  final String planId;
  final Future<void> Function(String planId)? onAddMoney;
  final Future<void> Function(String planId)? onWithdraw;
  final Future<void> Function(String planId)? onDeadlineDecision;

  @override
  State<VaultDetailPage> createState() => _VaultDetailPageState();
}

class _VaultDetailPageState extends State<VaultDetailPage> {
  late Future<PasVaultDetail> _future;
  bool? _autoDebitOverride;
  bool _updatingAutoDebit = false;
  Object? _autoDebitFailure;

  @override
  void initState() {
    super.initState();
    _future = widget.adapter.loadVault(widget.planId);
  }

  void _retry() => setState(() {
        _future = widget.adapter.loadVault(widget.planId);
        _autoDebitFailure = null;
      });

  Future<void> _setAutoDebit(bool enabled) async {
    setState(() {
      _updatingAutoDebit = true;
      _autoDebitFailure = null;
    });
    try {
      await widget.adapter.setAutoDebit(
        PasAutoDebitRequest(planId: widget.planId, enabled: enabled),
      );
      if (mounted) setState(() => _autoDebitOverride = enabled);
    } catch (error) {
      if (mounted) setState(() => _autoDebitFailure = error);
    } finally {
      if (mounted) setState(() => _updatingAutoDebit = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FutureBuilder<PasVaultDetail>(
                future: _future,
                builder: (context, snapshot) => PasPageHeader(
                  title: snapshot.data?.title ?? 'Vault detail',
                  subtitle: 'Pay Am Small · S-PAS-006',
                  onBack: () => Navigator.maybePop(context),
                  showDefaultAction: false,
                ),
              ),
              Expanded(
                child: FutureBuilder<PasVaultDetail>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _VaultError(onRetry: _retry);
                    }
                    final detail = snapshot.data!;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(
                        PasSpacing.page,
                        PasSpacing.xs,
                        PasSpacing.page,
                        PasSpacing.xxl,
                      ),
                      children: [
                        _StatusNotice(detail: detail),
                        const SizedBox(height: PasSpacing.md),
                        _ProgressCard(detail: detail),
                        const SizedBox(height: PasSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: widget.onAddMoney == null
                                    ? null
                                    : () => widget.onAddMoney!(widget.planId),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Money'),
                              ),
                            ),
                            const SizedBox(width: PasSpacing.sm),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: widget.onWithdraw == null
                                    ? null
                                    : () => widget.onWithdraw!(widget.planId),
                                icon: const Icon(Icons.exit_to_app),
                                label: const Text('Withdraw'),
                              ),
                            ),
                          ],
                        ),
                        if (detail.deadlineDecisionAvailable &&
                            widget.onDeadlineDecision != null) ...[
                          const SizedBox(height: PasSpacing.sm),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  widget.onDeadlineDecision!(detail.id),
                              icon: const Icon(Icons.event_available_outlined),
                              label: const Text('Review deadline options'),
                            ),
                          ),
                        ],
                        const SizedBox(height: PasSpacing.md),
                        _VaultItemsCard(items: detail.items),
                        const SizedBox(height: PasSpacing.md),
                        _AutoDebitCard(
                          planId: detail.id,
                          value: _autoDebitOverride ?? detail.autoDebit.enabled,
                          data: detail.autoDebit,
                          updating: _updatingAutoDebit,
                          failure: _autoDebitFailure,
                          onChanged: _setAutoDebit,
                        ),
                        const SizedBox(height: PasSpacing.md),
                        _ContributionsCard(entries: detail.contributions),
                        if (detail.fulfillmentLabel != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _SupportingNotice(text: detail.fulfillmentLabel!),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({required this.detail});
  final PasVaultDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: colors.onPrimaryContainer),
          const SizedBox(width: PasSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.status,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.onPrimaryContainer,
                        )),
                if (detail.statusDetail != null)
                  Text(detail.statusDetail!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.onPrimaryContainer,
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.detail});
  final PasVaultDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Savings Progress',
                      style: theme.textTheme.titleSmall),
                ),
                _InfoPill(
                  icon: Icons.trending_up,
                  label: detail.progressLabel,
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.md),
            SizedBox(
              width: 112,
              height: 112,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: detail.progress.clamp(0, 1),
                      strokeWidth: 9,
                      backgroundColor: colors.surfaceContainerHighest,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          detail.progressLabel,
                          maxLines: 1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text('Funded', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: PasSpacing.md),
            Text('Total Accumulated',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant)),
            Text(detail.savedLabel,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                )),
            Text('Target: ${detail.targetLabel}',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: PasSpacing.md),
            Divider(color: colors.outlineVariant),
            Row(
              children: [
                if (detail.remainingLabel != null)
                  Expanded(
                    child: _MetricTile(
                      label: 'Remaining balance',
                      value: detail.remainingLabel!,
                    ),
                  ),
                if (detail.remainingLabel != null)
                  const SizedBox(width: PasSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    label: 'Timeline',
                    value: detail.remainingTimeLabel,
                    icon: Icons.schedule_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Target completion',
                    value: detail.deadlineLabel,
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, this.icon});
  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PasSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: PasSpacing.xs),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: colors.primary),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: colors.onPrimaryContainer),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onPrimaryContainer,
                )),
      ]),
    );
  }
}

class _VaultItemsCard extends StatelessWidget {
  const _VaultItemsCard({required this.items});
  final List<PasVaultItem> items;

  @override
  Widget build(BuildContext context) => _SectionCard(
        title: 'Items in this Vault',
        trailing: items.isEmpty
            ? null
            : Text('${items.length} ${items.length == 1 ? 'item' : 'items'}'),
        child: items.isEmpty
            ? const Text('Item details are unavailable.')
            : Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    if (index > 0) const Divider(height: PasSpacing.lg),
                    _VaultItemRow(item: items[index]),
                  ],
                ],
              ),
      );
}

class _VaultItemRow extends StatelessWidget {
  const _VaultItemRow({required this.item});
  final PasVaultItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final imageFallback = ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Icon(Icons.inventory_2_outlined, color: colors.primary),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
          child: SizedBox(
            width: 64,
            height: 64,
            child: item.image == null
                ? imageFallback
                : Image(
                    image: item.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => imageFallback,
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : imageFallback,
                  ),
          ),
        ),
        const SizedBox(width: PasSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PasSpacing.xs),
              Text(item.vendorLabel,
                  style: Theme.of(context).textTheme.bodySmall),
              if (item.quantityLabel != null) ...[
                const SizedBox(height: PasSpacing.xs),
                Text(item.quantityLabel!,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: PasSpacing.xs),
              Text('Locked price: ${item.priceLabel}',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutoDebitCard extends StatelessWidget {
  const _AutoDebitCard({
    required this.planId,
    required this.value,
    required this.data,
    required this.updating,
    required this.failure,
    required this.onChanged,
  });

  final String planId;
  final bool value;
  final PasVaultAutoDebit data;
  final bool updating;
  final Object? failure;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return _SectionCard(
      title: data.title,
      leading: const Icon(Icons.autorenew),
      trailing: Switch(
        key: ValueKey('auto-debit-$planId'),
        value: value,
        onChanged: updating ? null : onChanged,
      ),
      child: Column(
        children: [
          _infoRow('Contribution amount', data.amountLabel),
          if (data.frequencyLabel != null)
            _infoRow('Schedule', data.frequencyLabel!),
          const Divider(height: PasSpacing.lg),
          _infoRow('Next Auto-Debit', data.nextRunLabel),
          const Divider(height: PasSpacing.lg),
          _infoRow('Source Account', data.sourceAccountLabel,
              trailing: data.sourceAccountMask),
          if (data.supportingLabel != null) ...[
            const SizedBox(height: PasSpacing.md),
            _SupportingNotice(text: data.supportingLabel!),
          ],
          if (updating) ...[
            const SizedBox(height: PasSpacing.sm),
            const LinearProgressIndicator(),
          ],
          if (failure != null) ...[
            const SizedBox(height: PasSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline, color: colors.error, size: 18),
                const SizedBox(width: PasSpacing.xs),
                Expanded(
                  child: Text(
                    'Auto-debit could not be updated. Try again.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.error),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {String? trailing}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: PasSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, textAlign: TextAlign.end),
                if (trailing != null) Text(trailing, textAlign: TextAlign.end),
              ],
            ),
          ),
        ],
      );
}

class _ContributionsCard extends StatelessWidget {
  const _ContributionsCard({required this.entries});
  final List<PasVaultContribution> entries;

  @override
  Widget build(BuildContext context) => _SectionCard(
        title: 'Vault Contributions',
        child: entries.isEmpty
            ? const Text('Contribution history is unavailable.')
            : Column(
                children: [
                  for (var index = 0; index < entries.length; index++) ...[
                    if (index > 0) const Divider(height: PasSpacing.lg),
                    _ContributionRow(entry: entries[index]),
                  ],
                ],
              ),
      );
}

class _ContributionRow extends StatelessWidget {
  const _ContributionRow({required this.entry});
  final PasVaultContribution entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          entry.success ? Icons.check_circle_outline : Icons.schedule_outlined,
          color: entry.success ? colors.tertiary : colors.secondary,
        ),
        const SizedBox(width: PasSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge),
              Text('${entry.dateLabel} · ${entry.statusLabel}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: PasSpacing.sm),
        Flexible(
          child: Text(
            entry.amountLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                          color: Theme.of(context).colorScheme.primary),
                      child: leading!,
                    ),
                    const SizedBox(width: PasSpacing.sm),
                  ],
                  Expanded(
                      child: Text(title,
                          style: Theme.of(context).textTheme.titleSmall)),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: PasSpacing.md),
              child,
            ],
          ),
        ),
      );
}

class _SupportingNotice extends StatelessWidget {
  const _SupportingNotice({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _VaultError extends StatelessWidget {
  const _VaultError({required this.onRetry});
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
              const Text('Vault details are unavailable right now.'),
              const SizedBox(height: PasSpacing.md),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}
