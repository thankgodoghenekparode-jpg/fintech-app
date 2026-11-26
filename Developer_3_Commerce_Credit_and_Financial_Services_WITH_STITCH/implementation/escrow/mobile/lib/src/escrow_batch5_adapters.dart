import 'escrow_batch5_models.dart';

/// Host owns API transport, auth, eligibility and response mapping.
abstract interface class EscrowCancellationAdapter {
  Future<EscrowCancellationContext?> loadCancellation(String dealId);
  Future<String?> authorizeWithPin(String dealId);

  /// Maps only the documented `reason` field; adds idempotency and PIN headers.
  Future<EscrowBatch5Outcome> requestCancellation({
    required String dealId,
    required String reason,
    required String idempotencyKey,
    required String pinToken,
  });
}

/// Receipt and rating are host-provided. No receipt/rating API is documented.
abstract interface class EscrowReceiptAdapter {
  Future<EscrowReceiptContext?> loadReceipt(String dealId);
  Future<void> shareReceipt({required String dealId});
  Future<EscrowBatch5Outcome> submitRating({
    required String dealId,
    required String ratingValue,
  });
}
