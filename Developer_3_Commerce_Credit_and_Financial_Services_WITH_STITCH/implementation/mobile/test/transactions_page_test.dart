import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

class _Copy implements TransactionsCopy {
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

class _Adapter implements MerchantTransactionsAdapter {
  @override
  Future<TransactionsSnapshot> load({
    required String tenantId,
    DateTime? from,
    DateTime? to,
  }) async => const TransactionsSnapshot(
    availableBalanceKobo: 50000,
    transactions: [
      MerchantTransactionRow(
        id: 'txn-a',
        title: 'Sample collection',
        subtitle: 'Preview fixture',
        amountKobo: 12500,
        flow: TransactionFlow.incoming,
        state: MerchantTransactionState.completed,
      ),
    ],
  );
  @override
  Future<void> requestPayout({
    required String tenantId,
    required int amountKobo,
    required String destinationId,
  }) async {}
}

void main() {
  testWidgets('renders host supplied balance and transaction', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          merchantTransactionsAdapterProvider.overrideWithValue(_Adapter()),
        ],
        child: MaterialApp(
          home: TransactionsPage(
            tenantId: 'preview-tenant',
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
    expect(find.text('Sample collection'), findsOneWidget);
    expect(find.text('\u20A6500.00'), findsOneWidget);
  });
  testWidgets('filters collections and payout rows from mapped data', (
    tester,
  ) async {
    final adapter = _Adapter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          merchantTransactionsAdapterProvider.overrideWithValue(adapter),
        ],
        child: MaterialApp(
          home: TransactionsPage(
            tenantId: 'preview-tenant',
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
    await tester.tap(find.text('payouts').first);
    await tester.pumpAndSettle();
    expect(find.text('Sample collection'), findsNothing);
  });
}
