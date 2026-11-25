// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() {
  group('AddMoneyPage', () {
    testWidgets('validates against host remaining amount and sends kobo',
        (tester) async {
      final adapter = _ActionAdapter();
      await tester
          .pumpWidget(_app(AddMoneyPage(adapter: adapter, planId: 'p')));
      await tester.pumpAndSettle();
      expect(find.text('Adding to vault'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('topUpAmount')));
      await tester.enterText(
          find.byKey(const ValueKey('topUpAmount')), '150.01');
      await tester.tap(find.text('Confirm amount'));
      await tester.pumpAndSettle();
      expect(find.text('Amount cannot exceed the remaining amount.'),
          findsOneWidget);
      expect(adapter.lastTopUp, isNull);

      await tester.enterText(
          find.byKey(const ValueKey('topUpAmount')), '125.50');
      await tester.tap(find.text('Confirm amount'));
      await tester.pumpAndSettle();
      expect(adapter.lastTopUp?.toJson(), {'amountKobo': 12550});
      expect(find.text('Preview only. No money was moved.'), findsOneWidget);
    });

    testWidgets('fits narrow light and dark layouts with fixed primary action',
        (tester) async {
      for (final size in [const Size(390, 844), const Size(320, 720)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        for (final brightness in Brightness.values) {
          await tester.pumpWidget(_app(
            AddMoneyPage(adapter: _ActionAdapter(), planId: 'p'),
            brightness: brightness,
          ));
          await tester.pumpAndSettle();
          expect(find.text('Confirm amount'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows loading and maps a host insufficient-funds error',
        (tester) async {
      final adapter = _ActionAdapter(topUpFailure: true);
      await tester
          .pumpWidget(_app(AddMoneyPage(adapter: adapter, planId: 'p')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('topUpAmount')), '10');
      await tester.tap(find.text('Confirm amount'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      await tester.pumpAndSettle();
      expect(find.text('There are insufficient funds for this request.'),
          findsOneWidget);
    });
  });

  group('WithdrawFromVaultPage', () {
    testWidgets('keeps confirmation unavailable without host quote terms',
        (tester) async {
      final adapter = _ActionAdapter(confirmable: false);
      await tester.pumpWidget(
          _app(WithdrawFromVaultPage(adapter: adapter, planId: 'p')));
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Confirm withdrawal'));
      expect(button.onPressed, isNull);
      expect(find.textContaining('No withdrawal quote'), findsOneWidget);
      expect(adapter.lastWithdrawal, isNull);
    });

    testWidgets(
        'requires acknowledgment and only sends documented confirm field',
        (tester) async {
      final adapter = _ActionAdapter(confirmable: true);
      await tester.pumpWidget(
          _app(WithdrawFromVaultPage(adapter: adapter, planId: 'p')));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Confirm withdrawal'))
              .onPressed,
          isNull);
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm withdrawal'));
      await tester.pumpAndSettle();
      expect(adapter.lastWithdrawal?.toJson(), {'confirm': true});
      expect(
          find.text('Preview only. No withdrawal was made.'), findsOneWidget);
    });

    testWidgets('supports narrow dark viewport without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(_app(
        WithdrawFromVaultPage(adapter: _ActionAdapter(), planId: 'p'),
        brightness: Brightness.dark,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Withdraw'), findsOneWidget);
      expect(tester.takeException(), isNull);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('maps withdrawal adapter errors', (tester) async {
      final adapter =
          _ActionAdapter(confirmable: true, withdrawalFailure: true);
      await tester.pumpWidget(
          _app(WithdrawFromVaultPage(adapter: adapter, planId: 'p')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.text('Confirm withdrawal'));
      await tester.pumpAndSettle();
      expect(find.text('Withdrawal is currently unavailable.'), findsOneWidget);
      expect(adapter.lastWithdrawal?.toJson(), {'confirm': true});
    });
  });
}

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8E1B4A), brightness: brightness),
          useMaterial3: true),
      home: child,
    );

class _ActionAdapter
    implements PayAmSmallTopUpAdapter, PayAmSmallWithdrawalAdapter {
  _ActionAdapter({
    this.confirmable = false,
    this.topUpFailure = false,
    this.withdrawalFailure = false,
  });
  final bool confirmable;
  final bool topUpFailure;
  final bool withdrawalFailure;
  PasTopUpRequest? lastTopUp;
  PasWithdrawalRequest? lastWithdrawal;

  @override
  Future<PasTopUpContext> loadTopUpContext(String planId) async =>
      const PasTopUpContext(
        planId: 'p',
        title: 'Sample vault',
        savedLabel: 'Host supplied saved',
        targetLabel: 'Host supplied target',
        remainingLabel: 'Host supplied remaining',
        remainingKobo: 15000,
      );

  @override
  Future<PasVaultActionResult> topUp(PasTopUpRequest request) async {
    lastTopUp = request;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (topUpFailure) {
      throw const PasVaultActionFailure(
        PasVaultActionFailureKind.insufficientFunds,
      );
    }
    return const PasVaultActionResult(PasVaultActionDisposition.previewOnly);
  }

  @override
  Future<PasWithdrawalContext> loadWithdrawalContext(String planId) async =>
      PasWithdrawalContext(
        planId: 'p',
        title: 'Sample vault',
        savedLabel: 'Host supplied saved',
        canConfirm: confirmable,
        penaltyLabel: confirmable ? 'Host supplied penalty' : null,
        netLabel: confirmable ? 'Host supplied net' : null,
        lockedPriceReminder:
            confirmable ? 'Host supplied terms reminder' : null,
        unavailableReason:
            confirmable ? null : 'No withdrawal quote is available.',
      );

  @override
  Future<PasVaultActionResult> withdraw(PasWithdrawalRequest request) async {
    lastWithdrawal = request;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (withdrawalFailure) {
      throw const PasVaultActionFailure(PasVaultActionFailureKind.unavailable);
    }
    return const PasVaultActionResult(PasVaultActionDisposition.previewOnly);
  }
}
