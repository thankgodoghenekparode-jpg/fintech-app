import 'dart:async';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:sixth_escrow/escrow.dart';

void main() => runApp(const EscrowPreviewApp());

class EscrowPreviewApp extends StatefulWidget {
  const EscrowPreviewApp({super.key});

  @override
  State<EscrowPreviewApp> createState() => _EscrowPreviewAppState();
}

class _EscrowPreviewAppState extends State<EscrowPreviewApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _homeAdapter = const _SyntheticEscrowHomeAdapter();
  final _termsAdapter = const _UnavailableEscrowTermsAdapter();
  final _inviteAdapter = const _SyntheticEscrowInviteAdapter();
  final _acceptAdapter = const _UnavailableEscrowAcceptAdapter();
  final _fundingAdapter = const _UnavailableEscrowFundingAdapter();
  final _dealDetailAdapter = const _UnavailableEscrowDealDetailAdapter();
  final _deliveryAdapter = const _UnavailableEscrowDeliveryAdapter();
  final _confirmationAdapter = const _UnavailableEscrowConfirmationAdapter();
  final _openDisputeAdapter = const _UnavailableEscrowOpenDisputeAdapter();
  final _disputeStatusAdapter = const _UnavailableEscrowDisputeStatusAdapter();
  final _cancellationAdapter = const _PreviewEscrowCancellationAdapter();
  final _receiptAdapter = const _PreviewEscrowReceiptAdapter();

  ThemeData _theme() {
    const scheme = ColorScheme.light(
      primary: Color(0xFF8E1B4A),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF6B57),
      onSecondary: Color(0xFF2B0A12),
      surface: Colors.white,
      error: Color(0xFFC62828),
      onError: Colors.white,
      onSurface: Color(0xFF1E1A1B),
      onSurfaceVariant: Color(0xFF5E5557),
      outline: Color(0xFFE4DEDC),
      primaryContainer: Color(0xFFF8E8EE),
      onPrimaryContainer: Color(0xFF731540),
      surfaceContainerLowest: Color(0xFFFAF8F7),
      surfaceContainer: Color(0xFFF1EDEB),
      surfaceContainerHighest: Color(0xFFF1EDEB),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFFAF8F7),
    );
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF8F7),
        foregroundColor: Color(0xFF1E1A1B),
        centerTitle: false,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium:
            base.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 24 / 16),
        bodySmall:
            base.textTheme.bodySmall?.copyWith(fontSize: 13, height: 18 / 13),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4DEDC)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4DEDC)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Route<void> _route(RouteSettings settings) {
    final name = settings.name ?? '/escrow';
    late final Widget page;
    final inviteMatch = RegExp(r'^/escrow/([^/]+)/invite$').firstMatch(name);
    final acceptMatch = RegExp(r'^/escrow/([^/]+)/accept$').firstMatch(name);
    final fundMatch = RegExp(r'^/escrow/([^/]+)/fund$').firstMatch(name);
    final deliveryMatch = RegExp(r'^/escrow/([^/]+)/deliver$').firstMatch(name);
    final confirmMatch = RegExp(r'^/escrow/([^/]+)/confirm$').firstMatch(name);
    final disputeStatusMatch =
        RegExp(r'^/escrow/([^/]+)/dispute/status$').firstMatch(name);
    final disputeMatch = RegExp(r'^/escrow/([^/]+)/dispute$').firstMatch(name);
    final cancelMatch = RegExp(r'^/escrow/([^/]+)/cancel$').firstMatch(name);
    final receiptMatch = RegExp(r'^/escrow/([^/]+)/receipt$').firstMatch(name);
    final detailMatch = RegExp(r'^/escrow/([^/]+)$').firstMatch(name);
    if (name == '/escrow/preview-directory') {
      page = _EscrowPreviewDirectoryPage(
        onOpen: (route) => _navigatorKey.currentState?.pushNamed<void>(route),
      );
    } else if (inviteMatch != null) {
      final dealId = inviteMatch.group(1)!;
      page = EscrowInviteNegotiatePage(
        dealId: dealId,
        adapter: _inviteAdapter,
        onReviewTerms: () => _navigatorKey.currentState?.pushNamed<void>(
          '/escrow/$dealId/accept',
        ),
      );
    } else if (acceptMatch != null) {
      final dealId = acceptMatch.group(1)!;
      page = EscrowAcceptTermsPage(
        dealId: dealId,
        adapter: _acceptAdapter,
        onProceedToFunding: () => _navigatorKey.currentState?.pushNamed<void>(
          '/escrow/$dealId/fund',
        ),
      );
    } else if (fundMatch != null) {
      page = EscrowFundDealPage(
        dealId: fundMatch.group(1)!,
        adapter: _fundingAdapter,
      );
    } else if (deliveryMatch != null) {
      page = EscrowSubmitDeliveryPage(
        dealId: deliveryMatch.group(1)!,
        adapter: _deliveryAdapter,
      );
    } else if (confirmMatch != null) {
      page = EscrowConfirmDeliveryPage(
        dealId: confirmMatch.group(1)!,
        adapter: _confirmationAdapter,
      );
    } else if (disputeStatusMatch != null) {
      page = EscrowDisputeStatusPage(
        dealId: disputeStatusMatch.group(1)!,
        adapter: _disputeStatusAdapter,
      );
    } else if (disputeMatch != null) {
      final dealId = disputeMatch.group(1)!;
      page = EscrowOpenDisputePage(
        dealId: dealId,
        adapter: _openDisputeAdapter,
        onSubmitted: () => _navigatorKey.currentState?.pushNamed<void>(
          '/escrow/$dealId/dispute/status',
        ),
      );
    } else if (cancelMatch != null) {
      page = EscrowCancelDealPage(
        dealId: cancelMatch.group(1)!,
        adapter: _cancellationAdapter,
      );
    } else if (receiptMatch != null) {
      page = EscrowReceiptRatingPage(
        dealId: receiptMatch.group(1)!,
        adapter: _receiptAdapter,
      );
    } else if (detailMatch != null && name != '/escrow/new') {
      final dealId = detailMatch.group(1)!;
      page = EscrowDealDetailPage(
        dealId: dealId,
        adapter: _dealDetailAdapter,
        onAction: (action) {
          final route = switch (action) {
            EscrowDealAction.invite => '/escrow/$dealId/invite',
            EscrowDealAction.accept => '/escrow/$dealId/accept',
            EscrowDealAction.fund => '/escrow/$dealId/fund',
            EscrowDealAction.submitDelivery => '/escrow/$dealId/deliver',
            EscrowDealAction.confirmDelivery => '/escrow/$dealId/confirm',
            EscrowDealAction.openDispute => '/escrow/$dealId/dispute',
            EscrowDealAction.cancelDeal => '/escrow/$dealId/cancel',
            EscrowDealAction.viewReceipt => '/escrow/$dealId/receipt',
            EscrowDealAction.other => null,
          };
          if (route != null) _navigatorKey.currentState?.pushNamed<void>(route);
        },
      );
    } else if (name == '/escrow/new') {
      page = EscrowCreateDealPage(
        onContinue: (draft) async {
          unawaited(_navigatorKey.currentState!.pushNamed<void>(
            '/escrow/new/terms',
            arguments: _TermsRouteArguments(draft: draft),
          ));
        },
      );
    } else if (name == '/escrow/new/terms') {
      final args = settings.arguments is _TermsRouteArguments
          ? settings.arguments! as _TermsRouteArguments
          : const _TermsRouteArguments(draft: _previewDraft);
      page = EscrowFeeTermsPage(
        adapter: _termsAdapter,
        draft: args.draft,
        dealId: null,
        onContinue: (_) async {
          _messengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text(
                'A host-created deal ID is required before inviting a counterparty.',
              ),
            ),
          );
        },
      );
    } else {
      page = EscrowHomePage(
        adapter: _homeAdapter,
        onNewDeal: () =>
            _navigatorKey.currentState?.pushNamed<void>('/escrow/new'),
        onOpenDeal: (deal) => _navigatorKey.currentState?.pushNamed<void>(
          '/escrow/${deal.id}',
        ),
      );
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _PreviewShell(
        child: page,
        onOpenDirectory: () => _navigatorKey.currentState?.pushNamed<void>(
          '/escrow/preview-directory',
        ),
        onOutsidePreview: () => _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text(const EscrowCopy().navOutsidePreview)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Escrow · Non-production preview',
        navigatorKey: _navigatorKey,
        scaffoldMessengerKey: _messengerKey,
        theme: _theme(),
        initialRoute: '/escrow',
        onGenerateRoute: _route,
        builder: (context, child) => child ?? const SizedBox.shrink(),
      );
}

class _PreviewShell extends StatelessWidget {
  const _PreviewShell({
    required this.child,
    required this.onOutsidePreview,
    required this.onOpenDirectory,
  });

  final Widget child;
  final VoidCallback onOutsidePreview;
  final VoidCallback onOpenDirectory;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const _NonProductionNotice(),
            Expanded(child: child),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 4,
          onDestinationSelected: (index) {
            if (index == 4) {
              onOpenDirectory();
            } else {
              onOutsidePreview();
            }
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.payments_outlined), label: 'Payments'),
            NavigationDestination(
                icon: Icon(Icons.credit_card_outlined), label: 'Cards'),
            NavigationDestination(
                icon: Icon(Icons.savings_outlined), label: 'Save & Borrow'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        ),
      );
}

class _EscrowPreviewDirectoryPage extends StatelessWidget {
  const _EscrowPreviewDirectoryPage({required this.onOpen});

  final ValueChanged<String> onOpen;

  static const _screens = <(String, String)>[
    ('S-ESC-001 · Escrow Home', '/escrow'),
    ('S-ESC-002 · Create Deal', '/escrow/new'),
    ('S-ESC-003 · Fees and Cancellation Terms', '/escrow/new/terms'),
    ('S-ESC-004 · Invite Counterparty', '/escrow/synthetic-active/invite'),
    ('S-ESC-005 · Accept Deal', '/escrow/synthetic-active/accept'),
    ('S-ESC-006 · Fund Escrow', '/escrow/synthetic-active/fund'),
    ('S-ESC-007 · Deal Details', '/escrow/synthetic-active'),
    ('S-ESC-008 · Submit Delivery', '/escrow/synthetic-active/deliver'),
    ('S-ESC-009 · Confirm Delivery', '/escrow/synthetic-active/confirm'),
    ('S-ESC-010 · Open Dispute', '/escrow/synthetic-active/dispute'),
    (
      'S-ESC-011 · Dispute Status and Tracking',
      '/escrow/synthetic-active/dispute/status'
    ),
    ('S-ESC-012 · Cancel Deal', '/escrow/synthetic-active/cancel'),
    ('S-ESC-013 · Receipt and Rating', '/escrow/synthetic-active/receipt'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Escrow preview screens')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'All thirteen implemented Escrow screens. Preview-only examples; host data and real operations remain unavailable.',
            ),
            const SizedBox(height: 12),
            for (final (label, route) in _screens)
              Card(
                child: ListTile(
                  title: Text(label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => onOpen(route),
                ),
              ),
          ],
        ),
      );
}

class _TermsRouteArguments {
  const _TermsRouteArguments({required this.draft});
  final EscrowCreateDealDraft draft;
}

const _previewDraft = EscrowCreateDealDraft(
  type: EscrowDealType.goods,
  role: EscrowPartyRole.buyer,
  title: 'Synthetic preview draft',
  description: '',
  amount: '',
  timelineDescription: '',
  milestones: [],
);

class _SyntheticEscrowHomeAdapter implements EscrowHomeAdapter {
  const _SyntheticEscrowHomeAdapter();

  @override
  Future<List<EscrowDealCardData>> loadDeals() async => const [
        EscrowDealCardData(
          id: 'synthetic-active',
          title: 'Synthetic goods deal',
          group: EscrowDealGroup.active,
          role: EscrowPartyRole.buyer,
          statusLabel: 'Active · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-waiting',
          title: 'Synthetic service deal',
          group: EscrowDealGroup.waitingForMe,
          role: EscrowPartyRole.seller,
          statusLabel: 'Waiting · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-completed',
          title: 'Synthetic completed deal',
          group: EscrowDealGroup.completed,
          role: EscrowPartyRole.buyer,
          statusLabel: 'Completed · synthetic',
        ),
        EscrowDealCardData(
          id: 'synthetic-dispute',
          title: 'Synthetic dispute example',
          group: EscrowDealGroup.disputes,
          role: EscrowPartyRole.seller,
          statusLabel: 'Dispute · synthetic',
        ),
      ];
}

class _SyntheticEscrowInviteAdapter implements EscrowInviteAdapter {
  const _SyntheticEscrowInviteAdapter();

  @override
  Future<EscrowInvitePresentation?> loadInvite(String dealId) async =>
      const EscrowInvitePresentation(
        dealTitle: 'Synthetic example — no real deal',
        inviteeRoleLabel: 'other party',
        channels: [
          EscrowInviteChannel(
            value: 'preview-only',
            label: 'Preview only — no invitation will be sent',
          ),
        ],
        counterpartyStatus:
            'Preview only — no counterparty has been invited or verified.',
      );

  @override
  Future<void> sendInvite({
    required String dealId,
    required String phone,
    required String channel,
  }) async {
    throw UnsupportedError('This preview does not send invitations.');
  }

  @override
  Future<void> proposeTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  }) async {
    throw UnsupportedError('This preview does not submit terms.');
  }
}

class _UnavailableEscrowAcceptAdapter implements EscrowAcceptAdapter {
  const _UnavailableEscrowAcceptAdapter();

  @override
  Future<void> openTermsDocument({
    required String dealId,
    required String termsHash,
  }) async {
    throw UnsupportedError('No terms document service is connected.');
  }

  @override
  Future<EscrowLockedTermsPresentation?> loadLockedTerms(String dealId) async =>
      const EscrowLockedTermsPresentation(
        dealTitle: 'Synthetic example — no real deal',
        termsHash: '',
        lines: [
          EscrowLockedTermLine(
            label: 'Deal amount',
            value: 'Not supplied',
          ),
          EscrowLockedTermLine(
            label: 'Fees and cancellation terms',
            value: 'Not supplied',
          ),
        ],
        otherPartyAcceptance: 'Not supplied',
        acceptanceAllowed: false,
      );

  @override
  Future<String?> authorizeWithPin(String dealId) async => null;

  @override
  Future<EscrowAcceptOutcome> acceptLockedTerms({
    required String dealId,
    required String termsHash,
    required String idempotencyKey,
    required String pinToken,
  }) async =>
      throw UnsupportedError('No acceptance or PIN service is connected.');
}

class _UnavailableEscrowFundingAdapter implements EscrowFundingAdapter {
  const _UnavailableEscrowFundingAdapter();

  @override
  Future<EscrowFundingPresentation?> loadFunding(String dealId) async =>
      const EscrowFundingPresentation(
        dealTitle: 'Synthetic example — no real deal',
        amountLabel: 'Not supplied',
        feeLines: [],
        totalLabel: 'Not supplied',
        methods: [],
        fundingAllowed: false,
        statusMessage:
            'No payment, bank transfer, or funding status is connected to this preview.',
      );

  @override
  Future<String?> authorizeWithPin(String dealId) async => null;

  @override
  Future<EscrowFundingOutcome> fund({
    required String dealId,
    required String methodId,
    required String idempotencyKey,
    required String pinToken,
  }) async =>
      throw UnsupportedError('No payment service is connected.');
}

class _UnavailableEscrowTermsAdapter implements EscrowFeeTermsAdapter {
  const _UnavailableEscrowTermsAdapter();

  @override
  Future<EscrowFeeTermsPresentation?> loadTerms({
    required String? dealId,
    required EscrowCreateDealDraft draft,
  }) async =>
      null;

  @override
  Future<void> saveTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  }) async {
    throw UnsupportedError('No Escrow backend is connected to this preview.');
  }
}

class _NonProductionNotice extends StatelessWidget {
  const _NonProductionNotice();

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          color: const Color(0xFFF8E8EE),
          child: Text(
            const EscrowCopy().nonProduction,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF731540),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );
}

class _UnavailableEscrowDealDetailAdapter implements EscrowDealDetailAdapter {
  const _UnavailableEscrowDealDetailAdapter();
  @override
  Future<EscrowDealDetail?> loadDeal(String dealId) async => null;
  @override
  Future<void> sendMessage({required String dealId, required String body}) =>
      Future.error(UnsupportedError('Messaging is not connected.'));
  @override
  Future<void> openDocument(
          {required String dealId, required String documentId}) =>
      Future.error(UnsupportedError('Documents are not connected.'));
}

class _UnavailableEscrowDeliveryAdapter implements EscrowDeliveryAdapter {
  const _UnavailableEscrowDeliveryAdapter();
  @override
  Future<EscrowDeliveryContext?> loadDelivery(String dealId) async =>
      const EscrowDeliveryContext(
        title: 'Synthetic preview example — no real deal',
        instruction:
            'Delivery instructions and permissions require host deal data.',
        submissionAllowed: false,
        evidenceUploadAvailable: false,
      );
  @override
  Future<EscrowEvidenceItem?> attachEvidence(String dealId) async => null;
  @override
  Future<String?> authorizeWithPin(String dealId) async => null;
  @override
  Future<EscrowBatch3Outcome> submitDelivery(
          {required String dealId,
          required int? milestoneSequence,
          required List<String> evidenceReferences,
          required String note,
          required String idempotencyKey,
          required String pinToken}) =>
      Future.error(
          UnsupportedError('No delivery or PIN service is connected.'));
}

class _UnavailableEscrowConfirmationAdapter
    implements EscrowConfirmationAdapter {
  const _UnavailableEscrowConfirmationAdapter();
  @override
  Future<EscrowConfirmationContext?> loadConfirmation(String dealId) async =>
      const EscrowConfirmationContext(
        title: 'Synthetic preview example — no real deal',
        instruction:
            'Delivery evidence and confirmation permissions require host deal data.',
      );
  @override
  Future<void> openEvidence(
          {required String dealId, required String evidenceReference}) =>
      Future.error(UnsupportedError('Evidence is not connected.'));
  @override
  Future<String?> authorizeWithPin(String dealId) async => null;
  @override
  Future<EscrowBatch3Outcome> submitDecision(
          {required String dealId,
          required EscrowConfirmAction action,
          required String? deliveryCode,
          required int? milestoneSequence,
          required String idempotencyKey,
          required String pinToken}) =>
      Future.error(
          UnsupportedError('No confirmation or PIN service is connected.'));
}

class _UnavailableEscrowOpenDisputeAdapter implements EscrowOpenDisputeAdapter {
  const _UnavailableEscrowOpenDisputeAdapter();

  @override
  Future<EscrowOpenDisputeContext?> loadOpenDispute(String dealId) async =>
      const EscrowOpenDisputeContext(
        dealTitle: 'Open dispute preview',
        dealSummary:
            'NON-PRODUCTION · Preview form only. No real deal or customer dispute is connected.',
        whatHappensNext:
            'Host eligibility, supported reasons and applicable deadlines are not connected in preview.',
        restrictionMessage:
            'Preview only: dispute submission is disabled. Eligibility and dispute-window status require host data.',
        canOpenDispute: false,
      );

  @override
  Future<EscrowDisputeEvidence?> attachEvidence(String dealId) async => null;

  @override
  Future<String?> authorizeWithPin(String dealId) async => null;

  @override
  Future<EscrowDisputeSubmissionOutcome> openDispute({
    required String dealId,
    required String reason,
    required String description,
    required List<String> evidenceReferences,
    required String idempotencyKey,
    required String pinToken,
  }) =>
      Future.error(
          UnsupportedError('Dispute submission is unavailable in preview.'));
}

class _UnavailableEscrowDisputeStatusAdapter
    implements EscrowDisputeStatusAdapter {
  const _UnavailableEscrowDisputeStatusAdapter();

  @override
  Future<EscrowDisputeStatusContext?> loadDisputeStatus(String dealId) async =>
      const EscrowDisputeStatusContext(
        caseLabel: 'PREVIEW SAMPLE · not a customer case',
        statusLabel: 'Preview only',
        dealTitle: 'Dispute tracking preview',
        summary:
            'Illustrative layout only. No dispute record or decision exists.',
        events: [
          EscrowDisputeEvent(
            label: 'Opened',
            detail: 'Host case information is not connected.',
          ),
          EscrowDisputeEvent(
            label: 'Evidence due',
            detail: 'No deadline supplied.',
          ),
          EscrowDisputeEvent(
            label: 'Review',
            detail: 'No review status supplied.',
          ),
          EscrowDisputeEvent(
            label: 'Decision',
            detail: 'No decision supplied.',
          ),
          EscrowDisputeEvent(
            label: 'Appeal window',
            detail: 'No appeal eligibility or deadline supplied.',
          ),
        ],
        appealAllowed: false,
        appealRestrictionMessage:
            'Appeal availability is not provided in preview; host eligibility and API details are required.',
      );

  @override
  Future<String?> authorizeWithPin(String dealId) async => null;

  @override
  Future<EscrowDisputeSubmissionOutcome> requestAppeal({
    required String dealId,
    required String reason,
    required String idempotencyKey,
    required String pinToken,
  }) =>
      Future.error(UnsupportedError('Appeals are unavailable in preview.'));
}

class _PreviewEscrowCancellationAdapter implements EscrowCancellationAdapter {
  const _PreviewEscrowCancellationAdapter();

  @override
  Future<EscrowCancellationContext?> loadCancellation(String dealId) async =>
      const EscrowCancellationContext(
        dealTitle: 'Cancel deal preview',
        summary:
            'NON-PRODUCTION · Preview example only. No real deal or cancellation is connected.',
        scenarioLabel: 'Not supplied by host',
        agreedFeeOutcome: 'Not supplied by host',
        netRefundLabel: 'Not supplied by host',
        requiresCounterpartyAgreement: true,
        counterpartyAgreementSatisfied: false,
        canRequestCancellation: false,
        restrictionMessage:
            'Preview only: cancellation is disabled. Eligibility, reason options and agreed financial terms require host data.',
      );

  @override
  Future<String?> authorizeWithPin(String dealId) async => null;

  @override
  Future<EscrowBatch5Outcome> requestCancellation({
    required String dealId,
    required String reason,
    required String idempotencyKey,
    required String pinToken,
  }) =>
      Future.error(UnsupportedError('Cancellation is unavailable in preview.'));
}

class _PreviewEscrowReceiptAdapter implements EscrowReceiptAdapter {
  const _PreviewEscrowReceiptAdapter();

  @override
  Future<EscrowReceiptContext?> loadReceipt(String dealId) async =>
      const EscrowReceiptContext(
        dealTitle: 'Receipt preview',
        statusLabel: 'Not supplied by host',
        unavailableMessage:
            'NON-PRODUCTION · No transaction or customer receipt exists. Values below are intentionally unavailable.',
        canShare: false,
        canRate: false,
        ratingSubmitted: false,
      );

  @override
  Future<void> shareReceipt({required String dealId}) => Future.error(
      UnsupportedError('Receipt sharing is unavailable in preview.'));

  @override
  Future<EscrowBatch5Outcome> submitRating({
    required String dealId,
    required String ratingValue,
  }) =>
      Future.error(
          UnsupportedError('Rating submission is unavailable in preview.'));
}
