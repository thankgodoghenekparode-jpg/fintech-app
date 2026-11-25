// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';

import '../pay_am_small_copy.dart';
import '../pay_am_small_models.dart';

abstract final class PasSpacing {
  static const page = 16.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
}

/// Centers feature content to the same mobile-first width used by Stitch.
class PasCenteredPage extends StatelessWidget {
  const PasCenteredPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SizedBox(width: double.infinity, child: child),
        ),
      );
}

class PasMarketplaceHeader extends StatelessWidget {
  const PasMarketplaceHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          PasSpacing.page,
          PasSpacing.sm,
          PasSpacing.page,
          PasSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay Am Small',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'Marketplace & Price-Lock',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      );
}

class PasPageHeader extends StatelessWidget {
  const PasPageHeader({
    required this.title,
    this.subtitle,
    this.onBack,
    this.showDefaultAction = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showDefaultAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PasSpacing.page,
        8,
        PasSpacing.page,
        12,
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back),
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
            )
          else
            const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (showDefaultAction) ...[
            Icon(Icons.shopping_bag_outlined, color: colors.primary),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class PasPreviewNotice extends StatelessWidget {
  const PasPreviewNotice({required this.copy, super.key});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      label: copy.nonProductionNotice,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        color: colors.primaryContainer,
        child: Text(
          copy.nonProductionNotice,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class PasSectionTitle extends StatelessWidget {
  const PasSectionTitle(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class PasProductImage extends StatelessWidget {
  const PasProductImage({
    this.image,
    this.height = 160,
    this.fit = BoxFit.cover,
    super.key,
  });

  final ImageProvider? image;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(PasSpacing.radiusMd),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: image == null
            ? ColoredBox(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 44,
                    color: colors.primary,
                  ),
                ),
              )
            : Image(
                image: image!,
                fit: fit,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _productImageFallback(context),
                errorBuilder: (context, error, stack) => ColoredBox(
                  color: colors.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class PasVendorImage extends StatelessWidget {
  const PasVendorImage({this.image, this.radius = 28, super.key});

  final ImageProvider? image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = radius * 2;
    Widget fallback() => ColoredBox(
          color: colors.primaryContainer,
          child: Center(
            child: Icon(
              Icons.storefront_outlined,
              color: colors.onPrimaryContainer,
              size: radius,
            ),
          ),
        );

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: image == null
            ? fallback()
            : Image(
                image: image!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : fallback(),
                errorBuilder: (context, error, stack) => fallback(),
              ),
      ),
    );
  }
}

Widget _productImageFallback(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return ColoredBox(
    color: colors.surfaceContainerHighest,
    child: Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: 44,
        color: colors.primary,
      ),
    ),
  );
}

class PasProductCard extends StatelessWidget {
  const PasProductCard({
    required this.product,
    required this.copy,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final PasMarketplaceProduct product;
  final PayAmSmallCopy copy;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PasSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasProductImage(image: product.image, height: compact ? 80 : 148),
              SizedBox(height: compact ? PasSpacing.sm : PasSpacing.md),
              if (!compact && product.category != null)
                Text(
                  product.category!,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              if (!compact) const SizedBox(height: PasSpacing.xs),
              Text(
                product.title,
                maxLines: compact ? 3 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (!compact) const SizedBox(height: PasSpacing.xs),
              if (!compact)
                Text(
                  product.vendorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              if (!compact && product.isVerifiedVendor) ...[
                const SizedBox(height: PasSpacing.sm),
                _VerifiedBadge(label: copy.verifiedVendor),
              ],
              SizedBox(height: compact ? PasSpacing.xs : PasSpacing.sm),
              if (product.priceKobo != null)
                Text(
                  formatPasNaira(product.priceKobo!),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              if (!product.isAvailable) ...[
                const SizedBox(height: PasSpacing.sm),
                Text(
                  copy.outOfStock,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: colors.error),
                ),
              ] else if (!compact && product.availableOptions.isNotEmpty) ...[
                const SizedBox(height: PasSpacing.sm),
                Wrap(
                  spacing: PasSpacing.sm,
                  runSpacing: PasSpacing.sm,
                  children: product.availableOptions
                      .map(
                        (option) => _OptionBadge(
                          label: option == PasPurchaseOption.priceLock
                              ? copy.priceLock
                              : copy.payInFull,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PasVendorBadge extends StatelessWidget {
  const PasVendorBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => _VerifiedBadge(label: label);
}

class PasAsyncState extends StatelessWidget {
  const PasAsyncState({
    required this.copy,
    required this.onRetry,
    this.failure,
    this.notFound = false,
    super.key,
  });

  final PayAmSmallCopy copy;
  final VoidCallback onRetry;
  final Object? failure;
  final bool notFound;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final kind = failure is PasBrowseFailure
        ? (failure! as PasBrowseFailure).kind
        : null;
    final isSuspended = kind == PasBrowseFailureKind.vendorSuspended;
    final isRestricted = kind == PasBrowseFailureKind.restricted;
    final title = notFound
        ? copy.notFoundTitle
        : isSuspended
            ? copy.suspendedTitle
            : isRestricted
                ? copy.restrictedTitle
                : copy.errorTitle;
    final body = isSuspended
        ? copy.suspendedBody
        : isRestricted
            ? copy.restrictedBody
            : copy.errorBody;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PasSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuspended ? Icons.store_outlined : Icons.info_outline,
              size: 40,
              color: colors.primary,
            ),
            const SizedBox(height: PasSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (!notFound) ...[
              const SizedBox(height: PasSpacing.sm),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (!notFound && !isSuspended && !isRestricted) ...[
              const SizedBox(height: PasSpacing.lg),
              FilledButton(onPressed: onRetry, child: Text(copy.retry)),
            ],
          ],
        ),
      ),
    );
  }
}

class PasLoadingState extends StatelessWidget {
  const PasLoadingState({required this.copy, super.key});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: PasSpacing.md),
            Text(copy.loading, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
}

class PasEmptyState extends StatelessWidget {
  const PasEmptyState({required this.copy, super.key});

  final PayAmSmallCopy copy;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: PasSpacing.xxl,
          horizontal: PasSpacing.xl,
        ),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: PasSpacing.md),
            Text(copy.emptyTitle,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PasSpacing.xs),
            Text(copy.emptyBody, textAlign: TextAlign.center),
          ],
        ),
      );
}

class PasPrimaryButton extends StatelessWidget {
  const PasPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(onPressed: onPressed, child: Text(label)),
      );
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 14,
              color: colors.onSecondaryContainer,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colors.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionBadge extends StatelessWidget {
  const _OptionBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
      );
}
