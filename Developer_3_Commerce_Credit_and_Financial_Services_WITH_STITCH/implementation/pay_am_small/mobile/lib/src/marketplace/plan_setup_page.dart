// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pas_plan_models.dart';
import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';
import '../widgets/pas_components.dart';
import '../widgets/pas_plan_components.dart';

class PlanSetupPage extends StatefulWidget {
  const PlanSetupPage({
    required this.adapter,
    required this.copy,
    required this.products,
    required this.onReview,
    this.onAddItems,
    super.key,
  });

  final PayAmSmallPlanAdapter adapter;
  final PayAmSmallCopy copy;
  final List<PasMarketplaceProduct> products;
  final ValueChanged<PasPlanQuote> onReview;
  final VoidCallback? onAddItems;

  @override
  State<PlanSetupPage> createState() => _PlanSetupPageState();
}

class _PlanSetupPageState extends State<PlanSetupPage> {
  DateTime? _deadline;
  late Future<PasPlanQuote> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = _requestQuote();
  }

  @override
  void didUpdateWidget(covariant PlanSetupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adapter != widget.adapter ||
        !_sameProductIds(oldWidget.products, widget.products)) {
      _quoteFuture = _requestQuote();
    }
  }

  bool _sameProductIds(
    List<PasMarketplaceProduct> previous,
    List<PasMarketplaceProduct> next,
  ) =>
      previous.length == next.length &&
      List.generate(previous.length, (index) => previous[index].id)
          .asMap()
          .entries
          .every((entry) => entry.value == next[entry.key].id);

  Future<PasPlanQuote> _requestQuote() {
    if (widget.products.isEmpty) {
      return Future<PasPlanQuote>.error(
        const PasPlanFailure(PasPlanFailureKind.general),
      );
    }
    return widget.adapter.quotePlan(
      PasPlanQuoteRequest(
        productIds: widget.products.map((product) => product.id).toList(),
        deadline: _deadline,
      ),
    );
  }

  void _retryQuote() => setState(() => _quoteFuture = _requestQuote());

  Future<void> _selectDeadline() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline ?? today,
      firstDate: DateTime(1900),
      lastDate: DateTime(9999, 12, 31),
      helpText: widget.copy.planDeadline,
    );
    if (selected == null || !mounted) return;
    setState(() {
      _deadline = selected;
      _quoteFuture = _requestQuote();
    });
  }

  String _dateLabel(DateTime date) => '${date.day.toString().padLeft(2, '0')} '
      '${widget.copy.planMonthNames[date.month - 1]} ${date.year}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PasPageHeader(
              title: widget.copy.planSetupTitle,
              onBack: () => Navigator.maybePop(context),
            ),
            PasPlanStepProgress(
              label: widget.copy.planStepOne,
              value: 0.5,
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
                  _sectionHeading(
                    context,
                    widget.copy.planItemsInVault,
                    showMode: true,
                  ),
                  const SizedBox(height: PasSpacing.sm),
                  if (widget.products.isEmpty)
                    _EmptyVaultCard(copy: widget.copy)
                  else
                    for (final product in widget.products) ...[
                      _PlanProductCard(product: product, copy: widget.copy),
                      const SizedBox(height: PasSpacing.sm),
                    ],
                  OutlinedButton.icon(
                    onPressed: widget.onAddItems,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(widget.copy.planAddAnotherItem),
                  ),
                  if (widget.onAddItems == null)
                    Padding(
                      padding: const EdgeInsets.only(top: PasSpacing.xs),
                      child: Text(
                        widget.copy.planAddItemsUnavailable,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ),
                  const SizedBox(height: PasSpacing.lg),
                  _sectionHeading(context, widget.copy.planDeadline),
                  const SizedBox(height: PasSpacing.sm),
                  OutlinedButton(
                    onPressed: _selectDeadline,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: PasSpacing.md),
                        Expanded(
                          child: Text(
                            _deadline == null
                                ? widget.copy.planChooseDeadline
                                : _dateLabel(_deadline!),
                          ),
                        ),
                        const Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                  const SizedBox(height: PasSpacing.xs),
                  Text(
                    widget.copy.planDeadlineHelp,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: PasSpacing.lg),
                  _sectionHeading(context, widget.copy.planFundingMethod),
                  const SizedBox(height: PasSpacing.sm),
                  _FundingChoice(copy: widget.copy),
                  const SizedBox(height: PasSpacing.lg),
                  FutureBuilder<PasPlanQuote>(
                    future: _quoteFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _QuoteLoading(copy: widget.copy);
                      }
                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      final quote = snapshot.data;
                      if (quote == null) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PasPlanFactsCard(
                            title: widget.copy.planQuoteDetails,
                            facts: quote.facts,
                            emptyText: widget.copy.planQuoteNoFacts,
                          ),
                          const SizedBox(height: PasSpacing.md),
                          PasPlanRulesCard(
                            title: widget.copy.planRules,
                            terms: quote.terms,
                            emptyText: widget.copy.planQuoteNoTerms,
                          ),
                        ],
                      );
                    },
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
              child: FutureBuilder<PasPlanQuote>(
                future: _quoteFuture,
                builder: (context, snapshot) {
                  final quote = snapshot.data;
                  final enabled =
                      snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasError &&
                          quote != null &&
                          widget.products.isNotEmpty &&
                          quote.terms.isNotEmpty &&
                          quote.quoteId.isNotEmpty &&
                          quote.termsVersion.isNotEmpty;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (snapshot.connectionState == ConnectionState.waiting)
                        Padding(
                          padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                          child: _QuoteLoading(copy: widget.copy),
                        ),
                      if (snapshot.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: PasSpacing.sm),
                          child: PasPlanFailurePanel(
                            failure: snapshot.error!,
                            copy: widget.copy,
                            onRetry: _retryQuote,
                          ),
                        ),
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasError &&
                          quote != null &&
                          quote.terms.isEmpty)
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
                      PasPrimaryButton(
                        label: widget.copy.planContinueReview,
                        onPressed:
                            enabled ? () => widget.onReview(quote) : null,
                      ),
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

  Widget _sectionHeading(
    BuildContext context,
    String title, {
    bool showMode = false,
  }) =>
      Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),
          if (showMode) ...[
            Icon(Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary, size: 18),
            const SizedBox(width: PasSpacing.xs),
            Text(widget.copy.priceLock,
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ],
      );
}

class _PlanProductCard extends StatelessWidget {
  const _PlanProductCard({required this.product, required this.copy});

  final PasMarketplaceProduct product;
  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: PasProductImage(image: product.image, height: 72),
            ),
            const SizedBox(width: PasSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: PasSpacing.xs),
                  Text(
                    product.vendorName,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  if (product.priceKobo != null) ...[
                    const SizedBox(height: PasSpacing.sm),
                    Text(
                      formatPasNaira(product.priceKobo!),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundingChoice extends StatelessWidget {
  const _FundingChoice({required this.copy});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment<bool>(
                value: false,
                label: Text(copy.planManualFunding),
                icon: const Icon(Icons.touch_app_outlined),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(copy.planAutomatedFunding),
                icon: const Icon(Icons.autorenew),
                enabled: false,
              ),
            ],
            selected: const {false},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: PasSpacing.xs),
          Text(
            copy.planAutoSaveUnavailable,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      );
}

class _QuoteLoading extends StatelessWidget {
  const _QuoteLoading({required this.copy});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.lg),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: PasSpacing.md),
              Expanded(child: Text(copy.planQuoteLoading)),
            ],
          ),
        ),
      );
}

class _EmptyVaultCard extends StatelessWidget {
  const _EmptyVaultCard({required this.copy});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Text(
            copy.planAddItemsUnavailable,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
}
