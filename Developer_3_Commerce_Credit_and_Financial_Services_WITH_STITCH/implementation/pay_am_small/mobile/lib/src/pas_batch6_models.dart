import 'package:flutter/widgets.dart';

import 'pas_order_models.dart';
import 'pas_vault_models.dart';

/// Display data mapped by the host from GET `/pas/plans/{planId}`.
/// It is intentionally not an API response DTO.
class PasCreditRepaymentContext {
  const PasCreditRepaymentContext({
    required this.planId,
    required this.planLabel,
    required this.vendorLabel,
    required this.outstandingBalanceLabel,
    required this.repaymentLabel,
    required this.repaymentAmountKobo,
    required this.vendorFundedCredit,
    required this.hostEligible,
    required this.legalApprovalEstablished,
    required this.autoDebitAvailable,
    required this.autoDebitEnabled,
    this.nextRepaymentDateLabel,
    this.vendorTermsLabel,
    this.overdueNoticeLabel,
    this.schedule = const [],
    this.image,
  });

  final String planId;
  final String planLabel;
  final String vendorLabel;
  final String outstandingBalanceLabel;
  final String repaymentLabel;

  /// Exact host-provided integer required by POST repayments.amountKobo.
  final int? repaymentAmountKobo;
  final bool vendorFundedCredit;
  final bool hostEligible;
  final bool legalApprovalEstablished;
  final bool autoDebitAvailable;
  final bool autoDebitEnabled;
  final String? nextRepaymentDateLabel;

  /// Host-confirmed terms text; omitted if the plan response does not provide it.
  final String? vendorTermsLabel;

  /// Host-confirmed overdue notice; the feature supplies no fee calculation.
  final String? overdueNoticeLabel;
  final List<PasCreditRepaymentEntry> schedule;
  final ImageProvider? image;

  bool get repaymentAvailable =>
      vendorFundedCredit &&
      hostEligible &&
      legalApprovalEstablished &&
      (repaymentAmountKobo ?? 0) > 0;
  bool get autoDebitControlAvailable =>
      repaymentAvailable && autoDebitAvailable;
}

class PasCreditRepaymentEntry {
  const PasCreditRepaymentEntry({
    required this.label,
    required this.amountLabel,
    required this.statusLabel,
    this.dateLabel,
  });

  final String label;
  final String amountLabel;
  final String statusLabel;
  final String? dateLabel;
}

class PasRepaymentRequest {
  const PasRepaymentRequest({required this.planId, required this.amountKobo});
  final String planId;
  final int amountKobo;
  Map<String, Object?> toJson() => {'amountKobo': amountKobo};
}

abstract interface class PayAmSmallCreditRepaymentAdapter {
  Future<PasCreditRepaymentContext?> loadCredit(String planId);

  /// Host owns PIN authorization and the required Idempotency-Key header.
  Future<void> repay(PasRepaymentRequest request);

  /// Host owns consent/PIN authorization; the documented body is `enabled`.
  Future<void> setAutoDebit(PasAutoDebitRequest request);
}

class PasCreditRepaymentResult {
  const PasCreditRepaymentResult({required this.previewOnly});
  final bool previewOnly;
}

class PasOrderProblemOption {
  const PasOrderProblemOption({required this.value, required this.label});

  /// Host-approved reason string; the API defines no enum.
  final String value;
  final String label;
}

class PasOrderProblemContext {
  const PasOrderProblemContext({required this.order, required this.options});
  final PasOrderTrackingData order;
  final List<PasOrderProblemOption> options;
}

class PasOrderProblemRequest {
  const PasOrderProblemRequest({
    required this.orderId,
    required this.reason,
    required this.description,
  });
  final String orderId;
  final String reason;
  final String description;
  Map<String, Object?> toJson() => {
        'reason': reason,
        'description': description,
      };
}

abstract interface class PayAmSmallOrderProblemAdapter {
  /// Host maps order context and approved reason options; neither report
  /// categories nor a response schema are defined by the API contract.
  Future<PasOrderProblemContext?> loadReportContext(String orderId);
  Future<void> submitReport(PasOrderProblemRequest request);
}

class PasOrderProblemResult {
  const PasOrderProblemResult({required this.previewOnly});
  final bool previewOnly;
}
