// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:sixth_spending_insights/sixth_spending_insights.dart';

void main() => runApp(const SpendingInsightsPreviewApp());

class SpendingInsightsPreviewApp extends StatefulWidget {
  const SpendingInsightsPreviewApp({super.key});

  @override
  State<SpendingInsightsPreviewApp> createState() =>
      _SpendingInsightsPreviewAppState();
}

class _SpendingInsightsPreviewAppState
    extends State<SpendingInsightsPreviewApp> {
  final _adapter = const _SyntheticInsightsAdapter();
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _dark = false;

  void _toggleTheme() => setState(() => _dark = !_dark);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Spending Insights Preview',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: InsightsTheme.light(),
        darkTheme: InsightsTheme.dark(),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/preview',
        onGenerateRoute: _route,
        builder: (context, child) => Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 82),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                bottom: false,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color:
                      _dark ? const Color(0xFF33290F) : const Color(0xFFFFF4DB),
                  child: Row(
                    children: [
                      const Icon(Icons.science_outlined, size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'NON-PRODUCTION - Synthetic data only - APIs off',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleTheme,
                        child: Text(_dark ? 'Dark' : 'Light'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Route<void> _route(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/preview');
    final path = uri.path;
    late final Widget page;
    if (path == '/insights') {
      page = InsightsHomePage(
        adapter: _adapter,
        monthKey: uri.queryParameters['month'] ?? '2026-11',
        onThemeToggle: _toggleTheme,
        onOpenCategory: (category) => _navigatorKey.currentState?.pushNamed(
          '/insights/category/${Uri.encodeComponent(category.id)}?month=${uri.queryParameters['month'] ?? '2026-11'}',
        ),
        onOpenSummary: () => _navigatorKey.currentState?.pushNamed(
          '/insights/summary/${uri.queryParameters['month'] ?? '2026-11'}',
        ),
      );
    } else if (path.startsWith('/insights/category/')) {
      final categoryId = Uri.decodeComponent(
        path.substring('/insights/category/'.length),
      );
      page = CategoryDetailPage(
        adapter: _adapter,
        categoryId: categoryId,
        monthKey: uri.queryParameters['month'] ?? '2026-11',
        onThemeToggle: _toggleTheme,
      );
    } else if (path.startsWith('/insights/summary/')) {
      final month = path.substring('/insights/summary/'.length);
      page = MonthlySummaryPage(
        adapter: _adapter,
        monthKey: month,
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/insights/budgets') {
      page = BudgetsPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
        onCreate: () => _navigatorKey.currentState?.pushNamed(
          '/insights/budgets/new',
        ),
      );
    } else if (path == '/insights/budgets/new') {
      page = CreateBudgetPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
        onComplete: () => _navigatorKey.currentState?.popUntil(
          (route) => route.settings.name == '/insights/budgets',
        ),
        lastMonthSuggestions: const [
          BudgetSuggestion(
            category: 'Food & dining',
            amountKobo: 1100000,
            sourceLabel: 'Synthetic October preview fixture',
          ),
          BudgetSuggestion(
            category: 'Transport',
            amountKobo: 815000,
            sourceLabel: 'Synthetic October preview fixture',
          ),
        ],
      );
    } else if (path == '/insights/preferences') {
      page = PrivacyPreferencesPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/rewards') {
      page = RewardsHomePage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
        onOpenCampaign: (id) =>
            _navigatorKey.currentState?.pushNamed('/rewards/$id'),
      );
    } else if (path == '/rewards/refer') {
      page = ReferAFriendPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
      );
    } else if (path.startsWith('/rewards/')) {
      page = CampaignDetailPage(
        adapter: _adapter,
        campaignId: Uri.decodeComponent(path.substring('/rewards/'.length)),
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/backoffice/rewards/campaigns') {
      page = CampaignsAndRulesPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/backoffice/rewards/budget') {
      page = RewardBudgetAndCostPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/backoffice/rewards/referrals') {
      page = ReferralReviewPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
      );
    } else {
      page = _PreviewDirectory(onThemeToggle: _toggleTheme);
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}

class _PreviewDirectory extends StatelessWidget {
  const _PreviewDirectory({required this.onThemeToggle});
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Insights preview'),
          actions: [
            IconButton(
              tooltip: 'Switch theme',
              onPressed: onThemeToggle,
              icon: const Icon(Icons.contrast_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Spending Insights screens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Synthetic figures and transactions below are for layout preview only.',
            ),
            const SizedBox(height: 16),
            _ScreenLink(
              title: 'S-INS-001 · Insights home',
              route: '/insights?month=2026-11',
            ),
            _ScreenLink(
              title: 'S-INS-002 · Category detail',
              route: '/insights/category/food?month=2026-11',
            ),
            _ScreenLink(
              title: 'S-INS-005 · Monthly summary',
              route: '/insights/summary/2026-11',
            ),
            const SizedBox(height: 20),
            Text(
              'Batch 2 screens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _ScreenLink(
              title: 'S-INS-003 · Budgets',
              route: '/insights/budgets',
            ),
            _ScreenLink(
              title: 'S-INS-004 · Create budget',
              route: '/insights/budgets/new',
            ),
            _ScreenLink(
              title: 'S-INS-009 · Privacy and preferences',
              route: '/insights/preferences',
            ),
            const SizedBox(height: 20),
            Text(
              'Batch 3 screens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _ScreenLink(title: 'S-INS-006 · Rewards home', route: '/rewards'),
            _ScreenLink(
              title: 'S-INS-007 · Campaign detail (unavailable preview data)',
              route: '/rewards/preview-campaign',
            ),
            _ScreenLink(
              title: 'S-INS-008 · Refer a friend',
              route: '/rewards/refer',
            ),
            _ScreenLink(
              title: 'W-INS-001 · Campaigns and rules',
              route: '/backoffice/rewards/campaigns',
            ),
            _ScreenLink(
              title: 'W-INS-002 · Reward budget and cost',
              route: '/backoffice/rewards/budget',
            ),
            _ScreenLink(
              title: 'W-INS-003 - Referral review',
              route: '/backoffice/rewards/referrals',
            ),
          ],
        ),
      );
}

class _ScreenLink extends StatelessWidget {
  const _ScreenLink({required this.title, required this.route});
  final String title;
  final String route;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).pushNamed(route),
        ),
      );
}

class _SyntheticInsightsAdapter implements SpendingInsightsAdapter {
  const _SyntheticInsightsAdapter();

  static const _months = <String, InsightsMonth>{
    '2026-11': InsightsMonth(
      monthKey: '2026-11',
      monthLabel: 'November 2026',
      personalisedConsent: true,
      hasEnoughData: true,
      incomeKobo: 58200000,
      spendKobo: 3714500,
      categories: [
        InsightCategory(
          id: 'food',
          label: 'Food & dining',
          amountKobo: 1245000,
          barFraction: .34,
        ),
        InsightCategory(
          id: 'transport',
          label: 'Transport',
          amountKobo: 960000,
          barFraction: .26,
        ),
        InsightCategory(
          id: 'bills',
          label: 'Bills & utilities',
          amountKobo: 740000,
          barFraction: .20,
        ),
      ],
      topMerchants: [
        InsightMerchant(name: 'Market Square', amountKobo: 524000),
        InsightMerchant(name: 'City Transit', amountKobo: 318500),
      ],
      tip: 'Review your recurring spending when it suits you.',
      highlights: ['Your largest category was Food & dining.'],
      comparisonText:
          'Month-on-month comparison is not included in this sample.',
      savingsOpportunity: null,
      availableMonths: [
        InsightMonthOption(key: '2026-10', label: 'October 2026'),
        InsightMonthOption(key: '2026-11', label: 'November 2026'),
      ],
    ),
    '2026-10': InsightsMonth(
      monthKey: '2026-10',
      monthLabel: 'October 2026',
      personalisedConsent: true,
      hasEnoughData: true,
      incomeKobo: 58200000,
      spendKobo: 3442100,
      categories: [
        InsightCategory(
          id: 'food',
          label: 'Food & dining',
          amountKobo: 1100000,
          barFraction: .32,
        ),
        InsightCategory(
          id: 'transport',
          label: 'Transport',
          amountKobo: 815000,
          barFraction: .24,
        ),
      ],
      topMerchants: [
        InsightMerchant(name: 'Market Square', amountKobo: 481000),
      ],
      highlights: ['This is synthetic example content.'],
      availableMonths: [
        InsightMonthOption(key: '2026-10', label: 'October 2026'),
        InsightMonthOption(key: '2026-11', label: 'November 2026'),
      ],
    ),
  };

  @override
  Future<InsightsMonth?> loadMonth(String monthKey) async => _months[monthKey];

  @override
  Future<InsightCategoryDetail?> loadCategory({
    required String categoryId,
    required String monthKey,
  }) async {
    final month = _months[monthKey];
    final category =
        month?.categories.where((item) => item.id == categoryId).firstOrNull;
    if (category == null) return null;
    return InsightCategoryDetail(
      categoryId: categoryId,
      categoryName: category.label,
      personalisedConsent: month!.personalisedConsent,
      totalKobo: category.amountKobo,
      trendText: 'Trend comparison is not part of this synthetic example.',
      transactions: const [
        InsightTransaction(
          id: 'preview-transaction-1',
          merchant: 'Market Square',
          description: 'Synthetic preview transaction',
          dateLabel: 'Sample date',
          amountKobo: 24500,
        ),
        InsightTransaction(
          id: 'preview-transaction-2',
          merchant: 'Corner Shop',
          description: 'Synthetic preview transaction',
          dateLabel: 'Sample date',
          amountKobo: 16800,
        ),
      ],
    );
  }

  @override
  Future<void> recategorise({
    required String transactionId,
    required String category,
  }) =>
      Future<void>.error(
        const InsightsHostUnavailable(
          'Re-categorisation requires a connected host service.',
        ),
      );

  @override
  Future<BudgetSnapshot?> loadBudgets() async => const BudgetSnapshot(
        budgets: [
          BudgetEntry(
            id: 'preview-budget-food',
            category: 'Food & dining',
            amountKobo: 1500000,
            spentKobo: 420000,
            remainingKobo: 1080000,
            progressFraction: .28,
            progressStatus: 'Within budget',
          ),
          BudgetEntry(
            id: 'preview-budget-transport',
            category: 'Transport',
            amountKobo: 1000000,
            spentKobo: 610000,
            remainingKobo: 390000,
            progressFraction: .61,
            progressStatus: 'On track',
          ),
        ],
      );

  @override
  Future<void> createBudget({
    required String category,
    required int amountKobo,
    required List<int> alerts,
  }) =>
      Future<void>.error(
        const InsightsHostUnavailable(
          'Budget creation requires a connected host service.',
        ),
      );

  @override
  Future<PrivacyPreferences?> loadPreferences() async =>
      const PrivacyPreferences();

  @override
  Future<void> savePreferences({
    required bool personalised,
    bool? tips,
    bool? alerts,
  }) =>
      Future<void>.error(
        const InsightsHostUnavailable(
          'Saving preferences requires a connected host service.',
        ),
      );

  @override
  Future<RewardsSnapshot?> loadRewards() async => null;

  @override
  Future<ReferralSnapshot?> loadReferral() async => null;

  @override
  Future<CampaignAdminSnapshot?> loadCampaignAdmin() async => null;

  @override
  Future<void> createCampaign({
    required Map<String, Object?> rules,
    required int budgetKobo,
    required String startsAt,
    required String endsAt,
  }) =>
      Future<void>.error(
        const InsightsHostUnavailable(
          'Campaign submission requires a connected host service.',
        ),
      );

  @override
  Future<RewardCostSnapshot?> loadRewardCost() async => null;

  @override
  Future<ReferralReviewSnapshot?> loadReferralReviews() async => null;

  @override
  Future<void> decideReferral({
    required String referralId,
    required ReferralReviewDecision decision,
    String? reason,
  }) =>
      Future<void>.error(
        const InsightsHostUnavailable(
          'Referral decisions require a connected Risk host service.',
        ),
      );
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
