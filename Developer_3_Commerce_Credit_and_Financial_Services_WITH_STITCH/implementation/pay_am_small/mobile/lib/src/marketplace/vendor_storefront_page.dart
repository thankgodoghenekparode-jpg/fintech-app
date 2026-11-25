// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';
import '../widgets/pas_components.dart';

class VendorStorefrontPage extends StatefulWidget {
  const VendorStorefrontPage({
    required this.adapter,
    required this.copy,
    required this.vendorId,
    required this.onOpenProduct,
    super.key,
  });

  final PayAmSmallBrowseAdapter adapter;
  final PayAmSmallCopy copy;
  final String vendorId;
  final ValueChanged<String> onOpenProduct;

  @override
  State<VendorStorefrontPage> createState() => _VendorStorefrontPageState();
}

class _VendorStorefrontPageState extends State<VendorStorefrontPage> {
  late Future<PasVendorStorefront?> _storefrontFuture;

  @override
  void initState() {
    super.initState();
    _storefrontFuture = widget.adapter.loadStorefront(widget.vendorId);
  }

  @override
  void didUpdateWidget(covariant VendorStorefrontPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adapter != widget.adapter ||
        oldWidget.vendorId != widget.vendorId) {
      _storefrontFuture = widget.adapter.loadStorefront(widget.vendorId);
    }
  }

  void _retry() => setState(
        () =>
            _storefrontFuture = widget.adapter.loadStorefront(widget.vendorId),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: PasCenteredPage(
            child: Column(
              children: [
                PasPageHeader(
                  title: widget.copy.storefrontTitle,
                  onBack: () => Navigator.maybePop(context),
                ),
                Expanded(
                  child: FutureBuilder<PasVendorStorefront?>(
                    future: _storefrontFuture,
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
                      final vendor = snapshot.data;
                      if (vendor == null) {
                        return PasAsyncState(
                          copy: widget.copy,
                          onRetry: _retry,
                          notFound: true,
                        );
                      }
                      if (vendor.isSuspended) {
                        return PasAsyncState(
                          copy: widget.copy,
                          failure: const PasBrowseFailure(
                            PasBrowseFailureKind.vendorSuspended,
                          ),
                          onRetry: _retry,
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(
                          PasSpacing.page,
                          0,
                          PasSpacing.page,
                          PasSpacing.xxl,
                        ),
                        children: [
                          _StorefrontProfileCard(
                            vendor: vendor,
                            copy: widget.copy,
                          ),
                          const SizedBox(height: PasSpacing.xl),
                          PasSectionTitle(
                            'Catalog & Price-Lock Plans',
                            trailing: Text(
                              '${vendor.products.length} ${vendor.products.length == 1 ? 'item' : 'items'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(height: PasSpacing.md),
                          if (vendor.products.isEmpty)
                            PasEmptyState(copy: widget.copy)
                          else
                            for (final product in vendor.products)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: PasSpacing.md,
                                ),
                                child: _StorefrontProductCard(
                                  product: product,
                                  copy: widget.copy,
                                  onTap: () => widget.onOpenProduct(product.id),
                                ),
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StorefrontProfileCard extends StatelessWidget {
  const _StorefrontProfileCard({required this.vendor, required this.copy});

  final PasVendorStorefront vendor;
  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasVendorImage(image: vendor.image, radius: 30),
                const SizedBox(width: PasSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (vendor.isVerified) ...[
                        const SizedBox(height: PasSpacing.xs),
                        PasVendorBadge(label: copy.verifiedVendor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (vendor.rating != null) ...[
              const SizedBox(height: PasSpacing.md),
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 18, color: colors.tertiary),
                  const SizedBox(width: PasSpacing.xs),
                  Text(
                    '${vendor.rating!.toStringAsFixed(1)}${vendor.reviewCount == null ? '' : ' · ${vendor.reviewCount} ${copy.reviewsLabel}'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            if (vendor.about != null) ...[
              const SizedBox(height: PasSpacing.lg),
              Text(copy.aboutVendor,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: PasSpacing.xs),
              Text(vendor.about!),
            ],
            if (vendor.deliveryTerms != null) ...[
              const SizedBox(height: PasSpacing.lg),
              Divider(color: colors.outlineVariant),
              const SizedBox(height: PasSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.local_shipping_outlined,
                      color: colors.primary, size: 20),
                  const SizedBox(width: PasSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(copy.deliveryTerms,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: PasSpacing.xs),
                        Text(vendor.deliveryTerms!),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StorefrontProductCard extends StatelessWidget {
  const _StorefrontProductCard({
    required this.product,
    required this.copy,
    required this.onTap,
  });

  final PasMarketplaceProduct product;
  final PayAmSmallCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final image = product.storefrontImage ?? product.image;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
                    child: SizedBox(
                      width: 104,
                      height: 104,
                      child: PasProductImage(image: image, height: 104),
                    ),
                  ),
                  const SizedBox(width: PasSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.category != null)
                          Text(
                            product.category!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        const SizedBox(height: PasSpacing.xs),
                        Text(
                          product.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: PasSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              product.isVerifiedVendor
                                  ? Icons.verified_outlined
                                  : Icons.storefront_outlined,
                              size: 15,
                              color: colors.primary,
                            ),
                            const SizedBox(width: PasSpacing.xs),
                            Expanded(
                              child: Text(
                                product.vendorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        if (product.priceKobo != null) ...[
                          const SizedBox(height: PasSpacing.sm),
                          Text(
                            formatPasNaira(product.priceKobo!),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                        if (!product.isAvailable) ...[
                          const SizedBox(height: PasSpacing.xs),
                          Text(
                            copy.outOfStock,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: colors.error),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PasSpacing.md),
              Divider(height: 1, color: colors.outlineVariant),
              const SizedBox(height: PasSpacing.xs),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.chevron_right),
                  label: Text(copy.productDetails),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
