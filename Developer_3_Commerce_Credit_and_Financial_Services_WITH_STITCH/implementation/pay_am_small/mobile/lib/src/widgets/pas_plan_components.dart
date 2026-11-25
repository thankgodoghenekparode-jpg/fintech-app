// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_plan_models.dart';
import '../pay_am_small_copy.dart';
import 'pas_components.dart';

class PasPlanStepProgress extends StatelessWidget {
  const PasPlanStepProgress({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PasSpacing.page,
        0,
        PasSpacing.page,
        PasSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: PasSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 4,
              color: colors.primary,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class PasPlanFactsCard extends StatelessWidget {
  const PasPlanFactsCard({
    required this.title,
    required this.facts,
    required this.emptyText,
    super.key,
  });

  final String title;
  final List<PasPlanQuoteFact> facts;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final leadIndex = facts.indexWhere((fact) => fact.emphasized);
    final leadFact =
        facts.isEmpty ? null : facts[leadIndex < 0 ? 0 : leadIndex];
    final supportingText = leadFact?.supportingText;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: PasSpacing.md),
            if (facts.isEmpty)
              Text(emptyText, style: theme.textTheme.bodySmall)
            else ...[
              _FactValue(
                fact: facts[leadIndex < 0 ? 0 : leadIndex],
                prominent: true,
              ),
              for (var index = 0; index < facts.length; index++)
                if (index != (leadIndex < 0 ? 0 : leadIndex)) ...[
                  const Divider(height: PasSpacing.lg),
                  _FactValue(fact: facts[index]),
                ],
            ],
            if (supportingText != null) ...[
              const SizedBox(height: PasSpacing.xs),
              Text(
                supportingText,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FactValue extends StatelessWidget {
  const _FactValue({required this.fact, this.prominent = false});

  final PasPlanQuoteFact fact;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    if (prominent) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(PasSpacing.md),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fact.label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: PasSpacing.xs),
            Text(fact.value, style: theme.textTheme.titleLarge),
            if (fact.supportingText != null) ...[
              const SizedBox(height: PasSpacing.xs),
              Text(
                fact.supportingText!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(fact.label, style: theme.textTheme.bodySmall),
        ),
        const SizedBox(width: PasSpacing.md),
        Flexible(
          child: Text(
            fact.value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class PasPlanRulesCard extends StatelessWidget {
  const PasPlanRulesCard({
    required this.title,
    required this.terms,
    required this.emptyText,
    this.expandable = false,
    super.key,
  });

  final String title;
  final List<PasPlanTermSection> terms;
  final String emptyText;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PasSpacing.xs),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: PasSpacing.sm),
            if (terms.isEmpty)
              Padding(
                padding: const EdgeInsets.all(PasSpacing.xs),
                child: Text(emptyText, style: theme.textTheme.bodySmall),
              )
            else if (expandable)
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: PasSpacing.xs,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  PasSpacing.xs,
                  0,
                  PasSpacing.xs,
                  PasSpacing.sm,
                ),
                title: Text(
                  terms.first.title,
                  style: theme.textTheme.titleSmall,
                ),
                children: [
                  for (var index = 0; index < terms.length; index++) ...[
                    if (index > 0) const Divider(height: PasSpacing.lg),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index > 0)
                            Text(
                              terms[index].title,
                              style: theme.textTheme.titleSmall,
                            ),
                          if (index > 0) const SizedBox(height: PasSpacing.xs),
                          Text(
                            terms[index].body,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              )
            else
              for (var index = 0; index < terms.length; index++) ...[
                if (index > 0) const Divider(height: PasSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PasSpacing.xs,
                    vertical: PasSpacing.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(terms[index].title,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: PasSpacing.xs),
                      Text(
                        terms[index].body,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class PasPlanFailurePanel extends StatelessWidget {
  const PasPlanFailurePanel({
    required this.failure,
    required this.copy,
    this.generalMessage,
    this.onRetry,
    this.onRefresh,
    super.key,
  });

  final Object failure;
  final PayAmSmallCopy copy;
  final String? generalMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final kind = failure is PasPlanFailure
        ? (failure as PasPlanFailure).kind
        : PasPlanFailureKind.general;
    final message = switch (kind) {
      PasPlanFailureKind.invalidDeadline => copy.planDeadlineInvalid,
      PasPlanFailureKind.vendorUnavailable => copy.planVendorUnavailable,
      PasPlanFailureKind.restricted => copy.planRestricted,
      PasPlanFailureKind.termsChanged => copy.planTermsChanged,
      PasPlanFailureKind.general => generalMessage ?? copy.planQuoteError,
    };
    final needsRefresh = kind == PasPlanFailureKind.termsChanged ||
        kind == PasPlanFailureKind.invalidDeadline;
    final action = switch (kind) {
      PasPlanFailureKind.termsChanged ||
      PasPlanFailureKind.invalidDeadline =>
        onRefresh,
      PasPlanFailureKind.general => onRetry,
      PasPlanFailureKind.vendorUnavailable ||
      PasPlanFailureKind.restricted =>
        null,
    };
    final actionLabel =
        needsRefresh ? copy.planRefreshQuote : copy.planTryAgain;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PasSpacing.md),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, color: colors.onErrorContainer),
              const SizedBox(width: PasSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onErrorContainer,
                      ),
                ),
              ),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: PasSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: action,
                child: Text(actionLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PasPlanSuccessPanel extends StatelessWidget {
  const PasPlanSuccessPanel({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PasSpacing.lg),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: colors.onTertiaryContainer),
          const SizedBox(width: PasSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: PasSpacing.xs),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
