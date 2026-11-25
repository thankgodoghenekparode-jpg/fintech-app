/// Host-mapped display data for the S-PAS-009 deadline decision.
/// It is not a wire response DTO; the API has no documented response schema.
class PasDeadlineDecisionOption {
  const PasDeadlineDecisionOption({
    required this.available,
    this.consequence,
    this.feeLabel,
    this.newDeadlineLabel,
    this.refundNetLabel,
    this.unavailableReason,
  });

  final bool available;
  final String? consequence;
  final String? feeLabel;
  final String? newDeadlineLabel;
  final String? refundNetLabel;
  final String? unavailableReason;

  bool canConfirm(PasDeadlineDecision decision) {
    if (!available) return false;
    if (decision == PasDeadlineDecision.extend) {
      return _has(feeLabel) && _has(newDeadlineLabel) && _has(consequence);
    }
    return _has(refundNetLabel) && _has(consequence);
  }

  static bool _has(String? value) => value != null && value.trim().isNotEmpty;
}

class PasDeadlineDecisionContext {
  const PasDeadlineDecisionContext({
    required this.planId,
    required this.title,
    required this.statusLabel,
    required this.savedLabel,
    required this.deadlineLabel,
    required this.extend,
    required this.refund,
    this.additionalNotice,
  });

  final String planId;
  final String title;
  final String statusLabel;
  final String savedLabel;
  final String deadlineLabel;
  final PasDeadlineDecisionOption extend;
  final PasDeadlineDecisionOption refund;
  final String? additionalNotice;

  PasDeadlineDecisionOption option(PasDeadlineDecision decision) =>
      decision == PasDeadlineDecision.extend ? extend : refund;
}

enum PasDeadlineDecision { extend, refund }

extension PasDeadlineDecisionWireValue on PasDeadlineDecision {
  String get value => this == PasDeadlineDecision.extend ? 'EXTEND' : 'REFUND';
}

class PasDeadlineDecisionRequest {
  const PasDeadlineDecisionRequest({
    required this.planId,
    required this.decision,
  });

  final String planId;
  final PasDeadlineDecision decision;

  /// The only documented request body property.
  Map<String, Object?> toJson() => {'decision': decision.value};
}

class PasDeadlineDecisionResult {
  const PasDeadlineDecisionResult({required this.previewOnly});

  final bool previewOnly;
}

/// Host integration seam for POST `/pas/plans/{planId}/deadline-decision`.
/// The supplied success response has no schema. The host owns PIN and
/// Idempotency-Key / X-Pin-Token handling.
abstract interface class PayAmSmallDeadlineDecisionAdapter {
  Future<PasDeadlineDecisionContext> loadDeadlineContext(String planId);

  Future<PasDeadlineDecisionResult> decide(
    PasDeadlineDecisionRequest request,
  );
}
