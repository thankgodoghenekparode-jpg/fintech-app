// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small_preview/main.dart';

void main() {
  testWidgets(
      'Add Money and Withdraw are registered and preserve preview notice',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PayAmSmallPreviewApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('S-PAS-006'));
    await tester.pumpAndSettle();
    expect(find.text('Haier 200L Freezer Vault'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Add Money'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Add Money'));
    await tester.pumpAndSettle();
    expect(find.text('Add money'), findsOneWidget);
    expect(find.text('Preview only. No money was moved.'), findsNothing);
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Haier 200L Freezer Vault'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Withdraw'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Withdraw'));
    await tester.pumpAndSettle();
    expect(find.text('Withdraw'), findsOneWidget);
    expect(find.textContaining('No withdrawal quote'), findsOneWidget);
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
