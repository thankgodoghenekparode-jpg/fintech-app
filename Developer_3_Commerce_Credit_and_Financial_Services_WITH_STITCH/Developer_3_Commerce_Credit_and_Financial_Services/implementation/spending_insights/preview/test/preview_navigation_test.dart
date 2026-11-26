// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_spending_insights/sixth_spending_insights.dart';
import 'package:sixth_spending_insights_preview/main.dart';

void main() {
  testWidgets('preview registers each Batch 1 screen and category navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    await tester.tap(find.text('S-INS-001 · Insights home'));
    await tester.pumpAndSettle();
    expect(find.text('Spend vs income'), findsOneWidget);
    await tester.drag(
      find.descendant(
        of: find.byType(InsightsHomePage),
        matching: find.byType(Scrollable),
      ),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Food & dining'));
    await tester.pumpAndSettle();
    expect(find.text('Category detail'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Transactions'),
      300,
      scrollable: find.descendant(
        of: find.byType(CategoryDetailPage),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Transactions'), findsOneWidget);
  });

  testWidgets('preview opens monthly summary route from directory', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.drag(find.byType(ListView).last, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-INS-005 · Monthly summary'));
    await tester.pumpAndSettle();
    expect(find.text('Monthly summary'), findsOneWidget);
    expect(find.byType(MonthlySummaryPage), findsOneWidget);
  });

  testWidgets('narrow preview viewport renders without layout exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview theme toggle switches between light and dark', (
    tester,
  ) async {
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(find.text('Dark'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets(
      'Batch 2 preview routes open budgets, create budget and preferences', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.scrollUntilVisible(
      find.text('S-INS-003 · Budgets'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('S-INS-003 · Budgets'));
    await tester.pumpAndSettle();
    expect(find.byType(BudgetsPage), findsOneWidget);
    expect(find.text('Food & dining'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Add budget'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Add budget'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateBudgetPage), findsOneWidget);
    expect(find.text('Alert thresholds'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy preferences route exposes unknown host consent safely', (
    tester,
  ) async {
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.scrollUntilVisible(
      find.text('S-INS-009 · Privacy and preferences'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('S-INS-009 · Privacy and preferences'));
    await tester.pumpAndSettle();
    expect(find.byType(PrivacyPreferencesPage), findsOneWidget);
    expect(find.text('Not provided'), findsNWidgets(3));
    await tester.scrollUntilVisible(
      find.text(
          'Choose whether to enable personalised insights before saving.'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
        find.text(
            'Choose whether to enable personalised insights before saving.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Batch 3 routes are registered with safe unavailable preview data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.scrollUntilVisible(
      find.text('S-INS-006 · Rewards home'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('S-INS-006 · Rewards home'));
    await tester.pumpAndSettle();
    expect(find.byType(RewardsHomePage), findsOneWidget);
    expect(find.text('Rewards unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('S-INS-007'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining('S-INS-007'));
    await tester.pumpAndSettle();
    expect(find.byType(CampaignDetailPage), findsOneWidget);
    expect(find.text('Campaign details unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Batch 4 routes open referral and responsive campaign admin', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SpendingInsightsPreviewApp());
    await tester.scrollUntilVisible(
      find.textContaining('S-INS-008'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining('S-INS-008'));
    await tester.pumpAndSettle();
    expect(find.byType(ReferAFriendPage), findsOneWidget);
    expect(find.text('Referral information unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('W-INS-001'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining('W-INS-001'));
    await tester.pumpAndSettle();
    expect(find.byType(CampaignsAndRulesPage), findsOneWidget);
    expect(find.text('Campaign list unavailable'), findsOneWidget);
    expect(find.text('Create campaign'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('W-INS-002'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining('W-INS-002'));
    await tester.pumpAndSettle();
    expect(find.byType(RewardBudgetAndCostPage), findsOneWidget);
    expect(find.text('Budget and cost unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('W-INS-003'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.textContaining('W-INS-003'));
    await tester.pumpAndSettle();
    expect(find.byType(ReferralReviewPage), findsOneWidget);
    expect(find.text('Referral queue unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
