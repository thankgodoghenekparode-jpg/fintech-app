enum EscrowDealAction {
  invite,
  accept,
  fund,
  submitDelivery,
  confirmDelivery,
  openDispute,
  cancelDeal,
  viewReceipt,
  other
}

class EscrowDetailEvent {
  const EscrowDetailEvent({required this.label, this.detail, this.actorLabel});
  final String label;
  final String? detail;
  final String? actorLabel;
}

class EscrowDetailMessage {
  const EscrowDetailMessage({required this.author, required this.body});
  final String author;
  final String body;
}

class EscrowDetailDocument {
  const EscrowDetailDocument(
      {required this.id, required this.label, this.detail});
  final String id;
  final String label;
  final String? detail;
}

/// Host-mapped presentation model; it intentionally is not an API schema.
class EscrowDealDetail {
  const EscrowDealDetail({
    required this.title,
    required this.statusLabel,
    this.heldAmountLabel,
    this.nextActorLabel,
    this.counterpartyLabel,
    this.counterpartyVerificationLabel,
    this.frozenMessage,
    this.deadlineMessage,
    this.events = const [],
    this.messages = const [],
    this.documents = const [],
    this.actions = const [],
    this.canSendMessage = false,
  });
  final String title, statusLabel;
  final String? heldAmountLabel, nextActorLabel, counterpartyLabel;
  final String? counterpartyVerificationLabel, frozenMessage, deadlineMessage;
  final List<EscrowDetailEvent> events;
  final List<EscrowDetailMessage> messages;
  final List<EscrowDetailDocument> documents;
  final List<EscrowDealAction> actions;
  final bool canSendMessage;
}

class EscrowDeliveryMilestone {
  const EscrowDeliveryMilestone({required this.sequence, required this.label});
  final int sequence;
  final String label;
}

class EscrowDeliveryContext {
  const EscrowDeliveryContext({
    required this.title,
    this.instruction,
    this.windowMessage,
    this.deliveryCodeInstructions,
    this.milestones = const [],
    this.milestoneRequired = false,
    this.evidenceRequired = false,
    this.submissionAllowed = false,
    this.evidenceUploadAvailable = false,
  });
  final String title;
  final String? instruction, windowMessage, deliveryCodeInstructions;
  final List<EscrowDeliveryMilestone> milestones;
  final bool milestoneRequired, evidenceRequired, submissionAllowed;
  final bool evidenceUploadAvailable;
}

class EscrowEvidenceItem {
  const EscrowEvidenceItem(
      {required this.reference, required this.label, this.detail});
  final String reference, label;
  final String? detail;
}

class EscrowConfirmationContext {
  const EscrowConfirmationContext({
    required this.title,
    this.instruction,
    this.autoReleaseMessage,
    this.deliveryCodeRequired = false,
    this.milestoneSequence,
    this.canRelease = false,
    this.canRequestRevision = false,
    this.canReportProblem = false,
    this.evidence = const [],
  });
  final String title;
  final String? instruction, autoReleaseMessage;
  final bool deliveryCodeRequired,
      canRelease,
      canRequestRevision,
      canReportProblem;
  final int? milestoneSequence;
  final List<EscrowEvidenceItem> evidence;
}

enum EscrowBatch3Outcome { pending, recorded }
