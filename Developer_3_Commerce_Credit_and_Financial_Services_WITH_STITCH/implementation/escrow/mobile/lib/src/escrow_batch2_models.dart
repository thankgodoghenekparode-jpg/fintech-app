import 'escrow_models.dart';

enum EscrowFundingMethodKind { wallet, bankTransfer, other }

enum EscrowAcceptOutcome { accepted, waitingForOtherParty, termsChanged }

enum EscrowFundingOutcome { pending, funded, failed }

class EscrowNegotiationMessage {
  const EscrowNegotiationMessage({
    required this.authorLabel,
    required this.message,
    this.changedTerms = false,
  });

  final String authorLabel;
  final String message;
  final bool changedTerms;
}

/// Host-mapped presentation data, not the invite API response schema.
class EscrowInvitePresentation {
  const EscrowInvitePresentation({
    required this.dealTitle,
    required this.inviteeRoleLabel,
    required this.channels,
    this.shareLink,
    this.counterpartyStatus,
    this.messages = const [],
    this.updatedTerms = const [],
    this.proposedTermsSummary = const [],
    this.invitationPending = false,
    this.canProposeTerms = false,
    this.proposedTermsSelection,
  });

  final String dealTitle;
  final String inviteeRoleLabel;
  final List<EscrowInviteChannel> channels;
  final String? shareLink;
  final String? counterpartyStatus;
  final List<EscrowNegotiationMessage> messages;
  final List<String> updatedTerms;
  final List<String> proposedTermsSummary;
  final bool invitationPending;
  final bool canProposeTerms;
  final EscrowFeeTermsSelection? proposedTermsSelection;
}

/// Values and display names must be supplied by the host. The API only
/// documents a string `channel`, not its allowed values.
class EscrowInviteChannel {
  const EscrowInviteChannel({required this.value, required this.label});

  final String value;
  final String label;
}

class EscrowLockedTermLine {
  const EscrowLockedTermLine({required this.label, required this.value});

  final String label;
  final String value;
}

/// Locked terms, their hash, and acceptance state are server-supplied.
class EscrowLockedTermsPresentation {
  const EscrowLockedTermsPresentation({
    required this.dealTitle,
    required this.termsHash,
    required this.lines,
    required this.otherPartyAcceptance,
    this.termsLinkLabel,
    this.termsChanged = false,
    this.acceptanceAllowed = true,
    this.canProceedToFunding = false,
  });

  final String dealTitle;
  final String termsHash;
  final List<EscrowLockedTermLine> lines;
  final String otherPartyAcceptance;
  final String? termsLinkLabel;
  final bool termsChanged;
  final bool acceptanceAllowed;
  final bool canProceedToFunding;
}

class EscrowFundingMethod {
  const EscrowFundingMethod({
    required this.id,
    required this.kind,
    required this.label,
    this.detail,
  });

  /// Host-only action identifier. It is not an assumed API field.
  final String id;
  final EscrowFundingMethodKind kind;
  final String label;
  final String? detail;
}

class EscrowFundingPresentation {
  const EscrowFundingPresentation({
    required this.dealTitle,
    required this.amountLabel,
    required this.feeLines,
    required this.totalLabel,
    required this.methods,
    this.transferAccountName,
    this.transferAccountNumber,
    this.transferBankName,
    this.statusMessage,
    this.fundingPending = false,
    this.fundingConfirmed = false,
    this.fundingAllowed = false,
  });

  final String dealTitle;
  final String amountLabel;
  final List<EscrowLockedTermLine> feeLines;
  final String totalLabel;
  final List<EscrowFundingMethod> methods;
  final String? transferAccountName;
  final String? transferAccountNumber;
  final String? transferBankName;
  final String? statusMessage;
  final bool fundingPending;
  final bool fundingConfirmed;
  final bool fundingAllowed;
}
