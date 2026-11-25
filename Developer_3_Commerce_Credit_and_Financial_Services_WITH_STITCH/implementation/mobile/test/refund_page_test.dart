import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

class _Copy implements RefundCopy {
  @override
  String formatMoney(int kobo) =>
      '\u20A6${kobo ~/ 100}.${(kobo % 100).toString().padLeft(2, '0')}';
  @override
  noSuchMethod(Invocation invocation) {
    final value = invocation.memberName.toString();
    return value.startsWith('Symbol("')
        ? value.substring(8, value.length - 2)
        : value;
  }
}

class _Adapter implements MerchantRefundAdapter {
  _Adapter({this.allowed = false});
  final bool allowed;
  int submissions = 0;
  @override
  Future<RefundContext> load({
    required String tenantId,
    required String paymentId,
  }) async => RefundContext(
    paymentLabel: 'Preview payment',
    originalAmountKobo: 30000,
    allowed: allowed,
    maxRefundableAmountKobo: allowed ? 500000 : null,
    blockedReason: allowed ? null : 'Refund window unavailable',
  );
  @override
  Future<void> refund({
    required String tenantId,
    required String paymentId,
    required int amountKobo,
    required String reason,
  }) async {
    submissions++;
  }
}

void main() {
  testWidgets('renders adapter supplied blocked eligibility reason', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          merchantRefundAdapterProvider.overrideWithValue(_Adapter()),
        ],
        child: MaterialApp(
          home: RefundPage(
            tenantId: 'preview-tenant',
            paymentId: 'preview-payment',
            copy: _Copy(),
            tokens: const MerchantHomeTokens(
              pageGutter: 16,
              sectionGap: 24,
              cardPadding: 16,
              elementGap: 12,
              smallGap: 8,
              cardRadius: 12,
              controlRadius: 8,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Refund window unavailable'), findsOneWidget);
    expect(find.byKey(const Key('refund-blocked')), findsOneWidget);
  });

  testWidgets('blocks a partial amount above the original payment', (
    tester,
  ) async {
    final adapter = _Adapter(allowed: true);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [merchantRefundAdapterProvider.overrideWithValue(adapter)],
        child: MaterialApp(
          home: RefundPage(
            tenantId: 'preview-tenant',
            paymentId: 'preview-payment',
            copy: _Copy(),
            tokens: const MerchantHomeTokens(
              pageGutter: 16,
              sectionGap: 24,
              cardPadding: 16,
              elementGap: 12,
              smallGap: 8,
              cardRadius: 12,
              controlRadius: 8,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('partialRefund'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '3001.00');
    await tester.enterText(find.byType(TextField).at(1), 'Duplicate payment');
    await tester.tap(find.text('confirm').last);
    await tester.pumpAndSettle();
    expect(find.text('amountInvalid'), findsOneWidget);
    expect(adapter.submissions, 0);
  });
}
