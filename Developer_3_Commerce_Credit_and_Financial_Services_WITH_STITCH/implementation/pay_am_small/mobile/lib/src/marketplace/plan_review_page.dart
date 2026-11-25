// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_plan_models.dart';
import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';
import '../widgets/pas_components.dart';
import '../widgets/pas_plan_components.dart';

class PlanReviewPage extends StatefulWidget {
  const PlanReviewPage({
    required this.adapter,
    required this.copy,
    required this.quote,
    required this.products,
    required this.onRefreshQuote,
    super.key,
  });

  final PayAmSmallPlanAdapter adapter;
  final PayAmSmallCopy copy;
  final PasPlanQuote quote;
  final List<PasMarketplaceProduct> products;
  final VoidCallback onRefreshQuote;

  @override
  State<PlanReviewPage> createState() => _PlanReviewPageState();
}

class _PlanReviewPageState extends State<PlanReviewPage> {
  bool _acceptedTerms = false;
  bool _creating = false;
  PasPlanCreationResult? _result;
  Object? _failure;

  bool get _canCreate =>
      _acceptedTerms &&
      widget.quote.quoteId.isNotEmpty &&
      widget.quote.termsVersion.isNotEmpty &&
      widget.quote.terms.isNotEmpty &&
      !_creating &&
      _failure == null &&
      _result == null;

  Future<void> _createPlan() async {
    if (!_canCreate) return;
    setState(() {
      _creating = true;
      _failure = null;
    });
    try {
      final result = await widget.adapter.createPlan(
        PasPlanCreateRequest(
          quoteId: widget.quote.quoteId,
          termsVersion: widget.quote.termsVersion,
        ),
      );
      if (mounted) setState(() => _result = result);
    } catch (error) {
      if (mounted) setState(() => _failure = error);
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _retryCreatePlan() async {
    setState(() => _failure = null);
    await _createPlan();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PasPageHeader(
                title: widget.copy.planReviewTitle,
                onBack: () => Navigator.maybePop(context),
              ),
              PasPlanStepProgress(
                label: widget.copy.planStepTwo,
                value: 1,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    PasSpacing.page,
                    0,
                    PasSpacing.page,
                    PasSpacing.xl,
                  ),
                  children: [
                    _ProductSummaryCard(
                      products: widget.products,
                      copy: widget.copy,
                    ),
                    const SizedBox(height: PasSpacing.md),
                    PasPlanFactsCard(
                      title: widget.copy.planQuoteDetails,
                      facts: widget.quote.facts,
                      emptyText: widget.copy.planQuoteNoFacts,
                    ),
                    const SizedBox(height: PasSpacing.md),
                    PasPlanRulesCard(
                      title: widget.copy.planFullTerms,
                      terms: widget.quote.terms,
                      emptyText: widget.copy.planTermsMissing,
                      expandable: true,
                    ),
                    const SizedBox(height: PasSpacing.md),
                    _TermsConsent(
                      copy: widget.copy,
                      value: _acceptedTerms,
                      onChanged: _result == null && !_creating
                          ? (value) => setState(
                                () => _acceptedTerms = value ?? false,
                              )
                          : null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  PasSpacing.page,
                  PasSpacing.sm,
                  PasSpacing.page,
                  PasSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.quote.terms.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                        child: PasPlanFailurePanel(
                          failure: const PasPlanFailure(
                            PasPlanFailureKind.general,
                          ),
                          copy: widget.copy,
                          generalMessage: widget.copy.planTermsMissing,
                        ),
                      ),
                    if (_creating)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(PasSpacing.md),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: PasSpacing.md),
                                Expanded(child: Text(widget.copy.planCreating)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (_failure != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                        child: PasPlanFailurePanel(
                          failure: _failure!,
                          copy: widget.copy,
                          generalMessage: widget.copy.planCreateError,
                          onRetry: _failure is PasPlanFailure &&
                                  (_failure as PasPlanFailure).kind ==
                                      PasPlanFailureKind.general
                              ? _retryCreatePlan
                              : null,
                          onRefresh: widget.onRefreshQuote,
                        ),
                      ),
                    if (_result != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                        child: PasPlanSuccessPanel(
                          title: _result!.disposition ==
                                  PasPlanCreationDisposition.previewOnly
                              ? widget.copy.planPreviewComplete
                              : widget.copy.planCreated,
                          message: _result!.disposition ==
                                  PasPlanCreationDisposition.previewOnly
                              ? widget.copy.planPreviewCompleteBody
                              : widget.copy.planCreatedBody,
                        ),
                      ),
                    if (_result == null)
                      PasPrimaryButton(
                        label: widget.copy.planAccept,
                        onPressed: _canCreate ? _createPlan : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _ProductSummaryCard extends StatelessWidget {
  const _ProductSummaryCard({required this.products, required this.copy});

  final List<PasMarketplaceProduct> products;
  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: PasSpacing.sm,
              runSpacing: PasSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  avatar: const Icon(Icons.lock_outline, size: 16),
                  label: Text(copy.priceLock),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: PasSpacing.sm),
            for (var index = 0; index < products.length; index++) ...[
              if (index > 0) const Divider(height: PasSpacing.lg),
              Text(products[index].title, style: theme.textTheme.titleSmall),
              const SizedBox(height: PasSpacing.xs),
              Text(
                products[index].vendorName,
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

class _TermsConsent extends StatelessWidget {
  const _TermsConsent({
    required this.copy,
    required this.value,
    required this.onChanged,
  });

  final PayAmSmallCopy copy;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surfaceContainerLow,
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: PasSpacing.sm),
        title: Text(copy.planAcceptTerms),
      ),
    );
  }
}
