class LoanLenderIdentity {
  const LoanLenderIdentity({
    this.companyName,
    this.partnerName,
    this.companyRegistration,
    this.partnerRegistration,
    this.registrationStatus,
  });

  final String? companyName;
  final String? partnerName;
  final String? companyRegistration;
  final String? partnerRegistration;
  final String? registrationStatus;
}

class LoanLimitStep {
  const LoanLimitStep({
    required this.label,
    this.amountKobo,
    this.isCurrent = false,
  });

  final String label;
  final int? amountKobo;
  final bool isCurrent;
}

/// Host mapping for GET /loans/eligibility. The published API has no success
/// response schema; absent values must remain absent.
class LoanEligibilitySnapshot {
  const LoanEligibilitySnapshot({
    this.eligible,
    this.statusLabel,
    this.reason,
    this.limitKobo,
    this.canApply = false,
    this.minimumAmountKobo,
    this.maximumAmountKobo,
    this.tenors = const [],
    this.limitSteps = const [],
    this.lender,
  });

  final bool? eligible;
  final String? statusLabel;
  final String? reason;
  final int? limitKobo;
  final bool canApply;
  final int? minimumAmountKobo;
  final int? maximumAmountKobo;
  final List<LoanTenorOption> tenors;
  final List<LoanLimitStep> limitSteps;
  final LoanLenderIdentity? lender;
}

class LoanTenorOption {
  const LoanTenorOption({required this.value, required this.label});

  final int value;
  final String label;
}

class ActiveLoanSummary {
  const ActiveLoanSummary({
    this.status,
    this.balanceKobo,
    this.nextDueLabel,
    this.canOpenDetails = false,
  });

  final String? status;
  final int? balanceKobo;
  final String? nextDueLabel;
  final bool canOpenDetails;
}

/// Host-derived active loan only; null means no active loan per host mapping.
class ActiveLoanSnapshot {
  const ActiveLoanSnapshot({this.activeLoan});

  final ActiveLoanSummary? activeLoan;
}

class LoanQuoteSnapshot {
  const LoanQuoteSnapshot({
    this.quoteId,
    this.interestKobo,
    this.feesKobo,
    this.totalRepaymentKobo,
    this.installments = const [],
    this.effectiveCostLabel,
    this.affordabilityMessage,
    this.affordability,
    this.agreement,
  });

  final String? quoteId;
  final int? interestKobo;
  final int? feesKobo;
  final int? totalRepaymentKobo;
  final List<LoanInstallmentQuote> installments;
  final String? effectiveCostLabel;
  final String? affordabilityMessage;
  final LoanAffordabilitySnapshot? affordability;
  final LoanAgreementSnapshot? agreement;
}

/// Host-mapped comparison values from the documented server quote.
class LoanAffordabilitySnapshot {
  const LoanAffordabilitySnapshot({
    this.repaymentKobo,
    this.typicalMonthlyInflowsKobo,
    this.repaymentFraction,
    this.message,
    this.cautionText,
    this.hasEnoughData = false,
  });

  final int? repaymentKobo;
  final int? typicalMonthlyInflowsKobo;

  /// A server-computed visual proportion; the client does not derive it.
  final double? repaymentFraction;
  final String? message;
  final String? cautionText;
  final bool hasEnoughData;
}

/// Agreement and key-fact values supplied through host context. There is no
/// published success schema for the quote endpoint or separate read endpoint.
class LoanAgreementSnapshot {
  const LoanAgreementSnapshot({
    this.version,
    this.totalRepaymentKobo,
    this.repaymentDateLabels = const [],
    this.lateFeeLabel,
    this.earlyRepaymentLabel,
    this.fullText,
    this.lender,
  });

  final String? version;
  final int? totalRepaymentKobo;
  final List<String> repaymentDateLabels;
  final String? lateFeeLabel;
  final String? earlyRepaymentLabel;
  final String? fullText;
  final LoanLenderIdentity? lender;
}

enum LoanApplicationOutcome { success, pending, declined }

/// Presentation result mapped from the host's documented application response
/// and documented LOAN_DECLINED / LOAN_DISBURSEMENT_PENDING errors.
class LoanApplicationResult {
  const LoanApplicationResult({
    required this.outcome,
    this.amountCreditedKobo,
    this.loanId,
    this.reason,
    this.tryAgainDateLabel,
  });

  final LoanApplicationOutcome outcome;
  final int? amountCreditedKobo;
  final String? loanId;
  final String? reason;
  final String? tryAgainDateLabel;
}

class LoanAgreementOutdated implements Exception {
  const LoanAgreementOutdated();
}

class LoanHostUnavailable implements Exception {
  const LoanHostUnavailable([this.message = 'This action is unavailable.']);

  final String message;
}

class LoanInstallmentQuote {
  const LoanInstallmentQuote({this.amountKobo, this.dueDateLabel});

  final int? amountKobo;
  final String? dueDateLabel;
}

/// Host mapping of GET /loans/{loanId}; the API does not publish a success
/// response schema. Missing fields stay unavailable in the UI.
class LoanDetailSnapshot {
  const LoanDetailSnapshot({
    this.statusLabel,
    this.balanceKobo,
    this.nextDueLabel,
    this.isOverdue,
    this.overdueMessage,
    this.schedule = const [],
    this.receipts = const [],
    this.nextInstallmentKobo,
    this.fullPayoffKobo,
    this.earlyRepaymentSavingsKobo,
    this.autoRepayEnabled,
    this.nextDebitDateLabel,
    this.canRepay = false,
    this.canManageAutoRepay = false,
    this.canRequestHelp = false,
  });

  final String? statusLabel;
  final int? balanceKobo;
  final String? nextDueLabel;
  final bool? isOverdue;
  final String? overdueMessage;
  final List<LoanScheduleItem> schedule;
  final List<LoanReceiptSummary> receipts;
  final int? nextInstallmentKobo;
  final int? fullPayoffKobo;
  final int? earlyRepaymentSavingsKobo;
  final bool? autoRepayEnabled;
  final String? nextDebitDateLabel;
  final bool canRepay;
  final bool canManageAutoRepay;
  final bool canRequestHelp;
}

class LoanScheduleItem {
  const LoanScheduleItem({
    this.amountKobo,
    this.dueDateLabel,
    this.statusLabel,
  });

  final int? amountKobo;
  final String? dueDateLabel;
  final String? statusLabel;
}

class LoanReceiptSummary {
  const LoanReceiptSummary({
    this.title,
    this.dateLabel,
    this.amountKobo,
    this.reference,
  });

  final String? title;
  final String? dateLabel;
  final int? amountKobo;
  final String? reference;
}

enum LoanRepaymentOutcome { success, insufficientFunds, pending, failed }

/// Presentation result mapped by the host; POST /repayments has no 201 schema.
class LoanRepaymentResult {
  const LoanRepaymentResult({
    required this.outcome,
    this.message,
    this.receiptReference,
    this.remainingBalanceKobo,
  });

  final LoanRepaymentOutcome outcome;
  final String? message;
  final String? receiptReference;
  final int? remainingBalanceKobo;
}

/// Host confirmation mapped from PUT /auto-repay; null confirmation is not
/// treated as a saved consent choice.
class LoanAutoRepayResult {
  const LoanAutoRepayResult({required this.enabled});

  final bool? enabled;
}

/// Presentation projection of documented GET /loans. The endpoint's response
/// schema is not published; the host may also map independently owned limit
/// history when that data is available.
class LoanHistorySnapshot {
  const LoanHistorySnapshot({
    this.loans = const [],
    this.limitHistory = const [],
  });

  final List<LoanHistoryItem> loans;
  final List<LoanLimitHistoryItem> limitHistory;
}

class LoanHistoryItem {
  const LoanHistoryItem({
    this.loanId,
    this.statusLabel,
    this.totalRepaymentKobo,
    this.dateLabel,
  });

  final String? loanId;
  final String? statusLabel;
  final int? totalRepaymentKobo;
  final String? dateLabel;
}

class LoanLimitHistoryItem {
  const LoanLimitHistoryItem({this.label, this.amountKobo, this.dateLabel});

  final String? label;
  final int? amountKobo;
  final String? dateLabel;
}

class LoanAboutSnapshot {
  const LoanAboutSnapshot({
    this.lender,
    this.dataUseStatements = const [],
    this.dataNeverAccessedStatements = const [],
    this.complaintRoute,
    this.regulatorName,
    this.regulatorInformation,
  });

  final LoanLenderIdentity? lender;
  final List<String> dataUseStatements;
  final List<String> dataNeverAccessedStatements;
  final String? complaintRoute;
  final String? regulatorName;
  final String? regulatorInformation;
}

/// Result is host-mapped because POST /hardship has no published success
/// response schema. A null value is never interpreted as submitted.
class LoanHardshipResult {
  const LoanHardshipResult({
    this.requestReceived,
    this.reference,
    this.responseTimeLabel,
  });

  final bool? requestReceived;
  final String? reference;
  final String? responseTimeLabel;
}
