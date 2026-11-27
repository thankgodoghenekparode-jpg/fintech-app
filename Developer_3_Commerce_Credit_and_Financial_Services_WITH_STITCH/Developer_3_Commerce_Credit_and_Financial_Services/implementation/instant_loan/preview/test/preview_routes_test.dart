// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_instant_loan/sixth_instant_loan.dart';

import '../lib/main.dart';

void main() {
  testWidgets('all Batch 1 screens are registered and accessible', (
    tester,
  ) async {
    await tester.pumpWidget(const InstantLoanPreviewApp());
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    expect(find.text('S-LOAN-001 · Borrow home'), findsOneWidget);
    expect(find.text('S-LOAN-002 · Eligibility and limit'), findsOneWidget);
    expect(find.text('S-LOAN-003 · Choose amount and tenor'), findsOneWidget);

    await tester.tap(find.text('S-LOAN-001 · Borrow home'));
    await tester.pumpAndSettle();
    expect(find.byType(BorrowHomePage), findsOneWidget);
    expect(find.text('Eligibility unavailable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('S-LOAN-002 · Eligibility and limit'));
    await tester.pumpAndSettle();
    expect(find.byType(EligibilityAndLimitPage), findsOneWidget);
    expect(find.text('Limit information unavailable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('S-LOAN-003 · Choose amount and tenor'));
    await tester.pumpAndSettle();
    expect(find.byType(ChooseAmountAndTenorPage), findsOneWidget);
    expect(find.text('Loan options unavailable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('S-LOAN-004 · Affordability check'));
    await tester.pumpAndSettle();
    expect(find.byType(AffordabilityCheckPage), findsOneWidget);
    expect(find.text('Affordability information unavailable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('S-LOAN-005 · Review and agreement'));
    await tester.pumpAndSettle();
    expect(find.byType(ReviewAndAgreementPage), findsOneWidget);
    expect(find.text('Agreement details unavailable'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Accept and continue to PIN'),
          )
          .onPressed,
      isNull,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('S-LOAN-006 · Loan application result'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('S-LOAN-006 · Loan application result'));
    await tester.pumpAndSettle();
    expect(find.byType(LoanResultPage), findsOneWidget);
    expect(find.text('Application result unavailable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    for (final entry in [
      (
        title: 'S-LOAN-007 - Loan detail',
        screen: LoanDetailPage,
        unavailable: 'Loan details unavailable',
      ),
      (
        title: 'S-LOAN-008 - Repay',
        screen: LoanRepaymentPage,
        unavailable: 'Repayment unavailable',
      ),
      (
        title: 'S-LOAN-009 - Auto-repay settings',
        screen: AutoRepaySettingsPage,
        unavailable: 'Auto-repay unavailable',
      ),
    ]) {
      await tester.scrollUntilVisible(
        find.text(entry.title),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(entry.title));
      await tester.pumpAndSettle();
      expect(find.byType(entry.screen), findsOneWidget);
      expect(find.text(entry.unavailable), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    for (final entry in [
      (
        title: 'S-LOAN-010 - Hardship request',
        screen: LoanHardshipPage,
        unavailable: 'Hardship request unavailable',
      ),
      (
        title: 'S-LOAN-011 - Loan history',
        screen: LoanHistoryPage,
        unavailable: 'Loan history unavailable',
      ),
      (
        title: 'S-LOAN-012 - Lender information and privacy',
        screen: LoanAboutPage,
        unavailable: 'Lender information unavailable',
      ),
    ]) {
      await tester.scrollUntilVisible(
        find.text(entry.title),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text(entry.title));
      await tester.pumpAndSettle();
      expect(find.byType(entry.screen), findsOneWidget);
      expect(find.text(entry.unavailable), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    expect(
      find.text('Implemented screens: S-LOAN-001 to S-LOAN-012'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
