class EscrowDisputeReason {
  const EscrowDisputeReason({required this.value, required this.label});

  /// Value and label are supplied by the host; the product docs define no list.
  final String value;
  final String label;
}

class EscrowDisputeEvidence {
  const EscrowDisputeEvidence(
      {required this.reference, required this.label, this.detail});
  final String reference;
  final String label;
  final String? detail;
}

/// Host-mapped presentation data, not an API request or response DTO.
class EscrowOpenDisputeContext {
  const EscrowOpenDisputeContext({
    required this.dealTitle,
    this.dealSummary,
    this.reasons = const [],
    this.whatHappensNext,
    this.deadlineMessage,
    this.restrictionMessage,
    this.canOpenDispute = false,
    this.evidenceUploadAvailable = false,
    this.evidenceRequired = false,
  });
  final String dealTitle;
  final String? dealSummary,
      whatHappensNext,
      deadlineMessage,
      restrictionMessage;
  final List<EscrowDisputeReason> reasons;
  final bool canOpenDispute, evidenceUploadAvailable, evidenceRequired;
}

class EscrowDisputeEvent {
  const EscrowDisputeEvent(
      {required this.label,
      this.detail,
      this.dateLabel,
      this.complete = false});
  final String label;
  final String? detail, dateLabel;
  final bool complete;
}

class EscrowDisputeSubmission {
  const EscrowDisputeSubmission(
      {required this.label, this.detail, this.visibleToCurrentUser = true});
  final String label;
  final String? detail;
  final bool visibleToCurrentUser;
}

class EscrowDisputeStatusContext {
  const EscrowDisputeStatusContext({
    required this.caseLabel,
    required this.statusLabel,
    this.dealTitle,
    this.summary,
    this.events = const [],
    this.submissions = const [],
    this.rationale,
    this.responsiblePartyLabel,
    this.deadlineMessage,
    this.appealRestrictionMessage,
    this.appealAllowed = false,
  });
  final String caseLabel, statusLabel;
  final String? dealTitle, summary, rationale, responsiblePartyLabel;
  final String? deadlineMessage, appealRestrictionMessage;
  final List<EscrowDisputeEvent> events;
  final List<EscrowDisputeSubmission> submissions;
  final bool appealAllowed;
}

enum EscrowDisputeSubmissionOutcome { pending, recorded }
