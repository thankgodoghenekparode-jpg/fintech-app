// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_instant_loan/sixth_instant_loan.dart';

void main() {
  testWidgets('loan detail renders host schedule, receipts and actions', (
    tester,
  ) async {
    _useMobileViewport(tester);
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(
        statusLabel: 'Host status',
        balanceKobo: 100000,
        nextDueLabel: 'Host due date',
        isOverdue: true,
        overdueMessage: 'Host overdue information',
        schedule: [
          LoanScheduleItem(
            amountKobo: 25000,
            dueDateLabel: 'Host schedule date',
            statusLabel: 'Host schedule status',
          ),
        ],
        receipts: [
          LoanReceiptSummary(
            title: 'Host receipt',
            dateLabel: 'Host receipt date',
            amountKobo: 25000,
            reference: 'Host receipt reference',
          ),
        ],
        canRepay: true,
        canManageAutoRepay: true,
      ),
    );
    var repay = false;
    var auto = false;
    await tester.pumpWidget(
      MaterialApp(
        home: LoanDetailPage(
          adapter: adapter,
          loanId: 'host-loan-id',
          onRepay: () => repay = true,
          onAutoRepay: () => auto = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host status'), findsOneWidget);
    expect(find.text('Host due date'), findsOneWidget);
    expect(find.text('Host schedule date'), findsOneWidget);
    expect(find.text('Host overdue information'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Repay'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Repay'));
    expect(repay, isTrue);
    await tester.scrollUntilVisible(
      find.text('Auto-repay'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Auto-repay'));
    expect(auto, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loan detail displays unavailable state for missing host data', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoanDetailPage(adapter: _LoanAdapter(), loanId: 'preview-loan'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Loan details unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('repayment uses host amount and confirms only host result', (
    tester,
  ) async {
    _useMobileViewport(tester);
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(
        nextInstallmentKobo: 252500,
        fullPayoffKobo: 505000,
        earlyRepaymentSavingsKobo: 1000,
        canRepay: true,
      ),
      repayment: const LoanRepaymentResult(
        outcome: LoanRepaymentOutcome.success,
        message: 'Host repayment confirmation',
        receiptReference: 'Host repayment reference',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoanRepaymentPage(adapter: adapter, loanId: 'host-loan-id'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Early repayment savings'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Confirm and continue to PIN'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.textContaining('Next instalment'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Confirm and continue to PIN'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm and continue to PIN'));
    await tester.pumpAndSettle();
    expect(adapter.repaidAmountKobo, 252500);
    expect(find.text('Repayment confirmed'), findsOneWidget);
    expect(find.textContaining('Host repayment reference'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('custom repayment amount validates and host errors are explicit',
      (
    tester,
  ) async {
    _useMobileViewport(tester);
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(canRepay: true),
      failRepayment: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoanRepaymentPage(adapter: adapter, loanId: 'host-loan-id'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom amount'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '0');
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Confirm and continue to PIN'),
          )
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), '40.75');
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Confirm and continue to PIN'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm and continue to PIN'));
    await tester.pumpAndSettle();
    expect(adapter.repaidAmountKobo, 4075);
    expect(find.text('Repayment not confirmed'), findsOneWidget);
    expect(
        find.textContaining('host PIN service is unavailable'), findsOneWidget);
  });

  testWidgets('host insufficient-funds state is shown without success claim', (
    tester,
  ) async {
    _useMobileViewport(tester, width: 320, height: 720);
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(
        nextInstallmentKobo: 20000,
        canRepay: true,
      ),
      repayment: const LoanRepaymentResult(
        outcome: LoanRepaymentOutcome.insufficientFunds,
        message: 'Host supplied insufficient-funds message',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoanRepaymentPage(adapter: adapter, loanId: 'host-loan-id'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Next instalment'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Confirm and continue to PIN'),
      140,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm and continue to PIN'));
    await tester.pumpAndSettle();
    expect(find.text('Insufficient funds'), findsOneWidget);
    expect(find.text('Repayment confirmed'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('auto-repay consent saves only after host confirmation', (
    tester,
  ) async {
    _useMobileViewport(tester);
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(
        autoRepayEnabled: false,
        nextDebitDateLabel: 'Host debit date',
        canManageAutoRepay: true,
      ),
      autoRepayResult: const LoanAutoRepayResult(enabled: true),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AutoRepaySettingsPage(
          adapter: adapter,
          loanId: 'host-loan-id',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host debit date'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(adapter.savedAutoRepayValue, isTrue);
    expect(find.text('Auto-repay setting saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('auto-repay without host consent data stays unavailable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AutoRepaySettingsPage(
          adapter: _LoanAdapter(detail: const LoanDetailSnapshot()),
          loanId: 'host-loan-id',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SwitchListTile), findsNothing);
    expect(find.text('Auto-repay setting unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _useMobileViewport(
  WidgetTester tester, {
  double width = 390,
  double height = 844,
}) {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

class _LoanAdapter implements InstantLoanAdapter {
  _LoanAdapter({
    this.detail,
    this.repayment,
    this.failRepayment = false,
    this.autoRepayResult,
  });

  final LoanDetailSnapshot? detail;
  final LoanRepaymentResult? repayment;
  final bool failRepayment;
  final LoanAutoRepayResult? autoRepayResult;
  int? repaidAmountKobo;
  bool? savedAutoRepayValue;

  @override
  Future<LoanEligibilitySnapshot?> loadEligibility() async => null;

  @override
  Future<ActiveLoanSnapshot?> loadActiveLoan() async => null;

  @override
  Future<LoanQuoteSnapshot?> quoteLoan({
    required int amountKobo,
    required int tenor,
  }) async =>
      null;

  @override
  Future<LoanApplicationResult?> submitApplication({
    required String quoteId,
    required String agreementVersion,
  }) async =>
      null;

  @override
  Future<LoanDetailSnapshot?> loadLoanDetail({required String loanId}) async =>
      detail;

  @override
  Future<LoanRepaymentResult?> repayLoan({
    required String loanId,
    required int amountKobo,
  }) async {
    repaidAmountKobo = amountKobo;
    if (failRepayment) {
      throw const LoanHostUnavailable(
        'The host PIN service is unavailable in preview.',
      );
    }
    return repayment;
  }

  @override
  Future<LoanAutoRepayResult?> setAutoRepay({
    required String loanId,
    required bool enabled,
  }) async {
    savedAutoRepayValue = enabled;
    return autoRepayResult;
  }

  @override
  Future<LoanHardshipResult?> submitHardship({
    required String loanId,
    required String reason,
    required String message,
  }) async =>
      null;

  @override
  Future<LoanHistorySnapshot?> loadLoanHistory() async => null;

  @override
  Future<LoanAboutSnapshot?> loadLoanAbout() async => null;
}
