// ignore: deprecated_member_use // Flutter's bundled Material library is needed here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('deal details renders unavailable host state and tabs',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            EscrowDealDetailPage(dealId: 'd1', adapter: _DetailAdapter(null))));
    await tester.pumpAndSettle();
    expect(find.text('Deal information is unavailable.'), findsOneWidget);
  });

  testWidgets('deal details renders host values and detail tabs',
      (tester) async {
    const detail = EscrowDealDetail(
        title: 'Host deal',
        statusLabel: 'Host status',
        heldAmountLabel: 'Host amount',
        events: [EscrowDetailEvent(label: 'Host event')]);
    await tester.pumpWidget(MaterialApp(
        home: EscrowDealDetailPage(
            dealId: 'd1', adapter: _DetailAdapter(detail))));
    await tester.pumpAndSettle();
    expect(find.text('Host deal'), findsOneWidget);
    expect(find.text('Host amount'), findsOneWidget);
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(
        find.text('No host-provided messages are available.'), findsOneWidget);
  });

  testWidgets('delivery submission remains disabled without host permission',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: EscrowSubmitDeliveryPage(
            dealId: 'd1', adapter: _DeliveryAdapter())));
    await tester.pumpAndSettle();
    expect(
        find.text('Submission is unavailable for this deal.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Submit delivery'));
    expect(button.onPressed, isNull);
    expect(find.textContaining('upload service'), findsOneWidget);
  });

  testWidgets('delivery submission uses host PIN and a stable request key',
      (tester) async {
    final adapter = _DeliveryAdapter(allowed: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowSubmitDeliveryPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextField), 'Host-supported delivery note');
    await tester.tap(find.widgetWithText(FilledButton, 'Submit delivery'));
    await tester.pumpAndSettle();
    expect(adapter.submitted, isTrue);
    expect(adapter.key, isNotEmpty);
    expect(adapter.pin, 'host-pin');
    expect(find.text('Submission recorded by the host.'), findsOneWidget);
  });

  testWidgets('confirmation requires a host-specified six digit code',
      (tester) async {
    final adapter = _ConfirmationAdapter();
    await tester.pumpWidget(MaterialApp(
        home: EscrowConfirmDeliveryPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm delivery'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the 6-digit delivery code.'), findsOneWidget);
    expect(adapter.submitted, isFalse);
    expect(find.text('Funds are not confirmed as released.'), findsNothing);
  });

  testWidgets(
      'confirmation submits host-authorized decision with idempotency key',
      (tester) async {
    final adapter = _ConfirmationAdapter(codeRequired: false, allowed: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowConfirmDeliveryPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm delivery'));
    await tester.pumpAndSettle();
    expect(adapter.submitted, isTrue);
    expect(adapter.key, isNotEmpty);
    expect(adapter.pin, 'host-pin');
    expect(
        find.textContaining('Decision recorded by the host'), findsOneWidget);
  });

  testWidgets('Batch 3 screens fit a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home: EscrowConfirmDeliveryPage(
            dealId: 'd1', adapter: _ConfirmationAdapter(codeRequired: false))));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

class _DetailAdapter implements EscrowDealDetailAdapter {
  _DetailAdapter(this.data);
  final EscrowDealDetail? data;
  @override
  Future<EscrowDealDetail?> loadDeal(String dealId) async => data;
  @override
  Future<void> sendMessage(
      {required String dealId, required String body}) async {}
  @override
  Future<void> openDocument(
      {required String dealId, required String documentId}) async {}
}

class _DeliveryAdapter implements EscrowDeliveryAdapter {
  _DeliveryAdapter({this.allowed = false});
  final bool allowed;
  bool submitted = false;
  String? key, pin;

  @override
  Future<EscrowDeliveryContext?> loadDelivery(String dealId) async =>
      EscrowDeliveryContext(
          title: 'Delivery',
          evidenceUploadAvailable: false,
          submissionAllowed: allowed);
  @override
  Future<EscrowEvidenceItem?> attachEvidence(String dealId) async => null;
  @override
  Future<EscrowBatch3Outcome> submitDelivery(
      {required String dealId,
      required int? milestoneSequence,
      required List<String> evidenceReferences,
      required String note,
      required String idempotencyKey,
      required String pinToken}) async {
    submitted = true;
    key = idempotencyKey;
    pin = pinToken;
    return EscrowBatch3Outcome.recorded;
  }

  @override
  Future<String?> authorizeWithPin(String dealId) async => 'host-pin';
}

class _ConfirmationAdapter implements EscrowConfirmationAdapter {
  _ConfirmationAdapter({this.codeRequired = true, this.allowed = true});
  final bool codeRequired, allowed;
  bool submitted = false;
  String? key, pin;
  @override
  Future<EscrowConfirmationContext?> loadConfirmation(String dealId) async =>
      EscrowConfirmationContext(
          title: 'Confirm',
          deliveryCodeRequired: codeRequired,
          canRelease: allowed,
          evidence: const []);
  @override
  Future<void> openEvidence(
      {required String dealId, required String evidenceReference}) async {}
  @override
  Future<String?> authorizeWithPin(String dealId) async => pin = 'host-pin';
  @override
  Future<EscrowBatch3Outcome> submitDecision(
      {required String dealId,
      required EscrowConfirmAction action,
      required String? deliveryCode,
      required int? milestoneSequence,
      required String idempotencyKey,
      required String pinToken}) async {
    submitted = true;
    key = idempotencyKey;
    pin = pinToken;
    return EscrowBatch3Outcome.recorded;
  }
}
