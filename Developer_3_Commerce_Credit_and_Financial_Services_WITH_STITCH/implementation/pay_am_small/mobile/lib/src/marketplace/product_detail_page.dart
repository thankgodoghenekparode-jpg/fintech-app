// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';
import '../widgets/pas_components.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    required this.adapter,
    required this.copy,
    required this.productId,
    required this.onOpenVendor,
    required this.onContinue,
    super.key,
  });

  final PayAmSmallBrowseAdapter adapter;
  final PayAmSmallCopy copy;
  final String productId;
  final ValueChanged<String> onOpenVendor;
  final ValueChanged<PasPurchaseOption> onContinue;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<PasProductDetail?> _productFuture;
  PasPurchaseOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.adapter.loadProduct(widget.productId);
  }

  @override
  void didUpdateWidget(covariant ProductDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adapter != widget.adapter ||
        oldWidget.productId != widget.productId) {
      _selectedOption = null;
      _productFuture = widget.adapter.loadProduct(widget.productId);
    }
  }

  void _retry() => setState(
        () => _productFuture = widget.adapter.loadProduct(widget.productId),
      );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: PasCenteredPage(
          child: FutureBuilder<PasProductDetail?>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return PasLoadingState(copy: widget.copy);
              }
              if (snapshot.hasError) {
                return PasAsyncState(
                  copy: widget.copy,
                  failure: snapshot.error,
                  onRetry: _retry,
                );
              }
              final detail = snapshot.data;
              if (detail == null) {
                return PasAsyncState(
                  copy: widget.copy,
                  onRetry: _retry,
                  notFound: true,
                );
              }

              final product = detail.product;
              final options = product.availableOptions.toList();
              final selected = options.contains(_selectedOption)
                  ? _selectedOption
                  : (options.isEmpty ? null : options.first);
              final canContinue = product.isAvailable && selected != null;

              return Column(
                children: [
                  PasPageHeader(
                    title: widget.copy.productDetails,
                    onBack: () => Navigator.maybePop(context),
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
                        _ProductShowcase(
                          image: product.detailImage ?? product.image,
                          category: product.category,
                          isAvailable: product.isAvailable,
                          unavailableLabel: widget.copy.outOfStock,
                        ),
                        const SizedBox(height: PasSpacing.lg),
                        if (product.category != null)
                          Text(
                            product.category!.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        const SizedBox(height: PasSpacing.xs),
                        Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: PasSpacing.lg),
                        _VendorDetailCard(
                          product: product,
                          detail: detail,
                          copy: widget.copy,
                          onTap: () => widget.onOpenVendor(product.vendorId),
                        ),
                        if (product.priceKobo != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          Card(
                            color: colors.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(PasSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item price',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: PasSpacing.xs),
                                  Text(
                                    formatPasNaira(product.priceKobo!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: PasSpacing.xl),
                        PasSectionTitle(widget.copy.purchaseOptions),
                        const SizedBox(height: PasSpacing.sm),
                        if (!product.isAvailable)
                          _UnavailableNotice(label: widget.copy.outOfStock)
                        else if (options.isEmpty)
                          Text(
                            widget.copy.optionUnavailable,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          for (final option in options)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: PasSpacing.sm,
                              ),
                              child: _PurchaseOptionTile(
                                title: option == PasPurchaseOption.priceLock
                                    ? widget.copy.priceLock
                                    : widget.copy.payInFull,
                                selected: selected == option,
                                onTap: () =>
                                    setState(() => _selectedOption = option),
                              ),
                            ),
                        if (detail.deliveryTerms != null) ...[
                          const SizedBox(height: PasSpacing.lg),
                          _TermsCard(
                            icon: Icons.local_shipping_outlined,
                            title: widget.copy.deliveryTerms,
                            body: detail.deliveryTerms!,
                          ),
                        ],
                        if (selected == PasPurchaseOption.priceLock &&
                            detail.priceLockTerms != null) ...[
                          const SizedBox(height: PasSpacing.md),
                          _TermsCard(
                            icon: Icons.lock_outline,
                            title: widget.copy.lockedPricePromise,
                            body: detail.priceLockTerms!,
                          ),
                        ],
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
                    child: PasPrimaryButton(
                      label: widget.copy.continueLabel,
                      onPressed: canContinue
                          ? () => widget.onContinue(selected)
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductShowcase extends StatelessWidget {
  const _ProductShowcase({
    required this.image,
    required this.category,
    required this.isAvailable,
    required this.unavailableLabel,
  });

  final ImageProvider? image;
  final String? category;
  final bool isAvailable;
  final String unavailableLabel;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        child: SizedBox(
          height: 232,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PasProductImage(image: image, height: 232),
              if (category != null)
                Positioned(
                  left: PasSpacing.md,
                  top: PasSpacing.md,
                  child: _DetailBadge(
                    icon: Icons.category_outlined,
                    label: category!,
                  ),
                ),
              if (!isAvailable)
                Positioned(
                  right: PasSpacing.md,
                  bottom: PasSpacing.md,
                  child: _DetailBadge(
                    icon: Icons.info_outline,
                    label: unavailableLabel,
                  ),
                ),
            ],
          ),
        ),
      );
}

class _VendorDetailCard extends StatelessWidget {
  const _VendorDetailCard({
    required this.product,
    required this.detail,
    required this.copy,
    required this.onTap,
  });

  final PasMarketplaceProduct product;
  final PasProductDetail detail;
  final PayAmSmallCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(PasSpacing.md),
            child: Row(
              children: [
                PasVendorImage(image: product.vendorImage, radius: 24),
                const SizedBox(width: PasSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.vendorName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: PasSpacing.xs),
                      if (detail.vendorRating != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: PasSpacing.xs),
                            Flexible(
                              child: Text(
                                '${detail.vendorRating!.toStringAsFixed(1)}${detail.vendorReviewCount == null ? '' : ' · ${detail.vendorReviewCount} ${copy.reviewsLabel}'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        )
                      else if (product.isVerifiedVendor)
                        Row(
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              size: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: PasSpacing.xs),
                            Flexible(
                              child: Text(
                                copy.verifiedVendor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      );
}

class _PurchaseOptionTile extends StatelessWidget {
  const _PurchaseOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PasSpacing.md,
              vertical: PasSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: PasSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: selected ? FontWeight.w700 : null,
                        ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, size: 18, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsCard extends StatelessWidget {
  const _TermsCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: PasSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: PasSpacing.xs),
                    Text(body),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _UnavailableNotice extends StatelessWidget {
  const _UnavailableNotice({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(PasSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: PasSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
}

class _DetailBadge extends StatelessWidget {
  const _DetailBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PasSpacing.sm,
            vertical: PasSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 15, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: PasSpacing.xs),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      );
}
