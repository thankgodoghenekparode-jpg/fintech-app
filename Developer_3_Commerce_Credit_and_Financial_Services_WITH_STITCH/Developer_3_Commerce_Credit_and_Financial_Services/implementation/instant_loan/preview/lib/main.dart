// ignore: deprecated_member_use // SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:sixth_instant_loan/sixth_instant_loan.dart';

void main() => runApp(const InstantLoanPreviewApp());

class InstantLoanPreviewApp extends StatefulWidget {
  const InstantLoanPreviewApp({super.key});

  @override
  State<InstantLoanPreviewApp> createState() => _InstantLoanPreviewAppState();
}

class _InstantLoanPreviewAppState extends State<InstantLoanPreviewApp> {
  final _adapter = const _PreviewLoanAdapter();
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _dark = false;

  void _toggleTheme() => setState(() => _dark = !_dark);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Instant Loan Preview',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: LoanTheme.light(),
        darkTheme: LoanTheme.dark(),
        themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/preview',
        onGenerateRoute: _route,
        builder: (context, child) => Column(
          children: [
            SafeArea(
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
                        'NON-PRODUCTION - Host APIs unavailable - No loan data supplied',
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
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
  Route<void> _route(RouteSettings settings) {
    final path = Uri.parse(settings.name ?? '/preview').path;
    late final Widget page;
    final loanRoute = RegExp(r'^/borrow/loans/([^/]+)(?:/(repay|auto|help))?$')
        .firstMatch(path);
    if (loanRoute != null) {
      final loanId = loanRoute.group(1)!;
      switch (loanRoute.group(2)) {
        case 'repay':
          page = LoanRepaymentPage(
            adapter: _adapter,
            loanId: loanId,
            onThemeToggle: _toggleTheme,
          );
        case 'auto':
          page = AutoRepaySettingsPage(
            adapter: _adapter,
            loanId: loanId,
            onThemeToggle: _toggleTheme,
          );
        case 'help':
          page = Builder(
            builder: (_) => LoanHardshipPage(
              adapter: _adapter,
              loanId: loanId,
              copy: _batch4Copy().hardship,
              reasonOptions: const [],
              onThemeToggle: _toggleTheme,
            ),
          );
        default:
          page = LoanDetailPage(
            adapter: _adapter,
            loanId: loanId,
            onRepay: () => _navigatorKey.currentState?.pushNamed(
              '/borrow/loans/$loanId/repay',
            ),
            onAutoRepay: () => _navigatorKey.currentState?.pushNamed(
              '/borrow/loans/$loanId/auto',
            ),
            onNeedHelp: () => _navigatorKey.currentState?.pushNamed(
              '/borrow/loans/$loanId/help',
            ),
            onThemeToggle: _toggleTheme,
          );
      }
    } else if (path == '/borrow') {
      page = BorrowHomePage(
        adapter: _adapter,
        onGetLoan: () => _navigatorKey.currentState?.pushNamed('/borrow/new'),
        onOpenActiveLoan: () => _navigatorKey.currentState?.pushNamed(
          '/borrow/loans/preview-loan',
        ),
        onHowLoansWork: () =>
            _navigatorKey.currentState?.pushNamed('/borrow/eligibility'),
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/borrow/eligibility') {
      page = EligibilityAndLimitPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
        onPrivacy: () => showDialog<void>(
          context: _navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: const Text('Privacy promise'),
            content: const Text(
              'The product documentation states that contacts and photos are not accessed. Eligibility information and lender data are supplied by the host.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    } else if (path == '/borrow/new') {
      page = ChooseAmountAndTenorPage(
        adapter: _adapter,
        onThemeToggle: _toggleTheme,
        onContinueWithQuote: (quote) => _navigatorKey.currentState?.pushNamed(
          '/borrow/affordability',
          arguments: quote,
        ),
      );
    } else if (path == '/borrow/affordability') {
      page = AffordabilityCheckPage(
        quote: settings.arguments is LoanQuoteSnapshot
            ? settings.arguments as LoanQuoteSnapshot
            : null,
        onContinue: settings.arguments is LoanQuoteSnapshot
            ? () => _navigatorKey.currentState?.pushNamed(
                  '/borrow/review',
                  arguments: settings.arguments,
                )
            : null,
        onChangeAmount: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/borrow/new'),
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/borrow/review') {
      page = ReviewAndAgreementPage(
        adapter: _adapter,
        quote: settings.arguments is LoanQuoteSnapshot
            ? settings.arguments as LoanQuoteSnapshot
            : null,
        onResult: (result) => _navigatorKey.currentState?.pushNamed(
          '/borrow/result',
          arguments: result,
        ),
        onReloadAgreement: () =>
            _navigatorKey.currentState?.pushReplacementNamed('/borrow/new'),
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/borrow/result') {
      page = LoanResultPage(
        result: settings.arguments is LoanApplicationResult
            ? settings.arguments as LoanApplicationResult
            : null,
        onViewLoan: (loanId) => _navigatorKey.currentState?.pushNamed(
          '/borrow/loans/$loanId',
        ),
        onThemeToggle: _toggleTheme,
      );
    } else if (path == '/borrow/history') {
      page = Builder(
        builder: (_) => LoanHistoryPage(
          adapter: _adapter,
          copy: _batch4Copy().history,
          onOpenLoan: (loanId) => _navigatorKey.currentState?.pushNamed(
            '/borrow/loans/$loanId',
          ),
          onThemeToggle: _toggleTheme,
        ),
      );
    } else if (path == '/borrow/about') {
      page = Builder(
        builder: (_) => LoanAboutPage(
          adapter: _adapter,
          copy: _batch4Copy().about,
          onThemeToggle: _toggleTheme,
        ),
      );
    } else {
      page = _PreviewDirectory(
        onThemeToggle: _toggleTheme,
        onOpen: (route) => _navigatorKey.currentState?.pushNamed(route),
      );
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}

class _PreviewDirectory extends StatelessWidget {
  const _PreviewDirectory({required this.onThemeToggle, required this.onOpen});
  final VoidCallback onThemeToggle;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Instant Loan preview'),
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
              'Implemented screens: S-LOAN-001 to S-LOAN-012',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Preview only. No financial data or loan services are connected.',
            ),
            const SizedBox(height: 16),
            _ScreenLink(
              title: 'S-LOAN-001 · Borrow home',
              route: '/borrow',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-002 · Eligibility and limit',
              route: '/borrow/eligibility',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-003 · Choose amount and tenor',
              route: '/borrow/new',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-004 · Affordability check',
              route: '/borrow/affordability',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-005 · Review and agreement',
              route: '/borrow/review',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-006 · Loan application result',
              route: '/borrow/result',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-007 - Loan detail',
              route: '/borrow/loans/preview-loan',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-008 - Repay',
              route: '/borrow/loans/preview-loan/repay',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-009 - Auto-repay settings',
              route: '/borrow/loans/preview-loan/auto',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-010 - Hardship request',
              route: '/borrow/loans/preview-loan/help',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-011 - Loan history',
              route: '/borrow/history',
              onOpen: onOpen,
            ),
            _ScreenLink(
              title: 'S-LOAN-012 - Lender information and privacy',
              route: '/borrow/about',
              onOpen: onOpen,
            ),
          ],
        ),
      );
}

class _ScreenLink extends StatelessWidget {
  const _ScreenLink({
    required this.title,
    required this.route,
    required this.onOpen,
  });
  final String title;
  final String route;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onOpen(route),
        ),
      );
}

class _PreviewLoanAdapter implements InstantLoanAdapter {
  const _PreviewLoanAdapter();

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
  }) =>
      Future<LoanApplicationResult?>.error(
        const LoanHostUnavailable(
          'Application submission requires a connected host and PIN authorization service.',
        ),
      );

  @override
  Future<LoanDetailSnapshot?> loadLoanDetail({required String loanId}) async =>
      null;

  @override
  Future<LoanRepaymentResult?> repayLoan({
    required String loanId,
    required int amountKobo,
  }) =>
      Future<LoanRepaymentResult?>.error(
        const LoanHostUnavailable(
          'Repayment is unavailable in this non-production preview.',
        ),
      );

  @override
  Future<LoanAutoRepayResult?> setAutoRepay({
    required String loanId,
    required bool enabled,
  }) =>
      Future<LoanAutoRepayResult?>.error(
        const LoanHostUnavailable(
          'Auto-repay consent updates are unavailable in this non-production preview.',
        ),
      );

  @override
  Future<LoanHardshipResult?> submitHardship({
    required String loanId,
    required String reason,
    required String message,
  }) =>
      Future<LoanHardshipResult?>.error(
        const LoanHostUnavailable(
          'Hardship requests are unavailable in this non-production preview.',
        ),
      );

  @override
  Future<LoanHistorySnapshot?> loadLoanHistory() async => null;

  @override
  Future<LoanAboutSnapshot?> loadLoanAbout() async => null;
}

// Preview-only copy mirrors implementation/localization/instant_loan_en.arb.
// The host injects its generated central-localization implementation.
InstantLoanBatch4Copy _batch4Copy() => const InstantLoanBatch4Copy(
      hardship: LoanHardshipCopy(
        title: 'Ask for hardship support',
        loadingTitle: 'Loading hardship support',
        loadingBody: 'Your loan information is being loaded.',
        loadErrorTitle: 'Hardship support could not be loaded',
        loadErrorBody: 'Try again later or contact support.',
        retry: 'Try again',
        unavailableTitle: 'Hardship request unavailable',
        unavailableBody:
            'The host has not supplied this loan or its approved hardship options.',
        reason: 'Reason for your request',
        reasonHint: 'Choose an option supplied by your lender.',
        reasonOptionsUnavailable:
            'Approved hardship reasons have not been supplied by the host.',
        reasonRequired: 'Choose a reason to continue.',
        message: 'Tell us what has changed',
        messageHint: 'A person will review your request.',
        messageRequired: 'Enter a message for the hardship team.',
        reasonLength: 'Use 5 to 300 characters for the reason.',
        attachmentsUnavailable:
            'Document attachments are unavailable until a host upload contract is provided.',
        responseTime: _previewResponseTime,
        submit: 'Submit request',
        submitting: 'Submitting request...',
        notConfirmedTitle: 'Request not confirmed',
        notConfirmedBody:
            'The host has not confirmed that your request was received. Check your loan before trying again.',
        receivedTitle: 'Request received',
        receivedBody: 'A person will review the hardship request.',
        beingConfirmedTitle: 'Request being confirmed',
        beingConfirmedBody:
            'The request status has not been confirmed yet. Check again before submitting another request.',
      ),
      history: LoanHistoryCopy(
        title: 'Loan history',
        loadingTitle: 'Loading loan history',
        loadingBody: 'Your previous loans are being loaded.',
        loadErrorTitle: 'Loan history could not be loaded',
        loadErrorBody: 'Try again later or contact support.',
        retry: 'Try again',
        unavailableTitle: 'Loan history unavailable',
        unavailableBody: 'The host has not supplied your loan history.',
        emptyTitle: 'No past loans',
        emptyBody:
            'Completed or previous loans will appear here when supplied by the host.',
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
        loadingBody: 'Approved lender and privacy information is being loaded.',
        loadErrorTitle: 'Lender information could not be loaded',
        loadErrorBody: 'Try again later or contact support.',
        retry: 'Try again',
        unavailableTitle: 'Lender information unavailable',
        unavailableBody:
            'The host has not supplied approved lender information.',
        lender: 'Lender identity',
        lenderCompany: 'Lending company',
        lendingPartner: 'Lending partner',
        companyRegistration: 'Company registration',
        partnerRegistration: 'Partner registration',
        registrationStatus: 'Registration status',
        notProvided: 'Not provided by the host',
        dataUseTitle: 'Information used',
        dataUseBody:
            'Eligibility may use verified identity, account history and optional credit bureau information.',
        dataNeverAccessedTitle: 'Information never accessed',
        dataNeverAccessedBody:
            'This product does not access your contacts or photos.',
        complaintsTitle: 'Complaints and support',
        regulatorTitle: 'Regulator information',
        contactSupport: 'Contact support',
        supportUnavailable:
            'A support contact has not been supplied by the host.',
      ),
    );

String _previewResponseTime(String time) => 'Expected response time: $time';
