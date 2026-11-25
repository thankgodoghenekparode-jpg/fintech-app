// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

class _Adapter implements PayAmSmallBrowseAdapter {
  _Adapter(this.detail);
  final PasProductDetail? detail;

  @override
  Future<List<PasMarketplaceProduct>> loadMarketplace({String? query}) async =>
      const [];
  @override
  Future<PasProductDetail?> loadProduct(String productId) async => detail;
  @override
  Future<PasVendorStorefront?> loadStorefront(String vendorId) async => null;
}

PasProductDetail _detail({
  bool available = true,
  Set<PasPurchaseOption> options = const {PasPurchaseOption.priceLock},
}) =>
    PasProductDetail(
      product: PasMarketplaceProduct(
        id: 'p1',
        title: 'Sample product',
        vendorId: 'v1',
        vendorName: 'Sample vendor',
        priceKobo: 9900,
        isAvailable: available,
        isVerifiedVendor: true,
        availableOptions: options,
      ),
      deliveryTerms: 'Host supplied delivery terms.',
      priceLockTerms: 'Host supplied price-lock terms.',
    );

void main() {
  testWidgets('product details retains its layout in the dark theme', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: ProductDetailPage(
          adapter: _Adapter(_detail()),
          copy: const PayAmSmallCopy(),
          productId: 'p1',
          onOpenVendor: (_) {},
          onContinue: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(Theme.of(tester.element(find.text('Sample product'))).brightness,
        Brightness.dark);
    expect(find.text('Purchase options'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'delivery terms remain scrollable above the persistent Continue button on mobile',
    (tester) async {
      for (final size in [const Size(390, 844), const Size(320, 720)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(
          MaterialApp(
            home: ProductDetailPage(
              adapter: _Adapter(_detail()),
              copy: const PayAmSmallCopy(),
              productId: 'p1',
              onOpenVendor: (_) {},
              onContinue: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        final button = find.widgetWithText(FilledButton, 'Continue');
        final initialButtonTop = tester.getTopLeft(button).dy;
        expect(
            tester.getBottomRight(button).dy, lessThanOrEqualTo(size.height));

        await tester.scrollUntilVisible(
          find.text('Host supplied delivery terms.'),
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        final terms = find.text('Host supplied delivery terms.');
        expect(terms, findsOneWidget);
        expect(tester.getTopLeft(button).dy, initialButtonTop);
        expect(tester.getBottomRight(terms).dy,
            lessThanOrEqualTo(initialButtonTop));
        expect(tester.takeException(), isNull);
      }
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    },
  );

  testWidgets(
    'product detail displays supported host terms, option and navigation',
    (tester) async {
      PasPurchaseOption? continuedWith;
      String? vendorId;
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailPage(
            adapter: _Adapter(_detail()),
            copy: const PayAmSmallCopy(),
            productId: 'p1',
            onOpenVendor: (id) => vendorId = id,
            onContinue: (option) => continuedWith = option,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sample product'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Host supplied delivery terms.'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Host supplied delivery terms.'), findsOneWidget);
      expect(find.text('Host supplied price-lock terms.'), findsOneWidget);
      expect(find.text('Price-lock'), findsOneWidget);
      expect(find.textContaining('Credit'), findsNothing);
      await tester.tap(find.text('Sample vendor'));
      expect(vendorId, 'v1');
      await tester.tap(find.text('Continue'));
      expect(continuedWith, PasPurchaseOption.priceLock);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unavailable product disables Continue and absent options show unavailable state',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailPage(
            adapter: _Adapter(_detail(available: false)),
            copy: const PayAmSmallCopy(),
            productId: 'p1',
            onOpenVendor: (_) {},
            onContinue: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Out of stock'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Out of stock'), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Continue'),
      );
      expect(button.onPressed, isNull);

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailPage(
            adapter: _Adapter(_detail(options: const {})),
            copy: const PayAmSmallCopy(),
            productId: 'p1',
            onOpenVendor: (_) {},
            onContinue: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('This option is unavailable'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('This option is unavailable'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('missing product displays not found state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailPage(
          adapter: _Adapter(null),
          copy: const PayAmSmallCopy(),
          productId: 'missing',
          onOpenVendor: (_) {},
          onContinue: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('This item is unavailable'), findsOneWidget);
  });
}
