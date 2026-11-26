import 'escrow_batch3_models.dart';

/// Transport, auth, authorization and response mapping stay host-owned.
abstract interface class EscrowDealDetailAdapter {
  Future<EscrowDealDetail?> loadDeal(String dealId);
  Future<void> sendMessage({required String dealId, required String body});
  Future<void> openDocument(
      {required String dealId, required String documentId});
}

abstract interface class EscrowDeliveryAdapter {
  Future<EscrowDeliveryContext?> loadDelivery(String dealId);

  /// Host owns file selection, validation, upload and signed-reference mapping.
  Future<EscrowEvidenceItem?> attachEvidence(String dealId);
  Future<String?> authorizeWithPin(String dealId);
  Future<EscrowBatch3Outcome> submitDelivery({
    required String dealId,
    required int? milestoneSequence,
    required List<String> evidenceReferences,
    required String note,
    required String idempotencyKey,
    required String pinToken,
  });
}

enum EscrowConfirmAction { release, revision }

abstract interface class EscrowConfirmationAdapter {
  Future<EscrowConfirmationContext?> loadConfirmation(String dealId);
  Future<void> openEvidence(
      {required String dealId, required String evidenceReference});
  Future<String?> authorizeWithPin(String dealId);
  Future<EscrowBatch3Outcome> submitDecision({
    required String dealId,
    required EscrowConfirmAction action,
    required String? deliveryCode,
    required int? milestoneSequence,
    required String idempotencyKey,
    required String pinToken,
  });
}
