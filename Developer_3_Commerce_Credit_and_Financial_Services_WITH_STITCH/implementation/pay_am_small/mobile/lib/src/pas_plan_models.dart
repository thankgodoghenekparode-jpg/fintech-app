/// Plan quote request and host-mapped display models for Pay Am Small.
///
/// These are feature presentation models, not API response DTOs. The approved
/// OpenAPI document does not define a success schema for `/pas/plans/quote`.
class PasPlanQuoteRequest {
  const PasPlanQuoteRequest({
    required this.productIds,
    this.deadline,
  });

  final List<String> productIds;
  final DateTime? deadline;

  /// Only emits fields described by the approved quote request contract.
  Map<String, Object?> toJson() => {
        'productIds': productIds,
        'mode': 'PRICE_LOCK',
        if (deadline != null) 'deadline': _dateOnly(deadline!),
      };
}

String _dateOnly(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Text already mapped and supplied by the quote service through the host.
/// Values are rendered verbatim; the feature does not calculate or format them.
class PasPlanQuoteFact {
  const PasPlanQuoteFact({
    required this.label,
    required this.value,
    this.supportingText,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final String? supportingText;
  final bool emphasized;
}

/// A host-mapped section of the quote's full terms.
class PasPlanTermSection {
  const PasPlanTermSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

/// Host-mapped quote data. The host must map the actual API response into this
/// view model after the backend publishes its missing response schema.
class PasPlanQuote {
  const PasPlanQuote({
    required this.quoteId,
    required this.termsVersion,
    required this.facts,
    required this.terms,
  });

  /// Used by the documented POST `/pas/plans` request.
  final String quoteId;

  /// Used by the documented POST `/pas/plans` request.
  final String termsVersion;

  /// Ordered, server-supplied facts; the host may emphasize the target total.
  final List<PasPlanQuoteFact> facts;

  /// Complete server-supplied terms that the customer must be able to review.
  final List<PasPlanTermSection> terms;
}

class PasPlanCreateRequest {
  const PasPlanCreateRequest({
    required this.quoteId,
    required this.termsVersion,
  });

  final String quoteId;
  final String termsVersion;

  /// Only emits the two documented request-body fields.
  Map<String, Object?> toJson() => {
        'quoteId': quoteId,
        'termsVersion': termsVersion,
      };
}

enum PasPlanFailureKind {
  general,
  invalidDeadline,
  vendorUnavailable,
  restricted,
  termsChanged,
}

/// Failure already interpreted by the host adapter; this is not an API error
/// envelope and does not prescribe server error codes.
class PasPlanFailure implements Exception {
  const PasPlanFailure(this.kind);

  final PasPlanFailureKind kind;
}

enum PasPlanCreationDisposition { created, previewOnly }

class PasPlanCreationResult {
  const PasPlanCreationResult(this.disposition);

  final PasPlanCreationDisposition disposition;
}

/// Host integration seam for the documented plan endpoints.
abstract interface class PayAmSmallPlanAdapter {
  /// Maps to POST `/pas/plans/quote` using only [PasPlanQuoteRequest.toJson].
  Future<PasPlanQuote> quotePlan(PasPlanQuoteRequest request);

  /// The host must complete its PIN authorization, then call POST `/pas/plans`
  /// with `quoteId` and `termsVersion`, plus the required idempotency and PIN
  /// headers. The endpoint currently documents no success response body.
  Future<PasPlanCreationResult> createPlan(PasPlanCreateRequest request);
}
