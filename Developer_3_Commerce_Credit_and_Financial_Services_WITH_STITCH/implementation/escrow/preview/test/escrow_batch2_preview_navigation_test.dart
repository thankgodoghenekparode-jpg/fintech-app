// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow_preview/main.dart';

void main() {
  testWidgets(
      'preview directory opens all Batch 2 routes and terms link forward',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const EscrowPreviewApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Escrow preview screens'), findsOneWidget);

    await tester.tap(find.textContaining('S-ESC-004'));
    await tester.pumpAndSettle();
    expect(find.text('Invite and negotiate'), findsOneWidget);
    await _scrollTo(
        tester, find.textContaining('no counterparty has been invited'));
    expect(find.textContaining('no counterparty has been invited'),
        findsOneWidget);

    await _scrollTo(tester, find.text('Review deal terms'));
    await tester.tap(find.text('Review deal terms'));
    await tester.pumpAndSettle();
    expect(find.text('Deal summary and accept'), findsOneWidget);
    expect(find.textContaining('Synthetic example'), findsOneWidget);
    expect(find.text('Continue to funding'), findsNothing);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await _scrollTo(tester, find.textContaining('S-ESC-006'));
    await tester.tap(find.textContaining('S-ESC-006'));
    await tester.pumpAndSettle();
    expect(find.text('Fund deal'), findsOneWidget);
    await _scrollTo(tester, find.textContaining('No payment, bank transfer'));
    expect(find.textContaining('No payment, bank transfer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  final listView = find.byType(ListView).last;
  await tester.scrollUntilVisible(
    finder,
    250,
    scrollable: find
        .descendant(
          of: listView,
          matching: find.byType(Scrollable),
        )
        .first,
  );
}
