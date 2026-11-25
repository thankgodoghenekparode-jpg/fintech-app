import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools/sixth_merchant_tools.dart';

class _Copy implements CashierCopy {
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

class _Adapter implements CashierAdapter {
  CreateCashierCollectionRequest? request;
  @override
  Future<CashierCollectionPresentation> createCollection({
    required String tenantId,
    required CreateCashierCollectionRequest request,
  }) async {
    this.request = request;
    return const CashierCollectionPresentation(
      accessibleLabel: 'Synthetic preview QR',
      initialStatus: CashierCollectionStatus.waiting,
      shareText: 'Synthetic preview link',
    );
  }
}

void main() {
  testWidgets('requires a positive amount before creating a collection', (
    tester,
  ) async {
    final adapter = _Adapter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [cashierAdapterProvider.overrideWithValue(adapter)],
        child: MaterialApp(
          home: CashierPage(
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
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('cashier-create')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('cashier-key-1')));
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('cashier-create')))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const Key('cashier-create')));
    await tester.pumpAndSettle();
    expect(adapter.request?.amountKobo, 100);
    expect(find.byKey(const ValueKey('cashier-collection')), findsOneWidget);
  });
}
