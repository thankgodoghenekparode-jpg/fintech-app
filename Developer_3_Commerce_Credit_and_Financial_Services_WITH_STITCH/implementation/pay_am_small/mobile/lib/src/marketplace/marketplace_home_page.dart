// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';
import '../widgets/pas_components.dart';

class MarketplaceHomePage extends StatefulWidget {
  const MarketplaceHomePage({
    required this.adapter,
    required this.copy,
    required this.onOpenProduct,
    required this.onOpenVendor,
    super.key,
  });

  final PayAmSmallBrowseAdapter adapter;
  final PayAmSmallCopy copy;
  final ValueChanged<String> onOpenProduct;
  final ValueChanged<String> onOpenVendor;

  @override
  State<MarketplaceHomePage> createState() => _MarketplaceHomePageState();
}

class _MarketplaceHomePageState extends State<MarketplaceHomePage> {
  final _searchController = TextEditingController();
  late Future<List<PasMarketplaceProduct>> _productsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.adapter.loadMarketplace();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MarketplaceHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adapter != widget.adapter) {
      _productsFuture = widget.adapter.loadMarketplace(
        query: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      );
    }
  }

  void _search() {
    setState(() {
      _selectedCategory = null;
      _productsFuture = widget.adapter.loadMarketplace(
        query: _searchController.text.trim(),
      );
    });
  }

  void _retry() => setState(
        () => _productsFuture = widget.adapter.loadMarketplace(
          query: _searchController.text.trim(),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: PasCenteredPage(
            child: Column(
              children: [
                const PasMarketplaceHeader(),
                Expanded(
                  child: FutureBuilder<List<PasMarketplaceProduct>>(
                    future: _productsFuture,
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
                      final products =
                          snapshot.data ?? const <PasMarketplaceProduct>[];
                      if (products.isEmpty) {
                        return PasEmptyState(copy: widget.copy);
                      }

                      final categories = products
                          .map((product) => product.category)
                          .whereType<String>()
                          .toSet()
                          .toList();
                      final visibleProducts = _selectedCategory == null
                          ? products
                          : products
                              .where((product) =>
                                  product.category == _selectedCategory)
                              .toList();
                      final vendors = <String, PasMarketplaceProduct>{};
                      for (final product in products) {
                        vendors.putIfAbsent(product.vendorId, () => product);
                      }

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(
                          PasSpacing.page,
                          0,
                          PasSpacing.page,
                          PasSpacing.xxl,
                        ),
                        children: [
                          _MarketplaceHero(
                            title: 'Lock prices today, pay bit by bit.',
                            body:
                                'Browse products and review the options and terms supplied by each vendor.',
                            verifiedVendors: vendors.values.any(
                              (product) => product.isVerifiedVendor,
                            ),
                          ),
                          const SizedBox(height: PasSpacing.lg),
                          SizedBox(
                            height: 52,
                            child: TextField(
                              controller: _searchController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _search(),
                              decoration: InputDecoration(
                                hintText: widget.copy.searchHint,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  tooltip: widget.copy.searchLabel,
                                  onPressed: _search,
                                  icon: const Icon(Icons.tune),
                                ),
                              ),
                            ),
                          ),
                          if (categories.isNotEmpty) ...[
                            const SizedBox(height: PasSpacing.lg),
                            SizedBox(
                              height: 44,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _CategoryChip(
                                    label: widget.copy.allCategories,
                                    selected: _selectedCategory == null,
                                    onTap: () => setState(
                                      () => _selectedCategory = null,
                                    ),
                                  ),
                                  for (final category in categories)
                                    _CategoryChip(
                                      label: category,
                                      selected: _selectedCategory == category,
                                      onTap: () => setState(
                                        () => _selectedCategory = category,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: PasSpacing.xl),
                          const PasSectionTitle('Trending Price-Lock Deals'),
                          const SizedBox(height: PasSpacing.md),
                          if (visibleProducts.isEmpty)
                            PasEmptyState(copy: widget.copy)
                          else
                            for (final product in visibleProducts)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: PasSpacing.md,
                                ),
                                child: _FeaturedProductCard(
                                  product: product,
                                  copy: widget.copy,
                                  onTap: () => widget.onOpenProduct(product.id),
                                ),
                              ),
                          if (vendors.isNotEmpty) ...[
                            const SizedBox(height: PasSpacing.lg),
                            const PasSectionTitle('Verified Merchant Stores'),
                            const SizedBox(height: PasSpacing.md),
                            SizedBox(
                              height: 106,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: vendors.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: PasSpacing.sm),
                                itemBuilder: (context, index) {
                                  final entry =
                                      vendors.entries.elementAt(index);
                                  return _FeaturedVendorCard(
                                    product: entry.value,
                                    onTap: () => widget.onOpenVendor(entry.key),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: PasSpacing.xl),
                          _BrowseSteps(copy: widget.copy),
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

class _MarketplaceHero extends StatelessWidget {
  const _MarketplaceHero({
    required this.title,
    required this.body,
    required this.verifiedVendors,
  });

  final String title;
  final String body;
  final bool verifiedVendors;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final heroTextColor = dark ? colors.onPrimaryContainer : colors.onPrimary;
    final heroColors = dark
        ? [colors.primaryContainer, colors.surfaceContainer]
        : [
            colors.primary,
            Color.lerp(colors.primary, colors.onSurface, 0.16)!,
          ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PasSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: heroColors,
        ),
        borderRadius: BorderRadius.circular(PasSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (verifiedVendors)
            DecoratedBox(
              decoration: BoxDecoration(
                color: heroTextColor.withValues(alpha: 0.14),
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
                    Icon(Icons.verified_outlined,
                        size: 14, color: heroTextColor),
                    const SizedBox(width: PasSpacing.xs),
                    Text(
                      'Verified vendors',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: heroTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: PasSpacing.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: heroTextColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: PasSpacing.xs),
          Text(
            body,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: heroTextColor),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  const _FeaturedProductCard({
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
    final showsPriceLock =
        product.availableOptions.contains(PasPurchaseOption.priceLock);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PasSpacing.sm,
                PasSpacing.sm,
                PasSpacing.sm,
                0,
              ),
              child: SizedBox(
                height: 148,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PasSpacing.radiusSm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PasProductImage(image: product.image, height: 148),
                      if (showsPriceLock)
                        Positioned(
                          top: PasSpacing.sm,
                          left: PasSpacing.sm,
                          child: _ImageBadge(
                            icon: Icons.lock_outline,
                            label: copy.priceLock,
                          ),
                        ),
                      if (!product.isAvailable)
                        Positioned(
                          right: PasSpacing.sm,
                          top: PasSpacing.sm,
                          child: _ImageBadge(
                            icon: Icons.info_outline,
                            label: copy.outOfStock,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PasSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        product.isVerifiedVendor
                            ? Icons.verified_outlined
                            : Icons.storefront_outlined,
                        size: 16,
                        color: product.isVerifiedVendor
                            ? colors.primary
                            : colors.onSurfaceVariant,
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
                      if (product.isVerifiedVendor)
                        Text(
                          copy.verifiedVendor,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: colors.primary),
                        ),
                    ],
                  ),
                  if (product.category != null) ...[
                    const SizedBox(height: PasSpacing.xs),
                    Text(
                      product.category!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                  const SizedBox(height: PasSpacing.xs),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (product.priceKobo != null) ...[
                    const SizedBox(height: PasSpacing.sm),
                    Text(
                      formatPasNaira(product.priceKobo!),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: PasSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(copy.productDetails),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedVendorCard extends StatelessWidget {
  const _FeaturedVendorCard({required this.product, required this.onTap});

  final PasMarketplaceProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(PasSpacing.md),
              child: Row(
                children: [
                  PasVendorImage(image: product.vendorImage, radius: 24),
                  const SizedBox(width: PasSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.vendorName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (product.isVerifiedVendor)
                          Text(
                            'Verified vendor',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      );
}

class _BrowseSteps extends StatelessWidget {
  const _BrowseSteps({required this.copy});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How Pay Am Small Works',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: PasSpacing.md),
              for (final step in const [
                ('1', 'Choose a product'),
                ('2', 'Review its available options'),
                ('3', 'Continue to the next step'),
              ]) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: Text(
                        step.$1,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(width: PasSpacing.sm),
                    Expanded(child: Text(step.$2)),
                  ],
                ),
                if (step.$1 != '3') const SizedBox(height: PasSpacing.sm),
              ],
              const SizedBox(height: PasSpacing.md),
              Text(
                'Available actions depend on the product and vendor information provided.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({required this.icon, required this.label});

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
                  size: 14, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: PasSpacing.xs),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: PasSpacing.sm),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
}
