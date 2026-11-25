import 'escrow_models.dart';

/// Host-injected deal list. Implementations own auth, tenant context and API
/// response mapping; this package defines no wire response schema.
abstract interface class EscrowHomeAdapter {
  Future<List<EscrowDealCardData>> loadDeals();
}

/// Loads host-approved fee options and submits the documented terms intent.
/// There is no fee-quote endpoint in the product API documentation.
abstract interface class EscrowFeeTermsAdapter {
  Future<EscrowFeeTermsPresentation?> loadTerms({
    required String? dealId,
    required EscrowCreateDealDraft draft,
  });

  Future<void> saveTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  });
}

typedef EscrowCreateContinuation = Future<void> Function(
  EscrowCreateDealDraft draft,
);
typedef EscrowTermsContinuation = Future<void> Function(
  EscrowFeeTermsSelection selection,
);
