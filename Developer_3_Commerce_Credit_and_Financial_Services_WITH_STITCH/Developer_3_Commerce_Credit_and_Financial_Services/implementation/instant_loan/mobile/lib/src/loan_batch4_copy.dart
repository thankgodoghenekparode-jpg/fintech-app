/// Localized copy supplied by the host's central text layer.
///
/// English keys are contributed in implementation/localization. This feature
/// package does not create a second localization runtime.
class InstantLoanBatch4Copy {
  const InstantLoanBatch4Copy({
    required this.hardship,
    required this.history,
    required this.about,
  });

  final LoanHardshipCopy hardship;
  final LoanHistoryCopy history;
  final LoanAboutCopy about;
}

class LoanHardshipCopy {
  const LoanHardshipCopy({
    required this.title,
    required this.loadingTitle,
    required this.loadingBody,
    required this.loadErrorTitle,
    required this.loadErrorBody,
    required this.retry,
    required this.unavailableTitle,
    required this.unavailableBody,
    required this.reason,
    required this.reasonHint,
    required this.reasonOptionsUnavailable,
    required this.reasonRequired,
    required this.message,
    required this.messageHint,
    required this.messageRequired,
    required this.reasonLength,
    required this.attachmentsUnavailable,
    required this.responseTime,
    required this.submit,
    required this.submitting,
    required this.notConfirmedTitle,
    required this.notConfirmedBody,
    required this.receivedTitle,
    required this.receivedBody,
    required this.beingConfirmedTitle,
    required this.beingConfirmedBody,
  });

  final String title;
  final String loadingTitle;
  final String loadingBody;
  final String loadErrorTitle;
  final String loadErrorBody;
  final String retry;
  final String unavailableTitle;
  final String unavailableBody;
  final String reason;
  final String reasonHint;
  final String reasonOptionsUnavailable;
  final String reasonRequired;
  final String message;
  final String messageHint;
  final String messageRequired;
  final String reasonLength;
  final String attachmentsUnavailable;
  final String Function(String time) responseTime;
  final String submit;
  final String submitting;
  final String notConfirmedTitle;
  final String notConfirmedBody;
  final String receivedTitle;
  final String receivedBody;
  final String beingConfirmedTitle;
  final String beingConfirmedBody;
}

class LoanHistoryCopy {
  const LoanHistoryCopy({
    required this.title,
    required this.loadingTitle,
    required this.loadingBody,
    required this.loadErrorTitle,
    required this.loadErrorBody,
    required this.retry,
    required this.unavailableTitle,
    required this.unavailableBody,
    required this.emptyTitle,
    required this.emptyBody,
    required this.loan,
    required this.status,
    required this.totalRepayment,
    required this.openLoan,
    required this.limitHistory,
    required this.limitHistoryUnavailable,
    required this.amountUnavailable,
  });

  final String title;
  final String loadingTitle;
  final String loadingBody;
  final String loadErrorTitle;
  final String loadErrorBody;
  final String retry;
  final String unavailableTitle;
  final String unavailableBody;
  final String emptyTitle;
  final String emptyBody;
  final String loan;
  final String status;
  final String totalRepayment;
  final String openLoan;
  final String limitHistory;
  final String limitHistoryUnavailable;
  final String amountUnavailable;
}

class LoanAboutCopy {
  const LoanAboutCopy({
    required this.title,
    required this.loadingTitle,
    required this.loadingBody,
    required this.loadErrorTitle,
    required this.loadErrorBody,
    required this.retry,
    required this.unavailableTitle,
    required this.unavailableBody,
    required this.lender,
    required this.lenderCompany,
    required this.lendingPartner,
    required this.companyRegistration,
    required this.partnerRegistration,
    required this.registrationStatus,
    required this.notProvided,
    required this.dataUseTitle,
    required this.dataUseBody,
    required this.dataNeverAccessedTitle,
    required this.dataNeverAccessedBody,
    required this.complaintsTitle,
    required this.regulatorTitle,
    required this.contactSupport,
    required this.supportUnavailable,
  });

  final String title;
  final String loadingTitle;
  final String loadingBody;
  final String loadErrorTitle;
  final String loadErrorBody;
  final String retry;
  final String unavailableTitle;
  final String unavailableBody;
  final String lender;
  final String lenderCompany;
  final String lendingPartner;
  final String companyRegistration;
  final String partnerRegistration;
  final String registrationStatus;
  final String notProvided;
  final String dataUseTitle;
  final String dataUseBody;
  final String dataNeverAccessedTitle;
  final String dataNeverAccessedBody;
  final String complaintsTitle;
  final String regulatorTitle;
  final String contactSupport;
  final String supportUnavailable;
}
