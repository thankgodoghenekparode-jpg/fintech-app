// ignore: deprecated_member_use // Tests use Flutter's bundled Material widgets.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('cancellation shows host-provided terms and gates preview action',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: EscrowCancelDealPage(
            dealId: 'd1', adapter: _CancelAdapter(preview: true))));
    await tester.pumpAndSettle();
    expect(find.text('Not supplied by host'), findsNWidgets(3));
    expect(find.textContaining('Preview only: cancellation is disabled'),
        findsOneWidget);
    expect(find.textContaining('Counterparty agreement is required'),
        findsOneWidget);
    await _scrollTo(tester, find.text('Confirm cancellation'));
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Confirm cancellation'))
            .onPressed,
        isNull);
  });

  testWidgets('cancellation requires reason and review confirmation',
      (tester) async {
    final adapter = _CancelAdapter(withoutReasons: true);
    await tester.pumpWidget(MaterialApp(
        home: EscrowCancelDealPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Confirm cancellation'));
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm cancellation'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Choose a supported reason'), findsOneWidget);
    expect(adapter.submitted, isFalse);
  });

  testWidgets(
      'cancellation request uses PIN, reason and stable idempotency key',
      (tester) async {
    final adapter = _CancelAdapter();
    await tester.pumpWidget(MaterialApp(
        home: EscrowCancelDealPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Host reason').last);
    await tester.pumpAndSettle();
    await _scrollTo(tester,
        find.text('I have reviewed the cancellation information above.'));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Confirm cancellation'));
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm cancellation'));
    await tester.pumpAndSettle();
    expect(adapter.submitted, isTrue);
    expect(adapter.reason, 'host_reason');
    expect(adapter.pin, 'host-pin');
    expect(adapter.requestKey, isNotEmpty);
    expect(find.textContaining('request recorded by the host'), findsOneWidget);
  });

  testWidgets('cancellation stays disabled while agreement is outstanding',
      (tester) async {
    final adapter = _CancelAdapter(agreementSatisfied: false);
    await tester.pumpWidget(MaterialApp(
        home: EscrowCancelDealPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Counterparty agreement is required'),
        findsOneWidget);
    await _scrollTo(tester, find.text('Confirm cancellation'));
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Confirm cancellation'))
            .onPressed,
        isNull);
  });

  testWidgets('receipt never fabricates unavailable transaction details',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: EscrowReceiptRatingPage(
            dealId: 'd1', adapter: _ReceiptAdapter(preview: true))));
    await tester.pumpAndSettle();
    expect(find.textContaining('No transaction or customer receipt exists'),
        findsOneWidget);
    expect(find.text('Receipt details are not supplied by the host.'),
        findsOneWidget);
    expect(
        tester
            .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Share receipt'))
            .onPressed,
        isNull);
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Submit rating'))
            .onPressed,
        isNull);
  });

  testWidgets('receipt displays host values and rates only with host options',
      (tester) async {
    final adapter = _ReceiptAdapter();
    await tester.pumpWidget(MaterialApp(
        home: EscrowReceiptRatingPage(dealId: 'd1', adapter: adapter)));
    await tester.pumpAndSettle();
    expect(find.text('Host receipt reference'), findsOneWidget);
    expect(find.text('Host-supplied receipt value'), findsOneWidget);
    await tester.tap(find.text('Host rating option'));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.text('Submit rating'));
    await tester.tap(find.widgetWithText(FilledButton, 'Submit rating'));
    await tester.pumpAndSettle();
    expect(adapter.rating, 'host_rating');
    expect(find.text('Rating request recorded by the host.'), findsOneWidget);
  });

  testWidgets('Batch 5 screens fit a narrow viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home:
            EscrowReceiptRatingPage(dealId: 'd1', adapter: _ReceiptAdapter())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    220,
    scrollable: find
        .descendant(
            of: find.byType(ListView), matching: find.byType(Scrollable))
        .first,
  );
}

class _CancelAdapter implements EscrowCancellationAdapter {
  _CancelAdapter({
    this.preview = false,
    this.agreementSatisfied = true,
    this.withoutReasons = false,
  });
  final bool preview, agreementSatisfied, withoutReasons;
  bool submitted = false;
  String? reason, requestKey, pin;
  @override
  Future<EscrowCancellationContext?> loadCancellation(String dealId) async =>
      EscrowCancellationContext(
        dealTitle: preview ? 'Cancel preview' : 'Host deal',
        scenarioLabel: preview ? null : 'Host scenario',
        agreedFeeOutcome: preview ? null : 'Host fee treatment',
        netRefundLabel: preview ? null : 'Host refund label',
        reasons: preview || withoutReasons
            ? const []
            : const [
                EscrowCancelReason(value: 'host_reason', label: 'Host reason')
              ],
        canRequestCancellation: !preview,
        requiresCounterpartyAgreement: true,
        counterpartyAgreementSatisfied: agreementSatisfied && !preview,
        restrictionMessage:
            preview ? 'Preview only: cancellation is disabled.' : null,
      );
  @override
  Future<String?> authorizeWithPin(String dealId) async => 'host-pin';
  @override
  Future<EscrowBatch5Outcome> requestCancellation(
      {required String dealId,
      required String reason,
      required String idempotencyKey,
      required String pinToken}) async {
    submitted = true;
    this.reason = reason;
    requestKey = idempotencyKey;
    pin = pinToken;
    return EscrowBatch5Outcome.recorded;
  }
}

class _ReceiptAdapter implements EscrowReceiptAdapter {
  _ReceiptAdapter({this.preview = false});
  final bool preview;
  String? rating;
  @override
  Future<EscrowReceiptContext?> loadReceipt(String dealId) async =>
      EscrowReceiptContext(
        dealTitle: preview ? 'Receipt preview' : 'Host receipt',
        statusLabel: preview ? 'Not supplied' : 'Host status',
        receiptReference: preview ? null : 'Host receipt reference',
        receiptLines: preview
            ? const []
            : const [
                EscrowReceiptLine(
                    label: 'Reference field',
                    value: 'Host-supplied receipt value')
              ],
        ratingOptions: preview
            ? const []
            : const [
                EscrowRatingOption(
                    value: 'host_rating', label: 'Host rating option')
              ],
        canShare: false,
        canRate: !preview,
        unavailableMessage: preview
            ? 'NON-PRODUCTION · No transaction or customer receipt exists.'
            : null,
      );
  @override
  Future<void> shareReceipt({required String dealId}) async {}
  @override
  Future<EscrowBatch5Outcome> submitRating(
      {required String dealId, required String ratingValue}) async {
    rating = ratingValue;
    return EscrowBatch5Outcome.recorded;
  }
}
