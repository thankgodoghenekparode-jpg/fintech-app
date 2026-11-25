import 'package:flutter/widgets.dart';

/// Host-mapped display data for S-PAS-005. These are not API response DTOs.
class PasPlanListEntry {
  const PasPlanListEntry({
    required this.id,
    required this.group,
    required this.title,
    required this.vendorName,
    required this.status,
    required this.amountSummary,
    required this.progress,
    required this.progressLabel,
    required this.deadlineLabel,
    this.image,
    this.nextPaymentLabel,
    this.nextPaymentDateLabel,
    this.autoDebitLabel,
  });

  final String id;
  final PasPlanGroup group;
  final String title;
  final String vendorName;
  final String status;
  final String amountSummary;

  /// Server supplied fraction from 0 to 1; null omits the progress indicator.
  final double? progress;
  final String progressLabel;
  final String deadlineLabel;
  final ImageProvider? image;
  final String? nextPaymentLabel;
  final String? nextPaymentDateLabel;
  final String? autoDebitLabel;
}

enum PasPlanGroup { vault, credit, completed }

class PasPlanListData {
  const PasPlanListData({
    required this.entries,
    required this.totalValueLabel,
    required this.totalSavedLabel,
    required this.activeVaultCountLabel,
    required this.creditCountLabel,
  });

  final List<PasPlanListEntry> entries;
  final String totalValueLabel;
  final String totalSavedLabel;
  final String activeVaultCountLabel;
  final String creditCountLabel;
}

/// Host-mapped data for GET `/pas/plans`.
abstract interface class PayAmSmallPlansAdapter {
  Future<PasPlanListData> loadPlans();
}

/// A vault item row. Every value is supplied by the host.
class PasVaultItem {
  const PasVaultItem({
    required this.title,
    required this.vendorLabel,
    required this.priceLabel,
    this.image,
    this.quantityLabel,
  });

  final String title;
  final String vendorLabel;
  final String priceLabel;
  final String? quantityLabel;
  final ImageProvider? image;
}

class PasVaultContribution {
  const PasVaultContribution({
    required this.title,
    required this.dateLabel,
    required this.amountLabel,
    required this.statusLabel,
    this.success = false,
  });

  final String title;
  final String dateLabel;
  final String amountLabel;
  final String statusLabel;
  final bool success;
}

class PasVaultAutoDebit {
  const PasVaultAutoDebit({
    required this.enabled,
    required this.title,
    required this.amountLabel,
    required this.nextRunLabel,
    required this.sourceAccountLabel,
    this.sourceAccountMask,
    this.frequencyLabel,
    this.supportingLabel,
  });

  final bool enabled;
  final String title;
  final String amountLabel;
  final String nextRunLabel;
  final String sourceAccountLabel;
  final String? sourceAccountMask;
  final String? frequencyLabel;
  final String? supportingLabel;
}

/// Host-mapped display data for GET `/pas/plans/{planId}`.
class PasVaultDetail {
  const PasVaultDetail({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    required this.progressLabel,
    required this.savedLabel,
    required this.targetLabel,
    required this.deadlineLabel,
    required this.remainingTimeLabel,
    required this.items,
    required this.autoDebit,
    required this.contributions,
    this.remainingLabel,
    this.statusDetail,
    this.fulfillmentLabel,
    this.deadlineDecisionAvailable = false,
  });

  final String id;
  final String title;
  final String status;

  /// Server supplied fraction from 0 to 1; the feature never calculates it.
  final double progress;
  final String progressLabel;
  final String savedLabel;
  final String targetLabel;
  final String deadlineLabel;
  final String remainingTimeLabel;
  final String? remainingLabel;
  final String? statusDetail;
  final List<PasVaultItem> items;
  final PasVaultAutoDebit autoDebit;
  final List<PasVaultContribution> contributions;
  final String? fulfillmentLabel;

  /// Host-gated access from authoritative deadline status; never inferred by
  /// the feature from a locally calculated date or balance.
  final bool deadlineDecisionAvailable;
}

class PasAutoDebitRequest {
  const PasAutoDebitRequest({required this.planId, required this.enabled});

  final String planId;
  final bool enabled;

  /// The only required request-body property in the approved contract.
  Map<String, Object?> toJson() => {'enabled': enabled};
}

/// Host integration seam for the documented GET and PUT plan operations.
abstract interface class PayAmSmallVaultAdapter {
  Future<PasVaultDetail> loadVault(String planId);

  /// Host performs consent/PIN authorization and attaches idempotency headers.
  /// The PUT response schema is undocumented, so no response is assumed.
  Future<void> setAutoDebit(PasAutoDebitRequest request);
}
