import 'package:flutter/widgets.dart';

/// Host-mapped data shown before a top-up. This is not a wire response DTO.
class PasTopUpContext {
  const PasTopUpContext({
    required this.planId,
    required this.title,
    required this.savedLabel,
    required this.targetLabel,
    required this.remainingLabel,
    required this.remainingKobo,
    this.vendorLabel,
    this.image,
    this.progress,
    this.sourceAccountLabel,
  });

  final String planId;
  final String title;
  final String? vendorLabel;
  final String savedLabel;
  final String targetLabel;
  final String remainingLabel;

  /// Host-mapped, server-supplied remaining amount in kobo. Null disables entry.
  final int? remainingKobo;
  final ImageProvider? image;

  /// Server-supplied progress fraction. It is displayed, never calculated.
  final double? progress;
  final String? sourceAccountLabel;
}

class PasTopUpRequest {
  const PasTopUpRequest({required this.planId, required this.amountKobo});

  final String planId;
  final int amountKobo;

  /// The only documented request-body property.
  Map<String, Object?> toJson() => {'amountKobo': amountKobo};
}

enum PasVaultActionDisposition { completed, previewOnly }

class PasVaultActionResult {
  const PasVaultActionResult(this.disposition);

  final PasVaultActionDisposition disposition;
}

enum PasVaultActionFailureKind {
  general,
  insufficientFunds,
  restricted,
  vaultClosed,
  unavailable,
}

/// Error already mapped by the host adapter, not an API error envelope.
class PasVaultActionFailure implements Exception {
  const PasVaultActionFailure(this.kind);

  final PasVaultActionFailureKind kind;
}

/// Injected host adapter for POST `/pas/plans/{planId}/topups`.
abstract interface class PayAmSmallTopUpAdapter {
  Future<PasTopUpContext> loadTopUpContext(String planId);

  /// Host handles PIN authorization and Idempotency-Key / X-Pin-Token headers.
  /// The endpoint has no documented 201 response body.
  Future<PasVaultActionResult> topUp(PasTopUpRequest request);
}

/// Host-provided withdrawal amounts/terms. The feature does not calculate them.
class PasWithdrawalContext {
  const PasWithdrawalContext({
    required this.planId,
    required this.title,
    required this.savedLabel,
    required this.canConfirm,
    this.penaltyLabel,
    this.netLabel,
    this.lockedPriceReminder,
    this.unavailableReason,
  });

  final String planId;
  final String title;
  final String savedLabel;
  final String? penaltyLabel;
  final String? netLabel;
  final String? lockedPriceReminder;

  /// True only when the host has supplied current, confirmable quote terms.
  final bool canConfirm;
  final String? unavailableReason;

  bool get hasConfirmableTerms =>
      canConfirm &&
      penaltyLabel != null &&
      penaltyLabel!.isNotEmpty &&
      netLabel != null &&
      netLabel!.isNotEmpty;
}

class PasWithdrawalRequest {
  const PasWithdrawalRequest({required this.planId, required this.confirm});

  final String planId;
  final bool confirm;

  /// Only the documented `confirm` request field is emitted.
  Map<String, Object?> toJson() => {'confirm': confirm};
}

/// Injected host adapter for the documented withdrawal operation.
///
/// The workspace OpenAPI path is `/withdrawal`; the current batch instruction
/// names `/withdraw`. The host owns resolving this route discrepancy and any
/// quote source. No separate quote endpoint or response schema is assumed.
abstract interface class PayAmSmallWithdrawalAdapter {
  /// Host supplies approved display data; this interface does not specify a
  /// network endpoint or response field names.
  Future<PasWithdrawalContext> loadWithdrawalContext(String planId);

  /// Host handles consent/PIN authorization and idempotency headers.
  /// No withdrawal response body is documented.
  Future<PasVaultActionResult> withdraw(PasWithdrawalRequest request);
}
