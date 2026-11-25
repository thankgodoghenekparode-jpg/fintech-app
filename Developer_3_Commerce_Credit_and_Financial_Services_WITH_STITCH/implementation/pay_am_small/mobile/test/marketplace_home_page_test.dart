// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

class _Adapter implements PayAmSmallBrowseAdapter {
  _Adapter({this.products = const [], this.failure});

  final List<PasMarketplaceProduct> products;
  final Object? failure;
  String? lastQuery;

  @override
  Future<List<PasMarketplaceProduct>> loadMarketplace({String? query}) async {
    lastQuery = query;
    if (failure != null) throw failure!;
    return products;
  }

  @override
  Future<PasProductDetail?> loadProduct(String productId) async => null;

  @override
  Future<PasVendorStorefront?> loadStorefront(String vendorId) async => null;
}

PasMarketplaceProduct _product({
  required String id,
  required String category,
  required String vendor,
}) =>
    PasMarketplaceProduct(
      id: id,
      title: 'Sample $id',
      vendorId: vendor,
      vendorName: 'Vendor $vendor',
      category: category,
      priceKobo: 123450,
      isVerifiedVendor: true,
      availableOptions: const {PasPurchaseOption.priceLock},
    );

Widget _page(
  _Adapter adapter, {
  ValueChanged<String>? onProduct,
  ValueChanged<String>? onVendor,
}) =>
    MaterialApp(
      home: MarketplaceHomePage(
        adapter: adapter,
        copy: const PayAmSmallCopy(),
        onOpenProduct: onProduct ?? (_) {},
        onOpenVendor: onVendor ?? (_) {},
      ),
    );

void main() {
  testWidgets('marketplace layout fits standard and narrow light/dark themes',
      (tester) async {
    for (final size in [const Size(390, 844), const Size(320, 720)]) {
      for (final brightness in Brightness.values) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness),
            home: MarketplaceHomePage(
              adapter: _Adapter(
                products: [
                  _product(id: 'one', category: 'Home', vendor: 'a'),
                  _product(id: 'two', category: 'Energy', vendor: 'b'),
                ],
              ),
              copy: const PayAmSmallCopy(),
              onOpenProduct: (_) {},
              onOpenVendor: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$size $brightness');
      }
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets(
    'marketplace loads products and category filters without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final adapter = _Adapter(
        products: [
          _product(id: 'one', category: 'Home', vendor: 'a'),
          _product(id: 'two', category: 'Energy', vendor: 'b'),
        ],
      );

      await tester.pumpWidget(_page(adapter));
      await tester.pumpAndSettle();
      expect(find.text('Sample one'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Sample two'),
        240,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Sample two'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Home'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.widgetWithText(ChoiceChip, 'Home'));
      await tester.pumpAndSettle();
      expect(find.text('Sample one'), findsOneWidget);
      expect(find.text('Sample two'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'search is passed to injected adapter and product/vendor actions are exposed',
    (tester) async {
      tester.view.physicalSize = const Size(390, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final adapter = _Adapter(
        products: [_product(id: 'one', category: 'Home', vendor: 'a')],
      );
      String? openedProduct;
      String? openedVendor;
      await tester.pumpWidget(
        _page(
          adapter,
          onProduct: (id) => openedProduct = id,
          onVendor: (id) => openedVendor = id,
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'sample');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(adapter.lastQuery, 'sample');
      await tester.tap(find.text('Sample one'));
      expect(openedProduct, 'one');
      final vendorCard = find.text('Vendor a').last;
      await tester.ensureVisible(vendorCard);
      await tester.tap(vendorCard);
      expect(openedVendor, 'a');
    },
  );

  testWidgets('marketplace shows empty and retryable failure states', (
    tester,
  ) async {
    await tester.pumpWidget(_page(_Adapter()));
    await tester.pumpAndSettle();
    expect(find.text('Nothing to show yet'), findsOneWidget);

    await tester.pumpWidget(_page(_Adapter(failure: StateError('offline'))));
    await tester.pumpAndSettle();
    expect(find.text('We could not load this page'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
