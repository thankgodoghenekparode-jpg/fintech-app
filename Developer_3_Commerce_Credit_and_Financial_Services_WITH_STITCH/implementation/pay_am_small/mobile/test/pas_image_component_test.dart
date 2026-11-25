// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/src/widgets/pas_components.dart';

void main() {
  testWidgets('product and vendor images fall back if an asset fails',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Column(
          children: [
            PasProductImage(image: AssetImage('assets/missing-product.png')),
            PasVendorImage(image: AssetImage('assets/missing-vendor.png')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
