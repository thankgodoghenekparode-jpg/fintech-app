class EscrowCancelReason {
  const EscrowCancelReason({required this.value, required this.label});

  /// The cancellation contract documents a string but no enum.
  final String value;
  final String label;
}

/// Host-mapped presentation data, not a wire response DTO.
class EscrowCancellationContext {
  const EscrowCancellationContext({
    required this.dealTitle,
    this.scenarioLabel,
    this.agreedFeeOutcome,
    this.netRefundLabel,
    this.summary,
    this.reasons = const [],
    this.canRequestCancellation = false,
    this.requiresCounterpartyAgreement = false,
    this.counterpartyAgreementSatisfied = false,
    this.restrictionMessage,
    this.confirmationMessage,
  });

  final String dealTitle;
  final String? scenarioLabel, agreedFeeOutcome, netRefundLabel, summary;
  final List<EscrowCancelReason> reasons;
  final bool canRequestCancellation;
  final bool requiresCounterpartyAgreement, counterpartyAgreementSatisfied;
  final String? restrictionMessage, confirmationMessage;
}

class EscrowReceiptLine {
  const EscrowReceiptLine({required this.label, required this.value});
  final String label, value;
}

class EscrowRatingOption {
  const EscrowRatingOption({required this.value, required this.label});

  /// Rating scale and values are supplied by the host; no scale is assumed.
  final String value;
  final String label;
}

/// Receipt and rating content is mapped by the host. Empty fields are shown as
/// unavailable instead of being replaced with synthetic transaction values.
class EscrowReceiptContext {
  const EscrowReceiptContext({
    required this.dealTitle,
    required this.statusLabel,
    this.counterpartyLabel,
    this.receiptReference,
    this.receiptLines = const [],
    this.ratingOptions = const [],
    this.canShare = false,
    this.canRate = false,
    this.ratingSubmitted = false,
    this.ratingStatusMessage,
    this.unavailableMessage,
  });

  final String dealTitle, statusLabel;
  final String? counterpartyLabel, receiptReference;
  final List<EscrowReceiptLine> receiptLines;
  final List<EscrowRatingOption> ratingOptions;
  final bool canShare, canRate, ratingSubmitted;
  final String? ratingStatusMessage, unavailableMessage;
}

enum EscrowBatch5Outcome { pending, recorded }
