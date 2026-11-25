// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() {
  group('DeadlineDecisionPage', () {
    testWidgets('shows unavailable choices without host terms', (tester) async {
      final adapter = _FeatureAdapter();
      await tester.pumpWidget(
          _app(DeadlineDecisionPage(adapter: adapter, planId: 'plan')));
      await tester.pumpAndSettle();
      expect(find.text('Extend the deadline'), findsOneWidget);
      expect(find.text('Refund accumulated savings'), findsOneWidget);
      expect(find.textContaining('Terms are unavailable'), findsNWidgets(2));
      expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Confirm decision'))
              .onPressed,
          isNull);
      expect(adapter.lastDecision, isNull);
    });

    testWidgets('selects and submits documented EXTEND decision',
        (tester) async {
      final adapter = _FeatureAdapter(withDecisionTerms: true);
      await tester.pumpWidget(
          _app(DeadlineDecisionPage(adapter: adapter, planId: 'plan')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Radio<PasDeadlineDecision>).first);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Confirm decision'))
              .onPressed,
          isNotNull);
      await tester.tap(find.text('Confirm decision'));
      await tester.pumpAndSettle();
      expect(adapter.lastDecision?.toJson(), {'decision': 'EXTEND'});
      expect(find.text('Preview only. No deadline decision was submitted.'),
          findsOneWidget);
    });

    testWidgets('shows loading and handles a decision error', (tester) async {
      final adapter =
          _FeatureAdapter(withDecisionTerms: true, failDecision: true);
      await tester.pumpWidget(
          _app(DeadlineDecisionPage(adapter: adapter, planId: 'plan')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Radio<PasDeadlineDecision>).last);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Confirm decision'))
              .onPressed,
          isNotNull);
      await tester.tap(find.text('Confirm decision'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.text('We could not submit this decision. Try again.'),
          findsOneWidget);
      expect(adapter.lastDecision?.toJson(), {'decision': 'REFUND'});
    });

    testWidgets('supports loading and retry when decision context fails',
        (tester) async {
      final adapter = _FeatureAdapter()..failDeadlineLoad = true;
      await tester.pumpWidget(
          _app(DeadlineDecisionPage(adapter: adapter, planId: 'plan')));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Deadline decision details are unavailable.'),
          findsOneWidget);
      adapter.failDeadlineLoad = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Choose a vault action'), findsOneWidget);
    });

    testWidgets('fits narrow light and dark mobile widths', (tester) async {
      for (final size in [const Size(390, 844), const Size(320, 720)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        for (final brightness in Brightness.values) {
          await tester.pumpWidget(_app(
            DeadlineDecisionPage(adapter: _FeatureAdapter(), planId: 'plan'),
            brightness: brightness,
          ));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('OrderTrackingPage', () {
    testWidgets('renders host timeline, delivery and navigation actions',
        (tester) async {
      final adapter = _FeatureAdapter(withOrderData: true);
      String? openedReport;
      String? openedVault;
      String? contactedVendor;
      await tester.pumpWidget(_app(OrderTrackingPage(
        adapter: adapter,
        orderId: 'order-1',
        onReportProblem: (id) => openedReport = id,
        onContactVendor: (id) => contactedVendor = id,
        onOpenVault: (id) => openedVault = id,
      )));
      await tester.pumpAndSettle();
      expect(find.text('Packed and ready'), findsOneWidget);
      expect(find.text('Synthetic host event detail'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byTooltip('Contact vendor'),
        160,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.byTooltip('Contact vendor'));
      await tester.scrollUntilVisible(
        find.text('View related vault'),
        160,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('View related vault'));
      await tester.scrollUntilVisible(
        find.text('Report a delivery problem'),
        160,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Report a delivery problem'));
      expect(contactedVendor, 'order-1');
      expect(openedVault, 'plan-1');
      expect(openedReport, 'order-1');
    });

    testWidgets('shows empty state when host returns no order data',
        (tester) async {
      await tester.pumpWidget(_app(
          OrderTrackingPage(adapter: _FeatureAdapter(), orderId: 'order-1')));
      await tester.pumpAndSettle();
      expect(find.text('No order information was provided.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows loading and retries after order load error',
        (tester) async {
      final adapter = _FeatureAdapter()..failOrderLoad = true;
      await tester.pumpWidget(
          _app(OrderTrackingPage(adapter: adapter, orderId: 'order-1')));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Order details are unavailable.'), findsOneWidget);
      adapter.failOrderLoad = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('No order information was provided.'), findsOneWidget);
    });

    testWidgets('omits events and sensitive code when fields are absent',
        (tester) async {
      await tester.pumpWidget(_app(OrderTrackingPage(
        adapter: _FeatureAdapter(withOrderData: true, sparseOrder: true),
        orderId: 'order-1',
      )));
      await tester.pumpAndSettle();
      expect(
          find.text('Tracking updates are not available yet.'), findsOneWidget);
      expect(
          find.textContaining('Delivery code is unavailable'), findsOneWidget);
      expect(find.text('Synthetic host event detail'), findsNothing);
    });

    testWidgets('fits narrow light and dark viewports without overflow',
        (tester) async {
      for (final brightness in Brightness.values) {
        tester.view.physicalSize = const Size(320, 720);
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(_app(
          OrderTrackingPage(
              adapter: _FeatureAdapter(withOrderData: true),
              orderId: 'order-1'),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8E1B4A), brightness: brightness),
        useMaterial3: true,
      ),
      home: child,
    );

class _FeatureAdapter
    implements
        PayAmSmallDeadlineDecisionAdapter,
        PayAmSmallOrderTrackingAdapter {
  _FeatureAdapter({
    this.withDecisionTerms = false,
    this.failDecision = false,
    this.withOrderData = false,
    this.sparseOrder = false,
  });

  final bool withDecisionTerms;
  final bool failDecision;
  final bool withOrderData;
  final bool sparseOrder;
  bool failDeadlineLoad = false;
  bool failOrderLoad = false;
  PasDeadlineDecisionRequest? lastDecision;

  @override
  Future<PasDeadlineDecisionContext> loadDeadlineContext(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (failDeadlineLoad) throw StateError('host context unavailable');
    return PasDeadlineDecisionContext(
      planId: planId,
      title: 'Host vault title',
      statusLabel: 'Host deadline status',
      savedLabel: 'Host-supplied balance',
      deadlineLabel: 'Host-supplied date',
      extend: PasDeadlineDecisionOption(
        available: withDecisionTerms,
        consequence: withDecisionTerms ? 'Host-supplied extension terms' : null,
        feeLabel: withDecisionTerms ? 'Host-supplied fee' : null,
        newDeadlineLabel: withDecisionTerms ? 'Host-supplied deadline' : null,
      ),
      refund: PasDeadlineDecisionOption(
        available: withDecisionTerms,
        consequence: withDecisionTerms ? 'Host-supplied refund terms' : null,
        refundNetLabel: withDecisionTerms ? 'Host-supplied refund net' : null,
      ),
    );
  }

  @override
  Future<PasDeadlineDecisionResult> decide(
      PasDeadlineDecisionRequest request) async {
    lastDecision = request;
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (failDecision) throw StateError('host adapter failure');
    return const PasDeadlineDecisionResult(previewOnly: true);
  }

  @override
  Future<PasOrderTrackingData?> loadOrder(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (failOrderLoad) throw StateError('host order unavailable');
    if (!withOrderData) return null;
    if (sparseOrder)
      return PasOrderTrackingData(orderId: orderId, timeline: const []);
    return PasOrderTrackingData(
      orderId: orderId,
      statusLabel: 'Host-supplied status',
      statusDetail: 'Host-supplied status details',
      estimatedDeliveryLabel: 'Host-supplied delivery window',
      delayedNotice: 'Host-supplied delay notice',
      deliveryCode: '123456',
      deliveryCodeInstruction: 'Host-supplied delivery code instructions',
      productTitle: 'Host-supplied product',
      productPriceLabel: 'Host-supplied order amount',
      vendorName: 'Host-supplied vendor',
      vendorContactLabel: 'Host-supplied contact',
      deliveryAddress: 'Host-supplied address',
      planId: 'plan-1',
      timeline: const [
        PasOrderTimelineEntry(
          title: 'Packed and ready',
          state: PasOrderTimelineState.complete,
          detail: 'Synthetic host event detail',
          dateLabel: 'Host-supplied time',
        ),
      ],
    );
  }
}
