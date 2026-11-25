// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small_preview/main.dart';

void main() {
  testWidgets('Deadline and order routes are safe, registered previews',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PayAmSmallPreviewApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('S-PAS-009'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a vault action'), findsOneWidget);
    expect(
      find.textContaining('Extension fee and deadline terms'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Confirm decision'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byTooltip('Use dark mode'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Choose a vault action'))).brightness,
      Brightness.dark,
    );

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('S-PAS-010'));
    await tester.pumpAndSettle();
    expect(find.text('Order tracking'), findsOneWidget);
    expect(
        find.text('Tracking updates are not available yet.'), findsOneWidget);
    expect(
      find.textContaining('Delivery code is unavailable'),
      findsOneWidget,
    );
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
