// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_instant_loan/sixth_instant_loan.dart';

void main() {
  testWidgets('hardship form uses host reasons and confirms host result', (
    tester,
  ) async {
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(canRequestHelp: true),
      hardship: const LoanHardshipResult(
        requestReceived: true,
        reference: 'Host case reference',
        responseTimeLabel: 'Host response time',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: LoanTheme.light(),
        home: LoanHardshipPage(
          adapter: adapter,
          loanId: 'host-loan',
          copy: _copy().hardship,
          reasonOptions: const ['Income changed'],
          responseTimeLabel: 'Host response time',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Document attachments unavailable'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Income changed').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'I need more time.');
    await tester.pump();
    await tester.ensureVisible(find.text('Submit request'));
    await tester.tap(find.text('Submit request'));
    await tester.pumpAndSettle();
    expect(adapter.submittedReason, 'Income changed');
    expect(adapter.submittedMessage, 'I need more time.');
    expect(find.text('Request received'), findsOneWidget);
    expect(find.textContaining('Host case reference'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hardship stays disabled without approved reason options', (
    tester,
  ) async {
    final adapter = _LoanAdapter(
      detail: const LoanDetailSnapshot(canRequestHelp: true),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LoanHardshipPage(
          adapter: adapter,
          loanId: 'host-loan',
          copy: _copy().hardship,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Approved hardship reasons unavailable'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(adapter.submittedReason, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hardship request unavailable without host eligibility', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoanHardshipPage(
          adapter: _LoanAdapter(),
          loanId: 'host-loan',
          copy: _copy().hardship,
          reasonOptions: const ['Income changed'],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hardship request unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history shows host loans and limit history; opens supplied id', (
    tester,
  ) async {
    final adapter = _LoanAdapter(
      history: const LoanHistorySnapshot(
        loans: [
          LoanHistoryItem(
            loanId: 'host-loan-id',
            statusLabel: 'Host status',
            totalRepaymentKobo: 505000,
            dateLabel: 'Host date',
          ),
        ],
        limitHistory: [
          LoanLimitHistoryItem(
            label: 'Host limit step',
            amountKobo: 1000000,
            dateLabel: 'Host limit date',
          ),
        ],
      ),
    );
    var opened = '';
    await tester.pumpWidget(
      MaterialApp(
        theme: LoanTheme.dark(),
        home: LoanHistoryPage(
          adapter: adapter,
          copy: _copy().history,
          onOpenLoan: (id) => opened = id,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host status'), findsOneWidget);
    expect(find.text('Host limit step'), findsOneWidget);
    await tester.tap(find.byTooltip('Open loan details'));
    expect(opened, 'host-loan-id');
    expect(tester.takeException(), isNull);
  });

  testWidgets('history supports host empty and unavailable states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoanHistoryPage(adapter: _LoanAdapter(), copy: _copy().history),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Loan history unavailable'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: LoanHistoryPage(
          key: const ValueKey('empty-history'),
          adapter: _LoanAdapter(history: const LoanHistorySnapshot()),
          copy: _copy().history,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No past loans'), findsOneWidget);
    expect(find.text('Limit history has not been supplied.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('about shows documented privacy copy and host lender details', (
    tester,
  ) async {
    _useMobileViewport(tester);
    final adapter = _LoanAdapter(
      about: const LoanAboutSnapshot(
        lender: LoanLenderIdentity(
          companyName: 'Host lender',
          partnerName: 'Host partner',
          companyRegistration: 'Host company registration',
          partnerRegistration: 'Host partner registration',
          registrationStatus: 'Host registration status',
        ),
        complaintRoute: 'Host complaint channel',
        regulatorName: 'Host regulator',
      ),
    );
    var contacted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: LoanAboutPage(
          adapter: adapter,
          copy: _copy().about,
          onContactSupport: () => contacted = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Host lender'), findsOneWidget);
    expect(find.text('Host partner'), findsOneWidget);
    expect(find.textContaining('does not access your contacts or photos'),
        findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    final contactButton = find.widgetWithText(TextButton, 'Contact support');
    await tester.tap(contactButton);
    expect(contacted, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('about keeps complaint and regulator fields unavailable', (
    tester,
  ) async {
    _useMobileViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: LoanAboutPage(
          adapter: _LoanAdapter(about: const LoanAboutSnapshot()),
          copy: _copy().about,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Not provided by the host'), findsAtLeastNWidgets(5));
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    final contactButton = find.widgetWithText(TextButton, 'Contact support');
    expect(contactButton, findsOneWidget);
    expect(tester.widget<TextButton>(contactButton).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}

void _useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

InstantLoanBatch4Copy _copy() => const InstantLoanBatch4Copy(
      hardship: LoanHardshipCopy(
        title: 'Ask for hardship support',
        loadingTitle: 'Loading hardship support',
        loadingBody: 'Loading loan information',
        loadErrorTitle: 'Hardship support could not be loaded',
        loadErrorBody: 'Try again later',
        retry: 'Try again',
        unavailableTitle: 'Hardship request unavailable',
        unavailableBody: 'Host hardship options unavailable',
        reason: 'Reason for your request',
        reasonHint: 'Choose an approved reason',
        reasonOptionsUnavailable: 'Approved hardship reasons unavailable',
        reasonRequired: 'Choose a reason',
        message: 'Tell us what has changed',
        messageHint: 'A person will review your request',
        messageRequired: 'Enter a message',
        reasonLength: 'Use 5 to 300 characters for the reason',
        attachmentsUnavailable: 'Document attachments unavailable',
        responseTime: _previewResponseTime,
        submit: 'Submit request',
        submitting: 'Submitting request...',
        notConfirmedTitle: 'Request not confirmed',
        notConfirmedBody: 'The request was not confirmed',
        receivedTitle: 'Request received',
        receivedBody: 'A person will review the request',
        beingConfirmedTitle: 'Request being confirmed',
        beingConfirmedBody: 'Check again before submitting another request',
      ),
      history: LoanHistoryCopy(
        title: 'Loan history',
        loadingTitle: 'Loading loan history',
        loadingBody: 'Loading previous loans',
        loadErrorTitle: 'Loan history could not be loaded',
        loadErrorBody: 'Try again later',
        retry: 'Try again',
        unavailableTitle: 'Loan history unavailable',
        unavailableBody: 'The host has not supplied loan history',
        emptyTitle: 'No past loans',
        emptyBody: 'Previous loans appear here',
        loan: 'Loan',
        status: 'Status',
        totalRepayment: 'Total repayment',
        openLoan: 'Open loan details',
        limitHistory: 'Limit history',
        limitHistoryUnavailable: 'Limit history has not been supplied.',
        amountUnavailable: 'Not supplied',
      ),
      about: LoanAboutCopy(
        title: 'Lender information and privacy',
        loadingTitle: 'Loading lender information',
        loadingBody: 'Loading approved information',
        loadErrorTitle: 'Lender information could not be loaded',
        loadErrorBody: 'Try again later',
        retry: 'Try again',
        unavailableTitle: 'Lender information unavailable',
        unavailableBody:
            'The host has not supplied approved lender information',
        lender: 'Lender identity',
        lenderCompany: 'Lending company',
        lendingPartner: 'Lending partner',
        companyRegistration: 'Company registration',
        partnerRegistration: 'Partner registration',
        registrationStatus: 'Registration status',
        notProvided: 'Not provided by the host',
        dataUseTitle: 'Information used',
        dataUseBody:
            'Eligibility may use verified identity and account history.',
        dataNeverAccessedTitle: 'Information never accessed',
        dataNeverAccessedBody:
            'This product does not access your contacts or photos.',
        complaintsTitle: 'Complaints and support',
        regulatorTitle: 'Regulator information',
        contactSupport: 'Contact support',
        supportUnavailable: 'Support details unavailable',
      ),
    );

String _previewResponseTime(String time) => 'Expected response time: $time';

class _LoanAdapter implements InstantLoanAdapter {
  _LoanAdapter({this.detail, this.hardship, this.history, this.about});

  final LoanDetailSnapshot? detail;
  final LoanHardshipResult? hardship;
  final LoanHistorySnapshot? history;
  final LoanAboutSnapshot? about;
  String? submittedReason;
  String? submittedMessage;

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
  }) async {
    submittedReason = reason;
    submittedMessage = message;
    return hardship;
  }

  @override
  Future<LoanHistorySnapshot?> loadLoanHistory() async => history;

  @override
  Future<LoanAboutSnapshot?> loadLoanAbout() async => about;
}
