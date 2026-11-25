enum EscrowDealGroup { active, waitingForMe, completed, disputes }

enum EscrowDealType { goods, service, property, vehicle, other }

enum EscrowPartyRole { buyer, seller }

enum EscrowFeePayer { buyer, seller, split }

extension EscrowDealGroupLabel on EscrowDealGroup {
  String get label => switch (this) {
        EscrowDealGroup.active => 'Active',
        EscrowDealGroup.waitingForMe => 'Waiting for me',
        EscrowDealGroup.completed => 'Completed',
        EscrowDealGroup.disputes => 'Disputes',
      };
}

extension EscrowDealTypeLabel on EscrowDealType {
  String get label => switch (this) {
        EscrowDealType.goods => 'Goods',
        EscrowDealType.service => 'Service / milestones',
        EscrowDealType.property => 'Property / rent',
        EscrowDealType.vehicle => 'Vehicle',
        EscrowDealType.other => 'Other',
      };
}

extension EscrowPartyRoleLabel on EscrowPartyRole {
  String get label => switch (this) {
        EscrowPartyRole.buyer => 'Buyer',
        EscrowPartyRole.seller => 'Seller',
      };
}

extension EscrowFeePayerLabel on EscrowFeePayer {
  String get label => switch (this) {
        EscrowFeePayer.buyer => 'Buyer pays',
        EscrowFeePayer.seller => 'Seller pays',
        EscrowFeePayer.split => 'Split',
      };
}

class EscrowDealCardData {
  const EscrowDealCardData({
    required this.id,
    required this.title,
    required this.group,
    required this.role,
    required this.statusLabel,
    this.amountLabel,
  });

  final String id;
  final String title;
  final EscrowDealGroup group;
  final EscrowPartyRole role;
  final String statusLabel;
  final String? amountLabel;
}

class EscrowMilestoneDraft {
  const EscrowMilestoneDraft({required this.title, required this.amount});

  final String title;
  final String amount;
}

/// UI input model, not an API request/response DTO. The host maps it to the
/// documented request after resolving the open timeline/milestone schemas.
class EscrowCreateDealDraft {
  const EscrowCreateDealDraft({
    required this.type,
    required this.role,
    required this.title,
    required this.description,
    required this.amount,
    required this.timelineDescription,
    required this.milestones,
    this.propertyCheckpoints = const [],
  });

  final EscrowDealType type;
  final EscrowPartyRole role;
  final String title;
  final String description;
  final String amount;
  final String timelineDescription;
  final List<EscrowMilestoneDraft> milestones;
  final List<String> propertyCheckpoints;
}

class EscrowFeeOption {
  const EscrowFeeOption({
    required this.label,
    required this.requestValue,
    this.feeAmountLabel,
  });

  final String label;

  /// Host-mapped value for the API's currently open-ended scenarioOptions.
  final Object requestValue;
  final String? feeAmountLabel;
}

class EscrowFeeScenario {
  const EscrowFeeScenario({
    required this.key,
    required this.label,
    required this.options,
  });

  /// Key and option values are supplied/mapped by the host; no wire schema is
  /// assumed for the API's additionalProperties scenarioOptions object.
  final String key;
  final String label;
  final List<EscrowFeeOption> options;
}

class EscrowFeeTermsPresentation {
  const EscrowFeeTermsPresentation({
    required this.scenarios,
    this.feeSummaryLines = const [],
    this.minimumChargeNote,
    this.plainSummary,
  });

  final List<EscrowFeeScenario> scenarios;
  final List<String> feeSummaryLines;
  final String? minimumChargeNote;
  final String? plainSummary;
}

class EscrowFeeTermsSelection {
  const EscrowFeeTermsSelection({
    required this.payer,
    required this.scenarioOptions,
    this.splitBuyerBps,
    required this.acceptedSummary,
  });

  final EscrowFeePayer payer;
  final int? splitBuyerBps;
  final Map<String, Object> scenarioOptions;
  final bool acceptedSummary;
}

int? parseEscrowAmountToKobo(String input) {
  final value = input.trim().replaceAll(',', '');
  final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(value);
  if (match == null) return null;
  final whole = int.tryParse(match.group(1)!);
  final fraction = int.tryParse((match.group(2) ?? '').padRight(2, '0')) ?? 0;
  if (whole == null) return null;
  return whole * 100 + fraction;
}
