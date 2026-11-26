// ignore: deprecated_member_use // Tests use Flutter's bundled Material widgets.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('open dispute reflects host restriction and disables submission',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: EscrowOpenDisputePage(
            dealId: 'd1', adapter: _OpenAdapter(restricted: true))));
    await tester.pumpAndSettle();
    expect(find.textContaining('Dispute-window status require host data'),
        findsOneWidget);
    await _scrollTo(tester, find.text('Submit dispute'));
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Submit dispute'))
            .onPressed,
        isNull);
  });

  testWidgets('open dispute validates required documented fields',
      (tester) async {
    final adapter = _OpenAdapter();
    await tester.pumpWidget(MaterialApp(
        home: EscrowOpenDisputePage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Submit dispute'));
    await tester.tap(find.widgetWithText(FilledButton, 'Submit dispute'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Select a reason and enter a description'),
        findsOneWidget);
    expect(adapter.submitted, isFalse);
  });

  testWidgets(
      'open dispute submits host reason, evidence refs and authorized request',
      (tester) async {
    final adapter = _OpenAdapter(allowed: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowOpenDisputePage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Host-mapped issue details');
    await _scrollTo(tester, find.text('Submit dispute'));
    await tester.tap(find.widgetWithText(FilledButton, 'Submit dispute'));
    await tester.pumpAndSettle();
    expect(adapter.submitted, isTrue);
    expect(adapter.reason, 'host_reason');
    expect(adapter.description, 'Host-mapped issue details');
    expect(adapter.pin, 'host-pin');
    expect(adapter.key, isNotEmpty);
    expect(
        find.text('Dispute submission recorded by the host.'), findsOneWidget);
  });

  testWidgets('dispute tracker displays only host-supplied case state',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            EscrowDisputeStatusPage(dealId: 'd1', adapter: _StatusAdapter())));
    await tester.pumpAndSettle();
    expect(find.text('Host case reference'), findsOneWidget);
    expect(find.text('Host review status'), findsOneWidget);
    expect(find.text('Host timeline event'), findsOneWidget);
    expect(find.text('Host rationale'), findsOneWidget);
    expect(find.text('Host evidence update'), findsOneWidget);
  });

  testWidgets('appeal is gated by host permission and validates reason',
      (tester) async {
    final adapter = _StatusAdapter(appealAllowed: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowDisputeStatusPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Request appeal'));
    await tester.tap(find.widgetWithText(FilledButton, 'Request appeal'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the appeal reason.'), findsOneWidget);
    expect(adapter.appealed, isFalse);
  });

  testWidgets('appeal submits only after host permission and PIN authorization',
      (tester) async {
    final adapter = _StatusAdapter(appealAllowed: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowDisputeStatusPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byType(TextField));
    await tester.enterText(
        find.byType(TextField), 'Host-supported appeal reason');
    await _scrollTo(tester, find.text('Request appeal'));
    await tester.tap(find.widgetWithText(FilledButton, 'Request appeal'));
    await tester.pumpAndSettle();
    expect(adapter.appealed, isTrue);
    expect(adapter.reason, 'Host-supported appeal reason');
    expect(adapter.pin, 'host-pin');
    expect(adapter.key, isNotEmpty);
    expect(find.text('Appeal request recorded by the host.'), findsOneWidget);
  });

  testWidgets('Batch 4 screens fit a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home:
            EscrowDisputeStatusPage(dealId: 'd1', adapter: _StatusAdapter())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    260,
    scrollable: find
        .descendant(
            of: find.byType(ListView), matching: find.byType(Scrollable))
        .first,
  );
}

class _OpenAdapter implements EscrowOpenDisputeAdapter {
  _OpenAdapter({this.allowed = true, this.restricted = false});
  final bool allowed, restricted;
  bool submitted = false;
  String? reason, description, key, pin;
  @override
  Future<EscrowOpenDisputeContext?> loadOpenDispute(String dealId) async =>
      EscrowOpenDisputeContext(
        dealTitle: 'Host supplied deal title',
        reasons: const [
          EscrowDisputeReason(value: 'host_reason', label: 'Host reason')
        ],
        canOpenDispute: allowed && !restricted,
        restrictionMessage:
            restricted ? 'Dispute-window status require host data.' : null,
      );
  @override
  Future<EscrowDisputeEvidence?> attachEvidence(String dealId) async => null;
  @override
  Future<String?> authorizeWithPin(String dealId) async => 'host-pin';
  @override
  Future<EscrowDisputeSubmissionOutcome> openDispute(
      {required String dealId,
      required String reason,
      required String description,
      required List<String> evidenceReferences,
      required String idempotencyKey,
      required String pinToken}) async {
    submitted = true;
    this.reason = reason;
    this.description = description;
    key = idempotencyKey;
    pin = pinToken;
    return EscrowDisputeSubmissionOutcome.recorded;
  }
}

class _StatusAdapter implements EscrowDisputeStatusAdapter {
  _StatusAdapter({this.appealAllowed = false});
  final bool appealAllowed;
  bool appealed = false;
  String? reason, key, pin;
  @override
  Future<EscrowDisputeStatusContext?> loadDisputeStatus(String dealId) async =>
      EscrowDisputeStatusContext(
        caseLabel: 'Host case reference',
        statusLabel: 'Host review status',
        events: const [EscrowDisputeEvent(label: 'Host timeline event')],
        submissions: const [
          EscrowDisputeSubmission(label: 'Host evidence update')
        ],
        rationale: 'Host rationale',
        appealAllowed: appealAllowed,
      );
  @override
  Future<String?> authorizeWithPin(String dealId) async => 'host-pin';
  @override
  Future<EscrowDisputeSubmissionOutcome> requestAppeal(
      {required String dealId,
      required String reason,
      required String idempotencyKey,
      required String pinToken}) async {
    appealed = true;
    this.reason = reason;
    key = idempotencyKey;
    pin = pinToken;
    return EscrowDisputeSubmissionOutcome.recorded;
  }
}
