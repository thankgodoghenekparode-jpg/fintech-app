import 'dart:async';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_spending_insights/sixth_spending_insights.dart';

void main() {
  group('ReferralReviewPage', () {
    testWidgets('shows loading while the host queue is pending',
        (tester) async {
      final queue = Completer<ReferralReviewSnapshot?>();
      await tester.pumpWidget(MaterialApp(
        home: ReferralReviewPage(
          adapter: _FakeAdapter(referralReviewsCompleter: queue),
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      queue.complete(null);
      await tester.pumpAndSettle();
      expect(find.text('Referral queue unavailable'), findsOneWidget);
    });

    testWidgets(
      'renders host rows and keeps decisions unavailable by default',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ReferralReviewPage(
              adapter: _FakeAdapter(
                referralReviews: const ReferralReviewSnapshot(
                  referrals: [
                    FlaggedReferral(
                      id: 'host-id',
                      reference: 'Host reference',
                      status: 'Host status',
                      signals: ['Host signal'],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Flagged referrals'), findsOneWidget);
        expect(find.text('Host reference'), findsOneWidget);
        expect(find.text('Host signal'), findsOneWidget);
        expect(
          tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Approve'),
              )
              .onPressed,
          isNull,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('submits selected decision through the host adapter', (
      tester,
    ) async {
      final adapter = _FakeAdapter(
        referralReviews: const ReferralReviewSnapshot(
          referrals: [
            FlaggedReferral(
              id: 'host-id',
              reference: 'Host reference',
              canReview: true,
            ),
          ],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(home: ReferralReviewPage(adapter: adapter)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reject'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Host review reason');
      await tester.tap(find.text('Confirm decision'));
      await tester.pumpAndSettle();
      expect(adapter.reviewedReferralId, 'host-id');
      expect(adapter.reviewDecision, ReferralReviewDecision.reject);
      expect(adapter.reviewReason, 'Host review reason');
      expect(find.text('Decision submitted to the host.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows unavailable, empty and retryable error states', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: ReferralReviewPage(adapter: _FakeAdapter())),
      );
      await tester.pumpAndSettle();
      expect(find.text('Referral queue unavailable'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: ReferralReviewPage(
            key: const ValueKey('empty-review-queue'),
            adapter: _FakeAdapter(
              referralReviews: const ReferralReviewSnapshot(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No flagged referrals'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: ReferralReviewPage(
            key: const ValueKey('failed-review-queue'),
            adapter: _FakeAdapter(failReferralReviews: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Referral queue could not be loaded'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('InsightsHomePage', () {
    testWidgets('renders summary and opens category detail callback', (
      tester,
    ) async {
      final adapter = _FakeAdapter(month: _month());
      InsightCategory? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: InsightsTheme.light(),
          home: InsightsHomePage(
            adapter: adapter,
            monthKey: '2026-11',
            onOpenCategory: (value) => selected = value,
            onOpenSummary: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Spend vs income'), findsOneWidget);
      expect(find.text('Food & dining'), findsOneWidget);
      await tester.tap(find.text('Food & dining'));
      expect(selected?.id, 'food');
    });

    testWidgets('hides personal figures when consent is off', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InsightsHomePage(
            adapter: _FakeAdapter(month: _month(personalisedConsent: false)),
            monthKey: '2026-11',
            onOpenCategory: (_) {},
            onOpenSummary: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Personalised insights are off'), findsOneWidget);
      expect(find.text('Food & dining'), findsNothing);
    });

    testWidgets('renders not enough data state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InsightsHomePage(
            adapter: _FakeAdapter(month: _month(hasEnoughData: false)),
            monthKey: '2026-11',
            onOpenCategory: (_) {},
            onOpenSummary: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Not enough data yet'), findsOneWidget);
    });
  });

  testWidgets('category supports empty transactions', (tester) async {
    final adapter = _FakeAdapter(
      detail: const InsightCategoryDetail(
        categoryId: 'food',
        categoryName: 'Food & dining',
        personalisedConsent: true,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: CategoryDetailPage(
          adapter: adapter,
          categoryId: 'food',
          monthKey: '2026-11',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No transactions in this category'), findsOneWidget);
  });

  testWidgets('re-categorise sends the entered category to the adapter', (
    tester,
  ) async {
    final adapter = _FakeAdapter(
      detail: const InsightCategoryDetail(
        categoryId: 'food',
        categoryName: 'Food & dining',
        personalisedConsent: true,
        transactions: [
          InsightTransaction(
            id: 'transaction-1',
            merchant: 'Sample Merchant',
            description: 'Host supplied transaction',
            dateLabel: 'Sample date',
            amountKobo: 10000,
          ),
        ],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: CategoryDetailPage(
          adapter: adapter,
          categoryId: 'food',
          monthKey: '2026-11',
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Re-categorise'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Bills');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(adapter.updatedTransactionId, 'transaction-1');
    expect(adapter.updatedCategory, 'Bills');
  });

  testWidgets('shows loading while the month host request is pending', (
    tester,
  ) async {
    final completer = Completer<InsightsMonth?>();
    await tester.pumpWidget(
      MaterialApp(
        home: InsightsHomePage(
          adapter: _FakeAdapter(monthCompleter: completer),
          monthKey: '2026-11',
          onOpenCategory: (_) {},
          onOpenSummary: () {},
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    completer.complete(_month());
    await tester.pumpAndSettle();
    expect(find.text('Spend vs income'), findsOneWidget);
  });

  testWidgets('shows a retryable error when the host request fails', (
    tester,
  ) async {
    final adapter = _FakeAdapter(month: _month(), failuresBeforeSuccess: 1);
    await tester.pumpWidget(
      MaterialApp(
        home: InsightsHomePage(
          adapter: adapter,
          monthKey: '2026-11',
          onOpenCategory: (_) {},
          onOpenSummary: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Could not load insights'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Spend vs income'), findsOneWidget);
    expect(adapter.monthLoadCount, 2);
  });

  testWidgets(
    'summary renders host highlights and keeps absent share integration disabled',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MonthlySummaryPage(
            adapter: _FakeAdapter(month: _month()),
            monthKey: '2026-11',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('A host supplied highlight.'), findsOneWidget);
      final share = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Share summary'),
      );
      expect(share.onPressed, isNull);
      expect(find.textContaining('provided by the host app'), findsOneWidget);
    },
  );

  testWidgets('budgets renders host values and supports the create route', (
    tester,
  ) async {
    var openedCreate = false;
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetsPage(
          key: const ValueKey('empty'),
          adapter: _FakeAdapter(
            budgets: const BudgetSnapshot(
              budgets: [
                BudgetEntry(
                  id: 'b1',
                  category: 'Food',
                  amountKobo: 100000,
                  remainingKobo: 70000,
                  progressFraction: .3,
                ),
              ],
            ),
          ),
          onCreate: () => openedCreate = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Remaining'), findsOneWidget);
    await tester.tap(find.text('Add budget'));
    expect(openedCreate, isTrue);
  });

  testWidgets('budgets distinguishes empty and failed host responses', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetsPage(
          key: const ValueKey('empty'),
          adapter: _FakeAdapter(budgets: const BudgetSnapshot(budgets: [])),
          onCreate: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No budgets yet'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: BudgetsPage(
          key: const ValueKey('failed'),
          adapter: _FakeAdapter(failBudgets: true),
          onCreate: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Budgets could not be loaded'), findsOneWidget);
  });

  testWidgets('preferences shows unavailable and retryable error states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PrivacyPreferencesPage(
          key: const ValueKey('unavailable'),
          adapter: _FakeAdapter(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Preferences unavailable'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: PrivacyPreferencesPage(
          key: const ValueKey('failed'),
          adapter: _FakeAdapter(failPreferences: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Preferences could not be loaded'), findsOneWidget);
  });

  testWidgets('rewards home renders host fields and opens a campaign', (
    tester,
  ) async {
    final adapter = _FakeAdapter(
      rewards: const RewardsSnapshot(
        balanceKobo: 125000,
        recentCredits: [
          RewardCredit(
            description: 'Host supplied credit',
            dateLabel: 'Host supplied date',
            amountKobo: 25000,
          ),
        ],
        campaigns: [
          RewardCampaign(
            id: 'campaign-1',
            title: 'Host supplied campaign',
            status: 'Active',
            progressLabel: 'Host supplied progress',
            progressFraction: .4,
          ),
        ],
      ),
    );
    String? openedId;
    await tester.pumpWidget(
      MaterialApp(
        home: RewardsHomePage(
          adapter: adapter,
          onOpenCampaign: (id) => openedId = id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Reward balance'), findsOneWidget);
    expect(find.text('Host supplied credit'), findsOneWidget);
    expect(find.text('Host supplied campaign'), findsOneWidget);
    await tester.tap(find.text('Host supplied campaign'));
    expect(openedId, 'campaign-1');
  });

  testWidgets('campaign detail renders supplied terms and progress', (
    tester,
  ) async {
    final adapter = _FakeAdapter(
      rewards: const RewardsSnapshot(
        campaigns: [
          RewardCampaign(
            id: 'campaign-1',
            title: 'Host supplied campaign',
            action: 'Host supplied action',
            rewardKobo: 50000,
            capDescription: 'Host supplied cap',
            startDateLabel: 'Host start',
            endDateLabel: 'Host end',
            terms: 'Host supplied terms',
            progressLabel: 'Host supplied progress',
            progressFraction: .5,
          ),
        ],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: CampaignDetailPage(adapter: adapter, campaignId: 'campaign-1'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('What to do'), findsOneWidget);
    expect(find.text('Host supplied action'), findsOneWidget);
    expect(find.text('Host supplied terms'), findsOneWidget);
    expect(find.text('Host supplied progress'), findsOneWidget);
  });

  testWidgets('rewards screens expose unavailable and error states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RewardsHomePage(adapter: _FakeAdapter(), onOpenCampaign: (_) {}),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Rewards unavailable'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: CampaignDetailPage(
          key: const ValueKey('failed-campaign'),
          adapter: _FakeAdapter(failRewards: true),
          campaignId: 'campaign-1',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Campaign details could not be loaded'), findsOneWidget);
  });

  testWidgets(
    'referral screen renders host info and shares through host callback',
    (tester) async {
      String? sharedCode;
      String? sharedLink;
      await tester.pumpWidget(
        MaterialApp(
          home: ReferAFriendPage(
            adapter: _FakeAdapter(
              referral: const ReferralSnapshot(
                code: 'HOST_CODE',
                link: 'https://host.example/referral',
                referrals: [
                  ReferralEntry(
                    label: 'Host supplied referral',
                    status: 'Pending',
                  ),
                ],
              ),
            ),
            onShare: (code, link) {
              sharedCode = code;
              sharedLink = link;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('HOST_CODE'), findsOneWidget);
      expect(find.text('Host supplied referral'), findsOneWidget);
      await tester.tap(find.text('Share'));
      expect(sharedCode, 'HOST_CODE');
      expect(sharedLink, 'https://host.example/referral');
    },
  );

  testWidgets(
    'campaign administration lists host data and submits documented fields',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final adapter = _FakeAdapter(
        campaignAdmin: const CampaignAdminSnapshot(
          campaigns: [
            CampaignAdminEntry(
              id: 'host-campaign',
              name: 'Host supplied campaign',
              status: 'Active',
              approvalStatus: 'Approved by host',
            ),
          ],
        ),
        failCampaignSubmit: true,
      );
      await tester.pumpWidget(
        MaterialApp(home: CampaignsAndRulesPage(adapter: adapter)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Host supplied campaign'), findsOneWidget);
      expect(find.text('Approved by host'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        '{"hostRule": true}',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '125.50');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '2026-12-01T00:00:00Z',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        '2026-12-31T00:00:00Z',
      );
      await tester.scrollUntilVisible(
        find.text('Submit for approval'),
        240,
        scrollable: find
            .descendant(
              of: find.byType(CampaignsAndRulesPage),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('Submit for approval'));
      await tester.pumpAndSettle();
      expect(adapter.createdRules, {'hostRule': true});
      expect(adapter.createdCampaignBudgetKobo, 12550);
      expect(adapter.createdCampaignStartsAt, '2026-12-01T00:00:00.000Z');
      expect(adapter.createdCampaignEndsAt, '2026-12-31T00:00:00.000Z');
      expect(
        find.textContaining('Campaign submission requires a connected host'),
        findsOneWidget,
      );
      expect(
        find.textContaining('The host accepted the documented request'),
        findsNothing,
      );
    },
  );

  testWidgets('referral and campaigns show unavailable host states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ReferAFriendPage(adapter: _FakeAdapter())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Referral information unavailable'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: CampaignsAndRulesPage(
          key: const ValueKey('campaigns'),
          adapter: _FakeAdapter(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Campaign list unavailable'), findsOneWidget);
    expect(find.text('Submit for approval'), findsOneWidget);
  });

  testWidgets(
    'reward budget page renders host metrics and disables unsupported actions',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: RewardBudgetAndCostPage(
            adapter: _FakeAdapter(
              rewardCost: const RewardCostSnapshot(
                budgetKobo: 100000000,
                spendKobo: 36000000,
                budgetFraction: .8,
                spendFraction: .36,
                status: 'Host supplied status',
                exhaustedMessage: 'Host supplied exhausted notice',
                alerts: [
                  RewardCostAlert(
                    message: 'Host supplied alert',
                    status: 'Host supplied alert status',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Budget vs spend'), findsOneWidget);
      expect(find.text('Host supplied status'), findsOneWidget);
      expect(find.text('Host supplied exhausted notice'), findsOneWidget);
      expect(find.text('Host supplied alert'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Pause / resume unavailable'),
            )
            .onPressed,
        isNull,
      );
    },
  );

  testWidgets('reward budget page handles unavailable, empty and error data', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: RewardBudgetAndCostPage(adapter: _FakeAdapter())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Budget and cost unavailable'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: RewardBudgetAndCostPage(
          key: const ValueKey('empty-cost'),
          adapter: _FakeAdapter(rewardCost: const RewardCostSnapshot()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No budget or spend data available'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: RewardBudgetAndCostPage(
          key: const ValueKey('failed-cost'),
          adapter: _FakeAdapter(failRewardCost: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Budget and cost could not be loaded'), findsOneWidget);
  });

  testWidgets(
    'create budget validates and keeps preview operation unavailable',
    (tester) async {
      final adapter = _FakeAdapter(failCreate: true);
      await tester.pumpWidget(
        MaterialApp(
          home: CreateBudgetPage(adapter: adapter, onComplete: () {}),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save budget'));
      await tester.tap(find.text('Save budget'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a category.'), findsOneWidget);
      expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Category'),
        'Food',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Monthly amount'),
        '125.50',
      );
      await tester.ensureVisible(find.text('Save budget'));
      await tester.tap(find.text('Save budget'));
      await tester.pumpAndSettle();
      expect(adapter.createdCategory, 'Food');
      expect(adapter.createdAmountKobo, 12550);
      expect(find.text('Budget created'), findsNothing);
      expect(
        find.textContaining('requires a connected host service'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'privacy preferences require explicit consent and save host values',
    (tester) async {
      final adapter = _FakeAdapter(preferences: const PrivacyPreferences());
      await tester.pumpWidget(
        MaterialApp(home: PrivacyPreferencesPage(adapter: adapter)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Not provided'), findsNWidgets(3));
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Save preferences'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byTooltip('Choose preference').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Turn on'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Save preferences'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.ensureVisible(find.text('Save preferences'));
      await tester.tap(find.text('Save preferences'));
      await tester.pumpAndSettle();
      expect(adapter.savedPersonalised, isTrue);
      expect(adapter.savedTips, isNull);
      expect(adapter.savedAlerts, isNull);
    },
  );
}

InsightsMonth _month({
  bool personalisedConsent = true,
  bool hasEnoughData = true,
}) =>
    InsightsMonth(
      monthKey: '2026-11',
      monthLabel: 'November 2026',
      personalisedConsent: personalisedConsent,
      hasEnoughData: hasEnoughData,
      incomeKobo: 5000000,
      spendKobo: 200000,
      categories: const [
        InsightCategory(
          id: 'food',
          label: 'Food & dining',
          amountKobo: 100000,
          barFraction: .5,
        ),
      ],
      topMerchants: const [
        InsightMerchant(name: 'Sample Merchant', amountKobo: 100000),
      ],
      highlights: const ['A host supplied highlight.'],
    );

class _FakeAdapter implements SpendingInsightsAdapter {
  _FakeAdapter({
    this.month,
    this.detail,
    this.monthCompleter,
    this.failuresBeforeSuccess = 0,
    this.budgets,
    this.preferences,
    this.failCreate = false,
    this.failBudgets = false,
    this.failPreferences = false,
    this.rewards,
    this.failRewards = false,
    this.referral,
    this.campaignAdmin,
    this.failCampaignSubmit = false,
    this.rewardCost,
    this.failRewardCost = false,
    this.referralReviews,
    this.failReferralReviews = false,
    this.referralReviewsCompleter,
  });
  final InsightsMonth? month;
  final InsightCategoryDetail? detail;
  final Completer<InsightsMonth?>? monthCompleter;
  final int failuresBeforeSuccess;
  final BudgetSnapshot? budgets;
  final PrivacyPreferences? preferences;
  final bool failCreate;
  final bool failBudgets;
  final bool failPreferences;
  final RewardsSnapshot? rewards;
  final bool failRewards;
  final ReferralSnapshot? referral;
  final CampaignAdminSnapshot? campaignAdmin;
  final bool failCampaignSubmit;
  final RewardCostSnapshot? rewardCost;
  final bool failRewardCost;
  final ReferralReviewSnapshot? referralReviews;
  final bool failReferralReviews;
  final Completer<ReferralReviewSnapshot?>? referralReviewsCompleter;
  Map<String, Object?>? createdRules;
  int? createdCampaignBudgetKobo;
  String? createdCampaignStartsAt;
  String? createdCampaignEndsAt;
  int monthLoadCount = 0;
  String? updatedTransactionId;
  String? updatedCategory;
  String? createdCategory;
  int? createdAmountKobo;
  bool? savedPersonalised;
  bool? savedTips;
  bool? savedAlerts;
  String? reviewedReferralId;
  ReferralReviewDecision? reviewDecision;
  String? reviewReason;
  @override
  Future<InsightsMonth?> loadMonth(String monthKey) {
    monthLoadCount++;
    if (monthLoadCount <= failuresBeforeSuccess) {
      return Future.delayed(
        Duration.zero,
        () => throw StateError('test failure'),
      );
    }
    return monthCompleter?.future ?? Future.value(month);
  }

  @override
  Future<InsightCategoryDetail?> loadCategory({
    required String categoryId,
    required String monthKey,
  }) async =>
      detail;
  @override
  Future<void> recategorise({
    required String transactionId,
    required String category,
  }) async {
    updatedTransactionId = transactionId;
    updatedCategory = category;
  }

  @override
  Future<BudgetSnapshot?> loadBudgets() async {
    if (failBudgets) throw StateError('budget load failed');
    return budgets;
  }

  @override
  Future<void> createBudget({
    required String category,
    required int amountKobo,
    required List<int> alerts,
  }) async {
    createdCategory = category;
    createdAmountKobo = amountKobo;
    if (failCreate) {
      throw const InsightsHostUnavailable(
        'Budget creation requires a connected host service.',
      );
    }
  }

  @override
  Future<PrivacyPreferences?> loadPreferences() async {
    if (failPreferences) throw StateError('preferences load failed');
    return preferences;
  }

  @override
  Future<void> savePreferences({
    required bool personalised,
    bool? tips,
    bool? alerts,
  }) async {
    savedPersonalised = personalised;
    savedTips = tips;
    savedAlerts = alerts;
  }

  @override
  Future<RewardsSnapshot?> loadRewards() async {
    if (failRewards) throw StateError('rewards load failed');
    return rewards;
  }

  @override
  Future<ReferralSnapshot?> loadReferral() async => referral;

  @override
  Future<CampaignAdminSnapshot?> loadCampaignAdmin() async => campaignAdmin;

  @override
  Future<void> createCampaign({
    required Map<String, Object?> rules,
    required int budgetKobo,
    required String startsAt,
    required String endsAt,
  }) async {
    createdRules = rules;
    createdCampaignBudgetKobo = budgetKobo;
    createdCampaignStartsAt = startsAt;
    createdCampaignEndsAt = endsAt;
    if (failCampaignSubmit) {
      throw const InsightsHostUnavailable(
        'Campaign submission requires a connected host service.',
      );
    }
  }

  @override
  Future<RewardCostSnapshot?> loadRewardCost() async {
    if (failRewardCost) throw StateError('reward cost load failed');
    return rewardCost;
  }

  @override
  Future<ReferralReviewSnapshot?> loadReferralReviews() async {
    if (failReferralReviews) throw StateError('referral queue load failed');
    return referralReviewsCompleter?.future ?? referralReviews;
  }

  @override
  Future<void> decideReferral({
    required String referralId,
    required ReferralReviewDecision decision,
    String? reason,
  }) async {
    reviewedReferralId = referralId;
    reviewDecision = decision;
    reviewReason = reason;
  }
}
