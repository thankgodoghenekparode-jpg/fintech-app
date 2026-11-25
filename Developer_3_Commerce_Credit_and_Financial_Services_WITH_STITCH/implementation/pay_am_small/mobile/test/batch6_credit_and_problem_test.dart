// ignore: deprecated_member_use // Flutter's SDK test viewport API is retained by this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() {
  group('CreditRepaymentPage', () {
    testWidgets('keeps repayment and auto-debit unavailable without approval',
        (tester) async {
      final adapter = _Batch6Adapter();
      await tester.pumpWidget(_app(CreditRepaymentPage(
        adapter: adapter,
        planId: 'plan',
      )));
      await tester.pumpAndSettle();
      expect(find.textContaining('legal approval'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Make repayment'),
            )
            .onPressed,
        isNull,
      );
      expect(find.byType(SwitchListTile), findsNothing);
      expect(adapter.repayment, isNull);
    });

    testWidgets('only submits the host supplied documented amount',
        (tester) async {
      final adapter = _Batch6Adapter(eligible: true);
      await tester.pumpWidget(_app(CreditRepaymentPage(
        adapter: adapter,
        planId: 'plan',
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Make repayment'));
      await tester.pumpAndSettle();
      expect(adapter.repayment?.toJson(), {'amountKobo': 25000});
    });

    testWidgets('updates auto-debit only through the documented enabled field',
        (tester) async {
      final adapter = _Batch6Adapter(eligible: true, autoDebitAvailable: true);
      await tester.pumpWidget(_app(CreditRepaymentPage(
        adapter: adapter,
        planId: 'plan',
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(adapter.autoDebit?.toJson(), {'enabled': true});
      expect(find.text('Auto-debit setting updated.'), findsOneWidget);
    });

    testWidgets('supports narrow light and dark layouts', (tester) async {
      for (final size in [const Size(390, 844), const Size(320, 720)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        for (final brightness in Brightness.values) {
          await tester.pumpWidget(_app(
            CreditRepaymentPage(adapter: _Batch6Adapter(), planId: 'plan'),
            brightness: brightness,
          ));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows repayment error feedback after submission fails',
        (tester) async {
      final adapter = _Batch6Adapter(eligible: true, failRepaymentSubmit: true);
      await tester.pumpWidget(_app(CreditRepaymentPage(
        adapter: adapter,
        planId: 'plan',
      )));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Make repayment'));
      await tester.pumpAndSettle();
      expect(find.textContaining('could not be completed'), findsOneWidget);
    });
  });

  group('ReportOrderProblemPage', () {
    testWidgets('keeps submit disabled until host reason and description exist',
        (tester) async {
      final adapter = _Batch6Adapter();
      await tester.pumpWidget(_app(ReportOrderProblemPage(
        adapter: adapter,
        orderId: 'order-1',
      )));
      await tester.pumpAndSettle();
      expect(find.textContaining('approved report options'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Submit report'),
            )
            .onPressed,
        isNull,
      );
      expect(find.textContaining('Evidence attachments are not available'),
          findsOneWidget);
    });

    testWidgets('uses host-provided option and only documented request fields',
        (tester) async {
      final adapter = _Batch6Adapter(withReason: true);
      await tester.pumpWidget(_app(ReportOrderProblemPage(
        adapter: adapter,
        orderId: 'order-1',
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Host supplied option'));
      await tester.enterText(find.byType(TextField), 'Description supplied');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Submit report'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.tap(find.text('Submit report'));
      await tester.pumpAndSettle();
      expect(adapter.report?.toJson(), {
        'reason': 'HOST_REASON',
        'description': 'Description supplied',
      });
      expect(find.text('Your report was submitted.'), findsOneWidget);
    });

    testWidgets('supports narrow dark layout and order context',
        (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(_app(
        ReportOrderProblemPage(
          adapter: _Batch6Adapter(),
          orderId: 'order-1',
        ),
        brightness: Brightness.dark,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Order · order-1'), findsOneWidget);
      expect(tester.takeException(), isNull);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows report error feedback after submission fails',
        (tester) async {
      final adapter = _Batch6Adapter(withReason: true, failReportSubmit: true);
      await tester.pumpWidget(_app(ReportOrderProblemPage(
        adapter: adapter,
        orderId: 'order-1',
      )));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Host supplied option'));
      await tester.enterText(find.byType(TextField), 'Description supplied');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Submit report'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.tap(find.text('Submit report'));
      await tester.pumpAndSettle();
      expect(find.textContaining('could not be submitted'), findsOneWidget);
    });
  });
}

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E1B4A),
          brightness: brightness,
        ),
      ),
      home: child,
    );

class _Batch6Adapter
    implements PayAmSmallCreditRepaymentAdapter, PayAmSmallOrderProblemAdapter {
  _Batch6Adapter({
    this.eligible = false,
    this.withReason = false,
    this.autoDebitAvailable = false,
    this.failRepaymentSubmit = false,
    this.failReportSubmit = false,
  });
  final bool eligible;
  final bool withReason;
  final bool autoDebitAvailable;
  final bool failRepaymentSubmit;
  final bool failReportSubmit;
  PasRepaymentRequest? repayment;
  PasAutoDebitRequest? autoDebit;
  PasOrderProblemRequest? report;

  @override
  Future<PasCreditRepaymentContext?> loadCredit(String planId) async {
    return PasCreditRepaymentContext(
      planId: planId,
      planLabel: 'Host plan',
      vendorLabel: 'Host vendor',
      outstandingBalanceLabel: 'Host amount label',
      repaymentLabel: 'Host repayment label',
      repaymentAmountKobo: eligible ? 25000 : null,
      vendorFundedCredit: eligible,
      hostEligible: eligible,
      legalApprovalEstablished: eligible,
      autoDebitAvailable: autoDebitAvailable,
      autoDebitEnabled: false,
    );
  }

  @override
  Future<void> repay(PasRepaymentRequest request) async {
    if (failRepaymentSubmit) throw StateError('host unavailable');
    repayment = request;
  }

  @override
  Future<void> setAutoDebit(PasAutoDebitRequest request) async {
    autoDebit = request;
  }

  @override
  Future<PasOrderProblemContext?> loadReportContext(String orderId) async {
    return PasOrderProblemContext(
      order: PasOrderTrackingData(orderId: orderId, timeline: const []),
      options: withReason
          ? const [
              PasOrderProblemOption(
                value: 'HOST_REASON',
                label: 'Host supplied option',
              ),
            ]
          : const [],
    );
  }

  @override
  Future<void> submitReport(PasOrderProblemRequest request) async {
    if (failReportSubmit) throw StateError('host unavailable');
    report = request;
  }
}
