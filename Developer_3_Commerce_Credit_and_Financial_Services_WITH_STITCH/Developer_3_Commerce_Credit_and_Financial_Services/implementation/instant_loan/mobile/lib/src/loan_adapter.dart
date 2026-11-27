import 'loan_models.dart';

/// Host-owned Instant Loan reads and server-calculated quote boundary.
abstract interface class InstantLoanAdapter {
  /// Maps documented GET /loans/eligibility and its unspecified response body.
  Future<LoanEligibilitySnapshot?> loadEligibility();

  /// Maps documented GET /loans to the relevant host-authorized active loan.
  Future<ActiveLoanSnapshot?> loadActiveLoan();

  /// Calls POST /loans/quote. All pricing and repayment values are server-made.
  Future<LoanQuoteSnapshot?> quoteLoan({
    required int amountKobo,
    required int tenor,
  });

  /// Documented POST /loans/applications. The host performs PIN authorization,
  /// supplies Idempotency-Key and X-Pin-Token, and maps the unspecified 201
  /// response or documented pending/declined errors. No success is inferred.
  Future<LoanApplicationResult?> submitApplication({
    required String quoteId,
    required String agreementVersion,
  });

  /// Maps documented GET /loans/{loanId}; the response schema is unspecified.
  Future<LoanDetailSnapshot?> loadLoanDetail({required String loanId});

  /// Calls documented POST /loans/{loanId}/repayments. Host owns PIN entry,
  /// Idempotency-Key, X-Pin-Token and response/error mapping.
  Future<LoanRepaymentResult?> repayLoan({
    required String loanId,
    required int amountKobo,
  });

  /// Calls documented PUT /loans/{loanId}/auto-repay. Host owns consent
  /// authorization, Idempotency-Key, X-Pin-Token and response mapping.
  Future<LoanAutoRepayResult?> setAutoRepay({
    required String loanId,
    required bool enabled,
  });

  /// Calls documented POST /loans/{loanId}/hardship. The host supplies the
  /// reason options from approved configuration and maps the unspecified 201.
  Future<LoanHardshipResult?> submitHardship({
    required String loanId,
    required String reason,
    required String message,
  });

  /// Maps documented GET /loans; this endpoint has no published success
  /// response schema. Limit-history mapping is host-owned where available.
  Future<LoanHistorySnapshot?> loadLoanHistory();

  /// Maps lender and privacy/complaint information from host-approved
  /// configuration and the documented eligibility response. No new endpoint.
  Future<LoanAboutSnapshot?> loadLoanAbout();
}
