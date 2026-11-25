// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow_preview/main.dart';

void main() {
  testWidgets('Batch 1 preview navigates through all three screens safely',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const EscrowPreviewApp());
    await tester.pumpAndSettle();
    expect(
        find.textContaining('NON-PRODUCTION ESCROW PREVIEW'), findsOneWidget);
    expect(find.text('Synthetic goods deal'), findsOneWidget);

    await tester.tap(find.text('New deal'));
    await tester.pumpAndSettle();
    expect(find.text('Create deal'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Preview draft');
    await tester.enterText(find.byType(TextFormField).at(2), '1.00');
    await tester.scrollUntilVisible(
      find.text('Continue'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Fees and cancellation terms'), findsWidgets);
    expect(
      find.text(
          'Fee options and fee amounts have not been supplied by the host.'),
      findsOneWidget,
    );
    expect(find.textContaining('No API, auth, PIN'), findsOneWidget);
  });
}
