// ignore: deprecated_member_use // Flutter's SDK test viewport API is retained by this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small_preview/main.dart';

void main() {
  testWidgets(
      'registers gated credit and report routes in non-production shell',
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
    await tester.tap(find.textContaining('S-PAS-011'));
    await tester.pumpAndSettle();
    expect(find.text('Credit repayment'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('legal approval'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('legal approval'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Make repayment'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('S-PAS-010'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Report a delivery problem'));
    await tester.pumpAndSettle();
    expect(find.text('Report an order problem'), findsOneWidget);
    expect(find.textContaining('approved report options'), findsOneWidget);
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
