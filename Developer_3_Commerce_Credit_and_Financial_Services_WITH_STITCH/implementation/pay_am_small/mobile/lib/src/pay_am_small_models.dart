import 'package:flutter/widgets.dart';

/// Presentation model populated by the host. It is not a wire/API DTO.
class PasMarketplaceProduct {
  const PasMarketplaceProduct({
    required this.id,
    required this.title,
    required this.vendorId,
    required this.vendorName,
    this.category,
    this.priceKobo,
    this.image,
    this.detailImage,
    this.storefrontImage,
    this.vendorImage,
    this.isVerifiedVendor = false,
    this.isAvailable = true,
    this.availableOptions = const {},
  });

  final String id;
  final String title;
  final String vendorId;
  final String vendorName;
  final String? category;
  final int? priceKobo;

  /// Host-mapped presentation image used in marketplace cards.
  final ImageProvider? image;

  /// Optional host-mapped detail image when the catalog image differs.
  final ImageProvider? detailImage;

  /// Optional host-mapped storefront image when the catalog image differs.
  final ImageProvider? storefrontImage;
  final ImageProvider? vendorImage;
  final bool isVerifiedVendor;
  final bool isAvailable;
  final Set<PasPurchaseOption> availableOptions;
}

/// This batch deliberately excludes vendor-funded credit.
enum PasPurchaseOption { payInFull, priceLock }

/// Host-mapped product presentation data. Optional commercial statements are
/// displayed only when the host supplies the corresponding text/value.
class PasProductDetail {
  const PasProductDetail({
    required this.product,
    this.vendorRating,
    this.vendorReviewCount,
    this.deliveryTerms,
    this.priceLockTerms,
  });

  final PasMarketplaceProduct product;
  final double? vendorRating;
  final int? vendorReviewCount;
  final String? deliveryTerms;
  final String? priceLockTerms;
}

/// Host-provided storefront profile. There is no vendor-profile API contract
/// in the approved API specification.
class PasVendorStorefront {
  const PasVendorStorefront({
    required this.id,
    required this.name,
    required this.isVerified,
    required this.isSuspended,
    this.rating,
    this.reviewCount,
    this.about,
    this.deliveryTerms,
    this.image,
    this.products = const [],
  });

  final String id;
  final String name;
  final bool isVerified;
  final bool isSuspended;
  final double? rating;
  final int? reviewCount;
  final String? about;
  final String? deliveryTerms;
  final ImageProvider? image;
  final List<PasMarketplaceProduct> products;
}

/// Feature-facing adapter. Methods exchange presentation models, not a
/// guessed API response schema; the application host owns API/data mapping.
abstract interface class PayAmSmallBrowseAdapter {
  Future<List<PasMarketplaceProduct>> loadMarketplace({String? query});

  Future<PasProductDetail?> loadProduct(String productId);

  Future<PasVendorStorefront?> loadStorefront(String vendorId);
}

enum PasBrowseFailureKind { general, restricted, vendorSuspended }

/// A host may throw this already-mapped presentation failure. It is not an
/// API error envelope and contains no assumptions about response payloads.
class PasBrowseFailure implements Exception {
  const PasBrowseFailure(this.kind);

  final PasBrowseFailureKind kind;
}

String formatPasNaira(int kobo) {
  final naira = kobo ~/ 100;
  final fraction = (kobo % 100).abs().toString().padLeft(2, '0');
  final digits = naira.abs().toString();
  final groups = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = (end - 3).clamp(0, digits.length);
    groups.insert(0, digits.substring(start, end));
  }
  final sign = kobo < 0 ? '-' : '';
  return '$sign₦${groups.join(',')}.$fraction';
}
