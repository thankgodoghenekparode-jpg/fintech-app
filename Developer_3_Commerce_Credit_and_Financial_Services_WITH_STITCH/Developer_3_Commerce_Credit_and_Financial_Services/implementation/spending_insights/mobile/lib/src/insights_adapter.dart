import 'insights_models.dart';

/// Host boundary for documented Spending Insights reads and category updates.
/// The host maps incomplete API responses to these presentation models.
abstract interface class SpendingInsightsAdapter {
  Future<InsightsMonth?> loadMonth(String monthKey);

  Future<InsightCategoryDetail?> loadCategory({
    required String categoryId,
    required String monthKey,
  });

  Future<void> recategorise({
    required String transactionId,
    required String category,
  });

  Future<BudgetSnapshot?> loadBudgets();

  /// Completion indicates the host observed the documented 201 response.
  /// No undocumented response body is returned to this feature.
  Future<void> createBudget({
    required String category,
    required int amountKobo,
    required List<int> alerts,
  });

  Future<PrivacyPreferences?> loadPreferences();

  /// A null optional value is omitted from the documented PUT request.
  Future<void> savePreferences({
    required bool personalised,
    bool? tips,
    bool? alerts,
  });

  /// Host maps documented GET /rewards fields. The endpoint has no published
  /// success schema; absent values must stay null rather than be inferred.
  Future<RewardsSnapshot?> loadRewards();

  /// GET /rewards/referral; host maps the undocumented response schema.
  Future<ReferralSnapshot?> loadReferral();

  /// GET /backoffice/rewards/campaigns; host enforces Marketing admin access.
  Future<CampaignAdminSnapshot?> loadCampaignAdmin();

  /// POST /backoffice/rewards/campaigns. These are the documented request
  /// properties; the inner `rules` object schema is intentionally host-owned.
  Future<void> createCampaign({
    required Map<String, Object?> rules,
    required int budgetKobo,
    required String startsAt,
    required String endsAt,
  });

  /// GET /backoffice/rewards/budget; host enforces Finance access.
  Future<RewardCostSnapshot?> loadRewardCost();

  /// Host-provided queue adapter; no GET endpoint/response schema is documented.
  Future<ReferralReviewSnapshot?> loadReferralReviews();

  /// Documented POST /backoffice/rewards/referrals/{id}/decision. The host
  /// enforces Risk analyst access and supplies Idempotency-Key and X-Pin-Token.
  Future<void> decideReferral({
    required String referralId,
    required ReferralReviewDecision decision,
    String? reason,
  });
}

/// The preview adapter uses this to keep unsupported host operations explicit.
class InsightsHostUnavailable implements Exception {
  const InsightsHostUnavailable([
    this.message = 'This action is unavailable in preview.',
  ]);

  final String message;

  @override
  String toString() => message;
}
