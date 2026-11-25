// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

class _Adapter implements PayAmSmallBrowseAdapter {
  _Adapter(this.storefront, {this.failure});
  final PasVendorStorefront? storefront;
  final Object? failure;

  @override
  Future<List<PasMarketplaceProduct>> loadMarketplace({String? query}) async =>
      const [];
  @override
  Future<PasProductDetail?> loadProduct(String productId) async => null;
  @override
  Future<PasVendorStorefront?> loadStorefront(String vendorId) async {
    if (failure != null) throw failure!;
    return storefront;
  }
}

PasMarketplaceProduct _product(String id) => PasMarketplaceProduct(
      id: id,
      title: 'Sample $id',
      vendorId: 'v1',
      vendorName: 'Sample vendor',
      priceKobo: 12345,
      availableOptions: const {PasPurchaseOption.priceLock},
    );

PasVendorStorefront _vendor({
  bool suspended = false,
  List<PasMarketplaceProduct> products = const [],
}) =>
    PasVendorStorefront(
      id: 'v1',
      name: 'Sample vendor',
      isVerified: true,
      isSuspended: suspended,
      about: 'Host-supplied vendor profile.',
      deliveryTerms: 'Host-supplied delivery terms.',
      products: products,
    );

void main() {
  testWidgets('compact product cards fit their content on narrow screens',
      (tester) async {
    for (final size in [const Size(390, 844), const Size(320, 720)]) {
      for (final brightness in Brightness.values) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness),
            home: VendorStorefrontPage(
              adapter: _Adapter(
                _vendor(
                  products: [
                    _product('a household product with a long wrapped title'),
                  ],
                ),
              ),
              copy: const PayAmSmallCopy(),
              vendorId: 'v1',
              onOpenProduct: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Catalog & Price-Lock Plans'), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
        expect(
            find.textContaining('Sample a household product'), findsOneWidget);
        final exception = tester.takeException();
        expect(exception, isNull, reason: '$size $brightness: $exception');
      }
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets(
    'storefront shows profile and product cards and opens products',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String? openedProduct;
      await tester.pumpWidget(
        MaterialApp(
          home: VendorStorefrontPage(
            adapter: _Adapter(
              _vendor(products: [_product('one'), _product('two')]),
            ),
            copy: const PayAmSmallCopy(),
            vendorId: 'v1',
            onOpenProduct: (id) => openedProduct = id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sample vendor'), findsWidgets);
      expect(find.text('Host-supplied vendor profile.'), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.text('Catalog & Price-Lock Plans'), findsOneWidget);
      await tester.tap(find.text('Sample one'));
      expect(openedProduct, 'one');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'suspended vendor notice, empty, and error states are presented',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VendorStorefrontPage(
            adapter: _Adapter(_vendor(suspended: true)),
            copy: const PayAmSmallCopy(),
            vendorId: 'v1',
            onOpenProduct: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Vendor unavailable'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: VendorStorefrontPage(
            adapter: _Adapter(_vendor()),
            copy: const PayAmSmallCopy(),
            vendorId: 'v1',
            onOpenProduct: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Nothing to show yet'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Nothing to show yet'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: VendorStorefrontPage(
            adapter: _Adapter(null, failure: StateError('offline')),
            copy: const PayAmSmallCopy(),
            vendorId: 'v1',
            onOpenProduct: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('We could not load this page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
