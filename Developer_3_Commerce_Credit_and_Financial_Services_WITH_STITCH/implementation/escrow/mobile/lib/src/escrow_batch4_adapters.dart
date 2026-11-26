import 'escrow_batch4_models.dart';

/// The host owns transport, response mapping, authorization and evidence upload.
abstract interface class EscrowOpenDisputeAdapter {
  Future<EscrowOpenDisputeContext?> loadOpenDispute(String dealId);
  Future<EscrowDisputeEvidence?> attachEvidence(String dealId);
  Future<String?> authorizeWithPin(String dealId);
  Future<EscrowDisputeSubmissionOutcome> openDispute({
    required String dealId,
    required String reason,
    required String description,
    required List<String> evidenceReferences,
    required String idempotencyKey,
    required String pinToken,
  });
}

abstract interface class EscrowDisputeStatusAdapter {
  Future<EscrowDisputeStatusContext?> loadDisputeStatus(String dealId);
  Future<String?> authorizeWithPin(String dealId);
  Future<EscrowDisputeSubmissionOutcome> requestAppeal({
    required String dealId,
    required String reason,
    required String idempotencyKey,
    required String pinToken,
  });
}
