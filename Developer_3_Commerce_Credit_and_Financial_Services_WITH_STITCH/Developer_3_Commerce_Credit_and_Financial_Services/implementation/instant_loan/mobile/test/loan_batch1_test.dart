import 'dart:async';

// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_instant_loan/sixth_instant_loan.dart';

void main() {
  group('Borrow home', () {
    testWidgets('shows host eligibility, lender details and active loan', (
      tester,
    ) async {
      final adapter = _LoanAdapter(
        eligibility: const LoanEligibilitySnapshot(
          eligible: true,
          canApply: true,
          limitKobo: 25000000,
          statusLabel: 'Host eligibility status',
          lender: LoanLenderIdentity(
            companyName: 'Host lender',
            partnerName: 'Host partner',
            companyRegistration: 'Host registration',
            registrationStatus: 'Host registration status',
          ),
        ),
        activeLoan: const ActiveLoanSnapshot(
          activeLoan: ActiveLoanSummary(
            status: 'Host loan status',
            balanceKobo: 1000000,
            nextDueLabel: 'Host due date',
          ),
        ),
      );
      var getLoanOpened = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: LoanTheme.light(),
          home: BorrowHomePage(
            adapter: adapter,
            onGetLoan: () => getLoanOpened = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Borrow'), findsOneWidget);
      expect(find.text('₦250,000.00'), findsOneWidget);
      expect(find.text('Host lender'), findsOneWidget);
      expect(find.textContaining('Host loan status'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Get a loan'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Get a loan'));
      expect(getLoanOpened, isTrue);
    });

    testWidgets('shows unavailable and error states without invented values', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: BorrowHomePage(adapter: _LoanAdapter())),
      );
      await tester.pumpAndSettle();
      expect(find.text('Eligibility unavailable'), findsOneWidget);
      expect(find.text('Your loan limit'), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          home: BorrowHomePage(
            key: const ValueKey('failed-home'),
            adapter: _LoanAdapter(failEligibility: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Eligibility could not be loaded'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('eligibility explains host limit steps and privacy promise', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EligibilityAndLimitPage(
          adapter: _LoanAdapter(
            eligibility: const LoanEligibilitySnapshot(
              limitSteps: [
                LoanLimitStep(label: 'Host current step', isCurrent: true),
                LoanLimitStep(label: 'Host next step'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host current step'), findsOneWidget);
    expect(find.text('Host next step'), findsOneWidget);
    expect(find.textContaining('Repaying on time can help'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('affordability shows host comparison, caution and navigation', (
    tester,
  ) async {
    var continued = false;
    var changed = false;
    final quote = const LoanQuoteSnapshot(
      quoteId: 'host-quote',
      affordability: LoanAffordabilitySnapshot(
        repaymentKobo: 500000,
        typicalMonthlyInflowsKobo: 4000000,
        repaymentFraction: .125,
        message: 'Host affordability message',
        cautionText: 'Host caution',
        hasEnoughData: true,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AffordabilityCheckPage(
          quote: quote,
          onContinue: () => continued = true,
          onChangeAmount: () => changed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host affordability message'), findsOneWidget);
    expect(find.text('Host caution'), findsOneWidget);
    expect(find.text(formatLoanMoney(500000)), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.tap(find.text('Change amount'));
    expect(continued, isTrue);
    expect(changed, isTrue);
  });

  testWidgets('affordability with insufficient host data cannot continue', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AffordabilityCheckPage(
          quote:
              const LoanQuoteSnapshot(quoteId: 'quote-without-affordability'),
          onContinue: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Affordability information unavailable'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('agreement requires acceptance and submits versioned terms', (
    tester,
  ) async {
    _useMobileViewport(tester);
    final pending = Completer<LoanApplicationResult?>();
    final adapter = _LoanAdapter(applicationCompleter: pending);
    LoanApplicationResult? returned;
    final page = ReviewAndAgreementPage(
      adapter: adapter,
      quote: _reviewQuote(),
      onResult: (value) => returned = value,
    );
    await tester.pumpWidget(MaterialApp(home: page));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Full loan agreement'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Full loan agreement'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Host full agreement text'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Host full agreement text'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Accept and continue to PIN'),
          )
          .onPressed,
      isNull,
    );
    await tester.scrollUntilVisible(
      find.text('I have read and accept this agreement.'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Accept and continue to PIN'),
        )
        .onPressed!
        .call();
    await tester.pump();
    expect(
      tester.widget<Checkbox>(find.byType(Checkbox)).value,
      isTrue,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(adapter.applicationQuoteId, 'host-quote');
    expect(adapter.applicationAgreementVersion, 'host-version');
    pending.complete(
      const LoanApplicationResult(outcome: LoanApplicationOutcome.pending),
    );
    await tester.pumpAndSettle();
    expect(returned?.outcome, LoanApplicationOutcome.pending);
    expect(tester.takeException(), isNull);
  });

  testWidgets('agreement outdated and host-unavailable states are explicit', (
    tester,
  ) async {
    _useMobileViewport(tester);
    var reloaded = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ReviewAndAgreementPage(
          adapter: _LoanAdapter(agreementOutdated: true),
          quote: _reviewQuote(),
          onReloadAgreement: () => reloaded = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('I have read and accept this agreement.'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Accept and continue to PIN'),
        )
        .onPressed!
        .call();
    await tester.pumpAndSettle();
    expect(find.text('Agreement terms changed'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Reload agreement'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Reload agreement'));
    expect(reloaded, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewAndAgreementPage(
          key: const ValueKey('unavailable-application'),
          adapter: _LoanAdapter(failApplication: true),
          quote: _reviewQuote(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('I have read and accept this agreement.'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Accept and continue to PIN'),
        )
        .onPressed!
        .call();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Application not confirmed'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('host PIN service is not connected'),
        findsOneWidget);
  });

  testWidgets('result screen reflects host success, pending and decline states',
      (
    tester,
  ) async {
    var viewedLoanId = '';
    await tester.pumpWidget(
      MaterialApp(
        home: LoanResultPage(
          result: const LoanApplicationResult(
            outcome: LoanApplicationOutcome.success,
            amountCreditedKobo: 700000,
            loanId: 'host-loan-id',
          ),
          onViewLoan: (id) => viewedLoanId = id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Loan disbursement confirmed'), findsOneWidget);
    expect(find.text(formatLoanMoney(700000)), findsOneWidget);
    await tester.tap(find.text('View loan'));
    expect(viewedLoanId, 'host-loan-id');

    await tester.pumpWidget(
      MaterialApp(
        home: LoanResultPage(
          key: const ValueKey('pending-result'),
          result: const LoanApplicationResult(
            outcome: LoanApplicationOutcome.pending,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Your loan is being processed'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: LoanResultPage(
          key: const ValueKey('declined-result'),
          result: const LoanApplicationResult(
            outcome: LoanApplicationOutcome.declined,
            reason: 'Host decline reason',
            tryAgainDateLabel: 'Host retry date',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host decline reason'), findsOneWidget);
    expect(find.text('Host retry date'), findsOneWidget);
  });

  testWidgets('result without host outcome remains unavailable',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoanResultPage()));
    await tester.pumpAndSettle();
    expect(find.text('Application result unavailable'), findsOneWidget);
    expect(find.textContaining('has not supplied an application outcome'),
        findsOneWidget);
  });

  testWidgets(
    'amount and tenor request a server quote and show supplied costs',
    (tester) async {
      final adapter = _LoanAdapter(
        eligibility: const LoanEligibilitySnapshot(
          eligible: true,
          canApply: true,
          minimumAmountKobo: 100000,
          maximumAmountKobo: 5000000,
          limitKobo: 5000000,
          tenors: [LoanTenorOption(value: 1, label: 'Host tenor')],
        ),
        quote: const LoanQuoteSnapshot(
          quoteId: 'host-quote-id',
          interestKobo: 12500,
          feesKobo: 2500,
          totalRepaymentKobo: 515000,
          installments: [
            LoanInstallmentQuote(
              amountKobo: 515000,
              dueDateLabel: 'Host due date',
            ),
          ],
        ),
      );
      var continued = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: LoanTheme.light(),
          home: ChooseAmountAndTenorPage(
            adapter: adapter,
            onContinue: () => continued = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '5000');
      await tester.tap(find.text('Host tenor'));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(adapter.quotedAmountKobo, 500000);
      expect(adapter.quotedTenor, 1);
      expect(find.text(formatLoanMoney(12500)), findsOneWidget);
      expect(find.text(formatLoanMoney(2500)), findsOneWidget);
      expect(find.text(formatLoanMoney(515000)), findsNWidgets(2));
      expect(find.text('Host due date'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(continued, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('narrow amount screen has no overflow and rejects out-of-range', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ChooseAmountAndTenorPage(
          adapter: _LoanAdapter(
            eligibility: const LoanEligibilitySnapshot(
              eligible: true,
              canApply: true,
              minimumAmountKobo: 100000,
              maximumAmountKobo: 200000,
              tenors: [LoanTenorOption(value: 1, label: 'Host monthly tenor')],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '3000');
    await tester.tap(find.text('Host monthly tenor'));
    await tester.pumpAndSettle();
    expect(
      find.text('Enter an amount within the available loan range.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('quote unavailable and quote errors stay explicit', (
    tester,
  ) async {
    final noQuote = _LoanAdapter(
      eligibility: const LoanEligibilitySnapshot(
        eligible: true,
        canApply: true,
        minimumAmountKobo: 100,
        maximumAmountKobo: 100000,
        tenors: [LoanTenorOption(value: 1, label: 'Host tenor')],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(home: ChooseAmountAndTenorPage(adapter: noQuote)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '50');
    await tester.tap(find.text('Host tenor'));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Cost summary unavailable'), findsOneWidget);

    final failedQuote = _LoanAdapter(
      eligibility: const LoanEligibilitySnapshot(
        eligible: true,
        canApply: true,
        minimumAmountKobo: 100,
        maximumAmountKobo: 100000,
        tenors: [LoanTenorOption(value: 1, label: 'Host tenor')],
      ),
      failQuote: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: ChooseAmountAndTenorPage(
          key: const ValueKey('failed-loan-quote'),
          adapter: failedQuote,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '50');
    await tester.tap(find.text('Host tenor'));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Quote could not be loaded'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _LoanAdapter implements InstantLoanAdapter {
  _LoanAdapter({
    this.eligibility,
    this.activeLoan,
    this.quote,
    this.failEligibility = false,
    this.failQuote = false,
    this.applicationCompleter,
    this.failApplication = false,
    this.agreementOutdated = false,
  });

  final LoanEligibilitySnapshot? eligibility;
  final ActiveLoanSnapshot? activeLoan;
  final LoanQuoteSnapshot? quote;
  final bool failEligibility;
  final bool failQuote;
  final Completer<LoanApplicationResult?>? applicationCompleter;
  final bool failApplication;
  final bool agreementOutdated;
  String? applicationQuoteId;
  String? applicationAgreementVersion;
  int? quotedAmountKobo;
  int? quotedTenor;

  @override
  Future<LoanEligibilitySnapshot?> loadEligibility() async {
    if (failEligibility) throw StateError('eligibility failed');
    return eligibility;
  }

  @override
  Future<ActiveLoanSnapshot?> loadActiveLoan() async => activeLoan;

  @override
  Future<LoanQuoteSnapshot?> quoteLoan({
    required int amountKobo,
    required int tenor,
  }) async {
    quotedAmountKobo = amountKobo;
    quotedTenor = tenor;
    if (failQuote) throw StateError('quote failed');
    return quote;
  }

  @override
  Future<LoanApplicationResult?> submitApplication({
    required String quoteId,
    required String agreementVersion,
  }) async {
    applicationQuoteId = quoteId;
    applicationAgreementVersion = agreementVersion;
    if (agreementOutdated) throw const LoanAgreementOutdated();
    if (failApplication) {
      throw const LoanHostUnavailable(
        'The host PIN service is not connected in preview.',
      );
    }
    return applicationCompleter?.future;
  }

  @override
  Future<LoanDetailSnapshot?> loadLoanDetail({required String loanId}) async =>
      null;

  @override
  Future<LoanRepaymentResult?> repayLoan({
    required String loanId,
    required int amountKobo,
  }) async =>
      null;

  @override
  Future<LoanAutoRepayResult?> setAutoRepay({
    required String loanId,
    required bool enabled,
  }) async =>
      null;

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

LoanQuoteSnapshot _reviewQuote() => const LoanQuoteSnapshot(
      quoteId: 'host-quote',
      feesKobo: 15000,
      agreement: LoanAgreementSnapshot(
        version: 'host-version',
        totalRepaymentKobo: 515000,
        repaymentDateLabels: ['Host due date'],
        lateFeeLabel: 'Host late-fee terms',
        earlyRepaymentLabel: 'Host early-repayment terms',
        fullText: 'Host full agreement text',
        lender: LoanLenderIdentity(companyName: 'Host lender'),
      ),
    );

void _useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
