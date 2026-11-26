/// UI-facing host-mapped values. These are not wire response schemas.
/// Amounts remain integer kobo; the feature never derives financial values.
class InsightsMonth {
  const InsightsMonth({
    required this.monthKey,
    required this.monthLabel,
    required this.personalisedConsent,
    required this.hasEnoughData,
    this.incomeKobo,
    this.spendKobo,
    this.categories = const [],
    this.topMerchants = const [],
    this.tip,
    this.highlights = const [],
    this.comparisonText,
    this.savingsOpportunity,
    this.availableMonths = const [],
  });

  final String monthKey;
  final String monthLabel;
  final bool personalisedConsent;
  final bool hasEnoughData;
  final int? incomeKobo;
  final int? spendKobo;
  final List<InsightCategory> categories;
  final List<InsightMerchant> topMerchants;
  final String? tip;
  final List<String> highlights;
  final String? comparisonText;
  final String? savingsOpportunity;
  final List<InsightMonthOption> availableMonths;
}

class InsightMonthOption {
  const InsightMonthOption({required this.key, required this.label});
  final String key;
  final String label;
}

class InsightCategory {
  const InsightCategory({
    required this.id,
    required this.label,
    this.amountKobo,
    this.barFraction,
  });

  final String id;
  final String label;
  final int? amountKobo;

  /// Optional server/host-computed chart proportion in the range 0..1.
  final double? barFraction;
}

class InsightMerchant {
  const InsightMerchant({required this.name, this.amountKobo});

  final String name;
  final int? amountKobo;
}

class InsightTransaction {
  const InsightTransaction({
    required this.id,
    required this.merchant,
    required this.description,
    required this.dateLabel,
    this.amountKobo,
  });

  final String id;
  final String merchant;
  final String description;
  final String dateLabel;
  final int? amountKobo;
}

class InsightCategoryDetail {
  const InsightCategoryDetail({
    required this.categoryId,
    required this.categoryName,
    required this.personalisedConsent,
    this.totalKobo,
    this.trendText,
    this.transactions = const [],
  });

  final String categoryId;
  final String categoryName;
  final bool personalisedConsent;
  final int? totalKobo;
  final String? trendText;
  final List<InsightTransaction> transactions;
}

/// Host-mapped budget presentation data. Progress and remaining amounts are
/// supplied values; this feature does not derive them from spending.
class BudgetSnapshot {
  const BudgetSnapshot({required this.budgets, this.personalisedConsent});

  final List<BudgetEntry> budgets;
  final bool? personalisedConsent;
}

class BudgetEntry {
  const BudgetEntry({
    required this.id,
    required this.category,
    required this.amountKobo,
    this.spentKobo,
    this.remainingKobo,
    this.progressFraction,
    this.progressStatus,
  });

  final String id;
  final String category;
  final int amountKobo;
  final int? spentKobo;
  final int? remainingKobo;
  final double? progressFraction;
  final String? progressStatus;
}

class BudgetSuggestion {
  const BudgetSuggestion({
    required this.category,
    required this.amountKobo,
    required this.sourceLabel,
  });

  final String category;
  final int amountKobo;
  final String sourceLabel;
}

/// Nullable values mean the host did not supply a saved choice.
class PrivacyPreferences {
  const PrivacyPreferences({this.personalised, this.tips, this.alerts});

  final bool? personalised;
  final bool? tips;
  final bool? alerts;
}

/// Host-mapped rewards response. Monetary values and campaign progress are
/// supplied by the host; this feature does not derive or calculate them.
class RewardsSnapshot {
  const RewardsSnapshot({
    this.balanceKobo,
    this.recentCredits = const [],
    this.campaigns = const [],
  });

  final int? balanceKobo;
  final List<RewardCredit> recentCredits;
  final List<RewardCampaign> campaigns;
}

class RewardCredit {
  const RewardCredit({
    required this.description,
    required this.dateLabel,
    this.amountKobo,
    this.status,
  });

  final String description;
  final String dateLabel;
  final int? amountKobo;
  final String? status;
}

class RewardCampaign {
  const RewardCampaign({
    required this.id,
    required this.title,
    this.status,
    this.action,
    this.rewardKobo,
    this.capDescription,
    this.startDateLabel,
    this.endDateLabel,
    this.terms,
    this.progressLabel,
    this.progressFraction,
  });

  final String id;
  final String title;
  final String? status;
  final String? action;
  final int? rewardKobo;
  final String? capDescription;
  final String? startDateLabel;
  final String? endDateLabel;
  final String? terms;
  final String? progressLabel;
  final double? progressFraction;
}

/// Host-mapped referral information. The API response schema is not published.
class ReferralSnapshot {
  const ReferralSnapshot({this.code, this.link, this.referrals = const []});

  final String? code;
  final String? link;
  final List<ReferralEntry> referrals;
}

class ReferralEntry {
  const ReferralEntry({required this.label, required this.status});

  final String label;
  final String status;
}

/// Host-mapped campaign list and approval metadata for the marketing console.
class CampaignAdminSnapshot {
  const CampaignAdminSnapshot({this.campaigns = const []});

  final List<CampaignAdminEntry> campaigns;
}

class CampaignAdminEntry {
  const CampaignAdminEntry({
    required this.id,
    required this.name,
    this.status,
    this.rulesSummary,
    this.budgetKobo,
    this.startsAt,
    this.endsAt,
    this.approvalStatus,
  });

  final String id;
  final String name;
  final String? status;
  final String? rulesSummary;
  final int? budgetKobo;
  final String? startsAt;
  final String? endsAt;
  final String? approvalStatus;
}

/// Host-mapped finance dashboard values. Chart fractions and alert messages
/// are supplied values; the feature does not calculate cost or thresholds.
class RewardCostSnapshot {
  const RewardCostSnapshot({
    this.budgetKobo,
    this.spendKobo,
    this.budgetFraction,
    this.spendFraction,
    this.status,
    this.exhaustedMessage,
    this.alerts = const [],
  });

  final int? budgetKobo;
  final int? spendKobo;
  final double? budgetFraction;
  final double? spendFraction;
  final String? status;
  final String? exhaustedMessage;
  final List<RewardCostAlert> alerts;
}

class RewardCostAlert {
  const RewardCostAlert({required this.message, this.status});

  final String message;
  final String? status;
}

/// Risk-review queue data supplied by a host mapping. There is no documented
/// back-office queue-list response schema or GET endpoint in the product API.
class ReferralReviewSnapshot {
  const ReferralReviewSnapshot({this.referrals = const []});

  final List<FlaggedReferral> referrals;
}

class FlaggedReferral {
  const FlaggedReferral({
    required this.id,
    required this.reference,
    this.status,
    this.signals = const [],
    this.canReview = false,
  });

  /// Must be the referral UUID accepted by the documented decision endpoint.
  final String id;
  final String reference;
  final String? status;
  final List<String> signals;

  /// Unknown permissions default to unavailable; the host remains authoritative.
  final bool canReview;
}

enum ReferralReviewDecision { approve, reject }
