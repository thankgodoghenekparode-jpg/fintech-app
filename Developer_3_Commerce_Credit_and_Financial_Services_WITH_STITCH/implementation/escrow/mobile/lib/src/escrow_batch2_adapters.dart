import 'escrow_batch2_models.dart';
import 'escrow_models.dart';

/// Host adapters own authentication, tenant context, request/response mapping,
/// authorization and any transport-specific handling.
abstract interface class EscrowInviteAdapter {
  Future<EscrowInvitePresentation?> loadInvite(String dealId);

  /// Maps only the documented phone/channel properties. The channel value is
  /// host supplied because the API contract does not define its enum.
  Future<void> sendInvite({
    required String dealId,
    required String phone,
    required String channel,
  });

  /// Uses PUT /escrow/deals/{dealId}/terms with the documented fee terms.
  Future<void> proposeTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  });
}

abstract interface class EscrowAcceptAdapter {
  Future<EscrowLockedTermsPresentation?> loadLockedTerms(String dealId);

  /// Opens the host-supplied terms document for this locked snapshot.
  Future<void> openTermsDocument({
    required String dealId,
    required String termsHash,
  });

  /// Host controls the PIN UI and returns the authorization token. The feature
  /// never collects, stores or fabricates a PIN token.
  Future<String?> authorizeWithPin(String dealId);

  /// Host maps the documented termsHash and attaches Idempotency-Key and
  /// X-Pin-Token. The same key must be reused for retries of this attempt.
  Future<EscrowAcceptOutcome> acceptLockedTerms({
    required String dealId,
    required String termsHash,
    required String idempotencyKey,
    required String pinToken,
  });
}

abstract interface class EscrowFundingAdapter {
  Future<EscrowFundingPresentation?> loadFunding(String dealId);

  Future<String?> authorizeWithPin(String dealId);

  /// Host maps the documented bodyless fund operation and attaches
  /// Idempotency-Key and X-Pin-Token. `methodId` is a host-only action selector;
  /// the current OpenAPI contract does not define a funding-method request.
  Future<EscrowFundingOutcome> fund({
    required String dealId,
    required String methodId,
    required String idempotencyKey,
    required String pinToken,
  });
}
