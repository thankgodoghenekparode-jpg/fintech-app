import 'dart:async';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('S-ESC-004 validates and submits a host-supported invitation',
      (tester) async {
    _useMobileViewport(tester);
    final adapter = _InviteFake();
    await tester.pumpWidget(MaterialApp(
      home: EscrowInviteNegotiatePage(
        dealId: 'deal-host-id',
        adapter: adapter,
        onReviewTerms: () {},
      ),
    ));
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Share link unavailable'));
    expect(find.text('Share link unavailable'), findsOneWidget);
    await _scrollTo(tester, find.byType(TextFormField));
    await _scrollTo(tester, find.text('Send invitation'));
    await tester.tap(find.text('Send invitation'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a phone number.'), findsOneWidget);
    expect(adapter.inviteCalls, 0);

    await tester.enterText(find.byType(TextFormField), '+2348000000000');
    await tester.ensureVisible(find.text('Send invitation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send invitation'));
    await tester.pumpAndSettle();
    expect(adapter.inviteCalls, 1);
    expect(adapter.lastPhone, '+2348000000000');
    await _scrollTo(tester, find.text('Invitation pending'));
    expect(find.text('Invitation pending'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('S-ESC-004 shows retry state when host data cannot load',
      (tester) async {
    _useMobileViewport(tester);
    final adapter = _InviteFake()..failFirstLoad = true;
    await tester.pumpWidget(MaterialApp(
      home: EscrowInviteNegotiatePage(
        dealId: 'deal-host-id',
        adapter: adapter,
        onReviewTerms: () {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Could not load invitation details.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Invite by phone'), findsOneWidget);
  });

  testWidgets('S-ESC-005 authorizes PIN and sends locked terms once',
      (tester) async {
    _useMobileViewport(tester);
    final adapter = _AcceptFake();
    await tester.pumpWidget(MaterialApp(
      home: EscrowAcceptTermsPage(
        dealId: 'deal-host-id',
        adapter: adapter,
        onProceedToFunding: () {},
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Terms changed'), findsOneWidget);
    expect(find.text('Host-supplied amount'), findsOneWidget);
    await _scrollTo(tester, find.text('Accept updated terms with PIN'));
    await tester.ensureVisible(find.text('Accept updated terms with PIN'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept updated terms with PIN'));
    await tester.pumpAndSettle();
    expect(adapter.pinCalls, 1);
    expect(adapter.acceptCalls, 1);
    expect(adapter.lastTermsHash, 'host-terms-hash');
    expect(adapter.lastPinToken, 'host-pin-token');
    expect(adapter.lastIdempotencyKey, startsWith('escrow-accept-'));
    expect(find.text('Acceptance recorded by the host.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('S-ESC-005 leaves acceptance disabled without a snapshot',
      (tester) async {
    _useMobileViewport(tester);
    await tester.pumpWidget(MaterialApp(
      home: EscrowAcceptTermsPage(
        dealId: 'deal-host-id',
        adapter: _AcceptFake(unavailable: true),
        onProceedToFunding: () {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Locked terms and the terms hash are unavailable from the host.'),
        findsOneWidget);
  });

  testWidgets(
      'S-ESC-005 prevents duplicate acceptance while PIN request is pending',
      (tester) async {
    _useMobileViewport(tester);
    final adapter = _AcceptFake()..acceptGate = Completer<void>();
    await tester.pumpWidget(MaterialApp(
      home: EscrowAcceptTermsPage(
        dealId: 'deal-host-id',
        adapter: adapter,
        onProceedToFunding: () {},
      ),
    ));
    await tester.pumpAndSettle();
    final action = find.text('Accept updated terms with PIN');
    await _scrollTo(tester, action);
    await tester.ensureVisible(action);
    await tester.pumpAndSettle();
    await tester.tap(action);
    await tester.pump();
    await tester.tap(action);
    await tester.pump();
    expect(adapter.acceptCalls, 1);
    adapter.acceptGate!.complete();
    await tester.pumpAndSettle();
    expect(adapter.acceptCalls, 1);
  });

  testWidgets('S-ESC-006 renders host transfer data and pending result',
      (tester) async {
    _useMobileViewport(tester);
    final adapter = _FundingFake();
    await tester.pumpWidget(MaterialApp(
      home: EscrowFundDealPage(dealId: 'deal-host-id', adapter: adapter),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Host-supplied amount'), findsOneWidget);
    expect(find.text('Host account number'), findsOneWidget);
    await _scrollTo(tester, find.text('Confirm funding with PIN'));
    await tester.tap(find.text('Confirm funding with PIN'));
    await tester.pumpAndSettle();
    expect(adapter.fundCalls, 1);
    expect(adapter.lastIdempotencyKey, startsWith('escrow-fund-'));
    expect(adapter.lastPinToken, 'host-pin-token');
    await _scrollTo(
      tester,
      find.textContaining('Funding is pending host confirmation'),
    );
    expect(find.textContaining('Funding is pending host confirmation'),
        findsOneWidget);
    await _scrollTo(tester, find.text('Confirm funding with PIN'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Confirm funding with PIN'),
          )
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('S-ESC-006 keeps funding unavailable without host amounts',
      (tester) async {
    _useMobileViewport(tester);
    await tester.pumpWidget(MaterialApp(
      home: EscrowFundDealPage(
        dealId: 'deal-host-id',
        adapter: _FundingFake(unavailable: true),
      ),
    ));
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Confirm funding with PIN'),
    );
    expect(button.onPressed, isNull);
    expect(
        find.text('No host-supported wallet or transfer option is available.'),
        findsOneWidget);
  });
}

void _useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    250,
    scrollable: find.byType(Scrollable).first,
  );
}

class _InviteFake implements EscrowInviteAdapter {
  var failFirstLoad = false;
  var _loads = 0;
  var inviteCalls = 0;
  var lastPhone = '';

  @override
  Future<EscrowInvitePresentation?> loadInvite(String dealId) async {
    _loads++;
    if (failFirstLoad && _loads == 1) throw Exception('host unavailable');
    return EscrowInvitePresentation(
      dealTitle: 'Synthetic preview deal',
      inviteeRoleLabel: 'seller',
      channels: const [
        EscrowInviteChannel(value: 'host-channel', label: 'Host channel')
      ],
      invitationPending: inviteCalls > 0,
    );
  }

  @override
  Future<void> sendInvite({
    required String dealId,
    required String phone,
    required String channel,
  }) async {
    inviteCalls++;
    lastPhone = phone;
  }

  @override
  Future<void> proposeTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  }) async {}
}

class _AcceptFake implements EscrowAcceptAdapter {
  _AcceptFake({this.unavailable = false});

  final bool unavailable;
  var pinCalls = 0;
  var acceptCalls = 0;
  Completer<void>? acceptGate;
  String? lastTermsHash;
  String? lastPinToken;
  String? lastIdempotencyKey;

  @override
  Future<void> openTermsDocument({
    required String dealId,
    required String termsHash,
  }) async {}

  @override
  Future<EscrowLockedTermsPresentation?> loadLockedTerms(String dealId) async {
    if (unavailable) return null;
    return const EscrowLockedTermsPresentation(
      dealTitle: 'Synthetic preview deal',
      termsHash: 'host-terms-hash',
      lines: [
        EscrowLockedTermLine(label: 'Amount', value: 'Host-supplied amount'),
        EscrowLockedTermLine(
            label: 'Timeline', value: 'Host-supplied timeline'),
      ],
      otherPartyAcceptance: 'Host reports accepted',
      termsChanged: true,
      acceptanceAllowed: true,
    );
  }

  @override
  Future<String?> authorizeWithPin(String dealId) async {
    pinCalls++;
    return 'host-pin-token';
  }

  @override
  Future<EscrowAcceptOutcome> acceptLockedTerms({
    required String dealId,
    required String termsHash,
    required String idempotencyKey,
    required String pinToken,
  }) async {
    acceptCalls++;
    lastTermsHash = termsHash;
    lastIdempotencyKey = idempotencyKey;
    lastPinToken = pinToken;
    await acceptGate?.future;
    return EscrowAcceptOutcome.accepted;
  }
}

class _FundingFake implements EscrowFundingAdapter {
  _FundingFake({this.unavailable = false});

  final bool unavailable;
  var fundCalls = 0;
  String? lastIdempotencyKey;
  String? lastPinToken;

  @override
  Future<EscrowFundingPresentation?> loadFunding(String dealId) async {
    if (unavailable) {
      return const EscrowFundingPresentation(
        dealTitle: 'Synthetic preview deal',
        amountLabel: 'Not supplied',
        feeLines: [],
        totalLabel: 'Not supplied',
        methods: [],
      );
    }
    return const EscrowFundingPresentation(
      dealTitle: 'Synthetic preview deal',
      amountLabel: 'Host-supplied amount',
      feeLines: [
        EscrowLockedTermLine(
            label: 'Host-supplied fee', value: 'Host-supplied fee amount'),
      ],
      totalLabel: 'Host-supplied total',
      methods: [
        EscrowFundingMethod(
          id: 'host-transfer',
          kind: EscrowFundingMethodKind.bankTransfer,
          label: 'Bank transfer',
        ),
      ],
      transferAccountNumber: 'Host account number',
      fundingAllowed: true,
    );
  }

  @override
  Future<String?> authorizeWithPin(String dealId) async => 'host-pin-token';

  @override
  Future<EscrowFundingOutcome> fund({
    required String dealId,
    required String methodId,
    required String idempotencyKey,
    required String pinToken,
  }) async {
    fundCalls++;
    lastIdempotencyKey = idempotencyKey;
    lastPinToken = pinToken;
    return EscrowFundingOutcome.pending;
  }
}
