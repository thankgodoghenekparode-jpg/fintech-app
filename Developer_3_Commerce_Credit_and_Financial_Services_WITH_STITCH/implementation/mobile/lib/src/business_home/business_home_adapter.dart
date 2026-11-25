import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-facing view data for S-MER-001. This is not an API wire schema.
///
/// The host adapter must map an approved response contract into this model.
/// No fields are inferred from the currently undocumented `/business/home`
/// response.
class MerchantHomeSnapshot {
  const MerchantHomeSnapshot({
    required this.businessName,
    required this.isVerified,
    required this.isRestricted,
    required this.availableBalanceKobo,
    required this.todaySalesKobo,
    required this.recentPayments,
  });

  final String businessName;
  final bool isVerified;
  final bool isRestricted;
  final int availableBalanceKobo;
  final int todaySalesKobo;
  final List<MerchantPaymentSummary> recentPayments;
}

class MerchantPaymentSummary {
  const MerchantPaymentSummary({
    required this.counterparty,
    required this.channel,
    required this.amountKobo,
    required this.occurredAt,
    required this.status,
  });

  final String counterparty;
  final MerchantPaymentChannel channel;
  final int amountKobo;
  final DateTime occurredAt;
  final MerchantPaymentStatus status;
}

enum MerchantPaymentChannel { qr, paymentLink, bankTransfer }

enum MerchantPaymentStatus { settled, pending, failed }

abstract interface class MerchantHomeDataAdapter {
  /// Loads the already-selected tenant's view data.
  ///
  /// Returning `null` means the host has no business to show. Implementations
  /// must not fabricate financial values. Network and auth behavior belong to
  /// the shared host adapter, not this feature package.
  Future<MerchantHomeSnapshot?> loadHome({required String tenantId});
}

/// Adapter signal for a known connectivity failure. Stale financial data is
/// never substituted by the feature package.
class MerchantHomeOfflineException implements Exception {
  const MerchantHomeOfflineException();
}

final merchantHomeDataAdapterProvider = Provider<MerchantHomeDataAdapter>(
  (ref) => throw StateError(
    'The host application must inject a MerchantHomeDataAdapter.',
  ),
);

final merchantHomeSnapshotProvider = FutureProvider.autoDispose
    .family<MerchantHomeSnapshot?, String>(
      (ref, tenantId) => ref
          .watch(merchantHomeDataAdapterProvider)
          .loadHome(tenantId: tenantId),
    );
