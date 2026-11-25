import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

void main() {
  group('S-MER-001 Business Home', () {
    testWidgets('shows a loading skeleton while the injected adapter loads', (
      tester,
    ) async {
      final completer = Completer<MerchantHomeSnapshot?>();
      await tester.pumpWidget(_harness(_FakeAdapter(() => completer.future)));

      expect(find.bySemanticsLabel(copy.loading), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      completer.complete(null);
      await tester.pumpAndSettle();
    });

    testWidgets('shows an empty state when there is no business to display', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(_FakeAdapter(() async => null)));
      await tester.pumpAndSettle();

      expect(find.text(copy.emptyTitle), findsOneWidget);
      expect(find.text(copy.emptyBody), findsOneWidget);
      expect(find.text(copy.createBusiness), findsOneWidget);
    });

    testWidgets('shows restricted status without a verified badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(_FakeAdapter(() async => _snapshot(isRestricted: true))),
      );
      await tester.pumpAndSettle();

      expect(find.text(copy.restricted), findsOneWidget);
      expect(find.text(copy.verified), findsNothing);
    });

    testWidgets('shows required actions and recent payments', (tester) async {
      MerchantHomeAction? selectedAction;
      await tester.pumpWidget(
        _harness(
          _FakeAdapter(() async => _snapshot()),
          onAction: (action) => selectedAction = action,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Business'), findsOneWidget);
      expect(find.text(copy.verified), findsOneWidget);
      expect(find.text(copy.collect), findsOneWidget);
      expect(find.text(copy.paymentLinkAction), findsOneWidget);
      expect(find.text(copy.invoice), findsOneWidget);
      expect(find.text(copy.refund), findsOneWidget);
      expect(find.text('Test Payer'), findsOneWidget);

      await tester.tap(find.text(copy.collect));
      expect(selectedAction, MerchantHomeAction.collect);
    });

    testWidgets(
      'lays out equal-height quick actions in the scrolling page on mobile',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester
            .pumpWidget(_harness(_FakeAdapter(() async => _snapshot())));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);

        const actionKeys = [
          ValueKey('business-home-action-collect'),
          ValueKey('business-home-action-paymentLink'),
          ValueKey('business-home-action-invoice'),
          ValueKey('business-home-action-refund'),
        ];
        final cardSizes = actionKeys.map((key) {
          final card = find.byKey(key);
          expect(card, findsOneWidget);
          return tester.getSize(card);
        }).toList();

        expect(cardSizes, hasLength(actionKeys.length));
        for (final size in cardSizes.skip(1)) {
          expect(size.height, closeTo(cardSizes.first.height, 0.01));
        }

        await tester.drag(
          find.byKey(const ValueKey('merchant-home-content')),
          const Offset(0, -160),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('masks the balance when the user toggles visibility', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(_FakeAdapter(() async => _snapshot())));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(copy.hideBalance));
      await tester.pump();
      expect(find.text('••••••••'), findsOneWidget);
      expect(find.byTooltip(copy.showBalance), findsOneWidget);
    });

    testWidgets('shows an error and retries through the injected adapter', (
      tester,
    ) async {
      var calls = 0;
      final adapter = _FakeAdapter(() async {
        calls++;
        if (calls == 1) throw Exception('test-only adapter failure');
        return _snapshot();
      });
      await tester.pumpWidget(_harness(adapter));
      await tester.pumpAndSettle();

      expect(find.text(copy.errorTitle), findsOneWidget);
      await tester.tap(find.text(copy.retry));
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(find.text('Test Business'), findsOneWidget);
    });

    testWidgets('shows a distinct offline state without stale values', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          _FakeAdapter(() async => throw const MerchantHomeOfflineException()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(copy.offlineTitle), findsOneWidget);
      expect(find.text(copy.offlineBody), findsOneWidget);
      expect(find.text('Test Business'), findsNothing);
    });

    testWidgets(
      'shows a payment empty state when the business has no payments',
      (tester) async {
        await tester.pumpWidget(
          _harness(_FakeAdapter(() async => _snapshot(payments: const []))),
        );
        await tester.pumpAndSettle();

        expect(find.text(copy.noPaymentsTitle), findsOneWidget);
        expect(find.text(copy.noPaymentsBody), findsOneWidget);
      },
    );
  });
}

// Test-only dependency seam; never used as a production adapter or data source.
class _FakeAdapter implements MerchantHomeDataAdapter {
  _FakeAdapter(this.load);
  final Future<MerchantHomeSnapshot?> Function() load;

  @override
  Future<MerchantHomeSnapshot?> loadHome({required String tenantId}) => load();
}

Widget _harness(
  MerchantHomeDataAdapter adapter, {
  ValueChanged<MerchantHomeAction>? onAction,
}) =>
    ProviderScope(
      overrides: [merchantHomeDataAdapterProvider.overrideWithValue(adapter)],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MerchantHomePage(
          tenantId: 'test-tenant',
          copy: copy,
          tokens: const MerchantHomeTokens(
            pageGutter: 16,
            sectionGap: 24,
            cardPadding: 16,
            elementGap: 12,
            smallGap: 8,
            cardRadius: 16,
            controlRadius: 12,
          ),
          onAction: onAction ?? (_) {},
          onSwitchBusiness: () {},
        ),
      ),
    );

MerchantHomeSnapshot _snapshot({
  bool isRestricted = false,
  bool? isVerified,
  List<MerchantPaymentSummary>? payments,
}) =>
    MerchantHomeSnapshot(
      businessName: 'Test Business',
      isVerified: isVerified ?? !isRestricted,
      isRestricted: isRestricted,
      // Deliberately synthetic values used only for widget coverage.
      availableBalanceKobo: 123456,
      todaySalesKobo: 23456,
      recentPayments: payments ??
          [
            MerchantPaymentSummary(
              counterparty: 'Test Payer',
              channel: MerchantPaymentChannel.qr,
              amountKobo: 2500,
              occurredAt: DateTime.utc(2026, 1, 1),
              status: MerchantPaymentStatus.settled,
            ),
          ],
    );

const copy = _TestCopy();

class _TestCopy implements MerchantHomeCopy {
  const _TestCopy();
  @override
  String get title => 'Business home';
  @override
  String get loading => 'Loading business overview';
  @override
  String get errorTitle => 'Business overview unavailable';
  @override
  String get errorBody => 'Try again';
  @override
  String get offlineTitle => "You're offline";
  @override
  String get offlineBody => 'Connect to load current business data.';
  @override
  String get retry => 'Try again';
  @override
  String get emptyTitle => 'No business account yet';
  @override
  String get emptyBody => 'Create a business account';
  @override
  String get createBusiness => 'Create business';
  @override
  String get switchBusiness => 'Switch business';
  @override
  String get verified => 'Verified';
  @override
  String get restricted => 'Restricted until verification is complete';
  @override
  String get availableBalance => 'Available business balance';
  @override
  String get balanceHidden => 'Business balance hidden';
  @override
  String get hideBalance => 'Hide business balance';
  @override
  String get showBalance => 'Show business balance';
  @override
  String get todaySales => "Today's sales";
  @override
  String get quickActions => 'Quick actions';
  @override
  String get collect => 'Collect';
  @override
  String get paymentLinkAction => 'Payment link';
  @override
  String get invoice => 'Invoice';
  @override
  String get refund => 'Refund';
  @override
  String get recentPayments => 'Recent payments';
  @override
  String get noPaymentsTitle => 'No payments yet';
  @override
  String get noPaymentsBody => 'Business payments will appear here.';
  @override
  String get settled => 'Settled';
  @override
  String get pending => 'Pending settlement';
  @override
  String get failed => 'Failed';
  @override
  String get qrChannel => 'Store QR';
  @override
  String get paymentLinkChannel => 'Payment link';
  @override
  String get bankTransferChannel => 'Bank transfer';
  @override
  String get paymentStatus => 'Payment status';
  @override
  String formatMoney(int amountKobo) => 'test money $amountKobo';
  @override
  String formatPaymentDate(DateTime dateTime) => 'test date';
}
