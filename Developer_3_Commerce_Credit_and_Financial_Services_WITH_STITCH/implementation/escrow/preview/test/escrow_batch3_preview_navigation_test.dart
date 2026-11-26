// ignore: deprecated_member_use // The preview uses Flutter's Material widgets.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow_preview/main.dart';

void main() {
  testWidgets('preview directory registers and opens Batch 3 screens',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const EscrowPreviewApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    for (final entry in [
      ('S-ESC-007', 'Deal details'),
      ('S-ESC-008', 'Submit delivery'),
      ('S-ESC-009', 'Confirm delivery'),
      ('S-ESC-010', 'Open dispute'),
      ('S-ESC-011', 'Dispute status'),
      ('S-ESC-012', 'Cancel deal'),
      ('S-ESC-013', 'Receipt and rating'),
    ]) {
      await tester.scrollUntilVisible(
        find.textContaining(entry.$1),
        220,
        scrollable: find
            .descendant(
              of: find.byType(ListView).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.textContaining(entry.$1));
      await tester.pumpAndSettle();
      expect(find.text(entry.$2), findsWidgets);
      if (entry.$1 == 'S-ESC-007') {
        expect(find.text('Deal information is unavailable.'), findsOneWidget);
      } else if (entry.$1 == 'S-ESC-010') {
        await tester.scrollUntilVisible(
          find.text('Supporting evidence'),
          240,
          scrollable: find
              .descendant(
                of: find.byType(ListView).last,
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.text('Reason'), findsOneWidget);
        expect(find.text('Options provided by the host'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Supporting evidence'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Submit dispute'),
          240,
          scrollable: find
              .descendant(
                of: find.byType(ListView).last,
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Submit dispute'))
              .onPressed,
          isNull,
        );
      } else if (entry.$1 == 'S-ESC-011') {
        expect(
            find.text('PREVIEW SAMPLE · not a customer case'), findsOneWidget);
        for (final stage in [
          'Opened',
          'Evidence due',
          'Review',
          'Decision',
          'Appeal window',
        ]) {
          await _scrollIntoView(tester, find.text(stage));
          expect(find.text(stage), findsOneWidget);
        }
        await _scrollIntoView(
          tester,
          find.textContaining('Appeal availability is not provided in preview'),
        );
        expect(
            find.textContaining(
                'Appeal availability is not provided in preview'),
            findsOneWidget);
      } else if (entry.$1 == 'S-ESC-012') {
        expect(find.text('Cancellation details'), findsOneWidget);
        await _scrollIntoView(tester, find.text('Reason options unavailable'));
        expect(find.text('Reason options unavailable'), findsOneWidget);
        await _scrollIntoView(tester, find.text('Confirm cancellation'));
        expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Confirm cancellation'))
              .onPressed,
          isNull,
        );
      } else if (entry.$1 == 'S-ESC-013') {
        expect(find.text('Deal receipt'), findsOneWidget);
        await _scrollIntoView(tester, find.text('Rate the other party'));
        expect(find.text('Rate the other party'), findsOneWidget);
        await _scrollIntoView(
            tester, find.text('Receipt details are not supplied by the host.'));
        expect(find.text('Receipt details are not supplied by the host.'),
            findsOneWidget);
        await _scrollIntoView(tester, find.text('Submit rating'));
        expect(
          tester
              .widget<FilledButton>(
                  find.widgetWithText(FilledButton, 'Submit rating'))
              .onPressed,
          isNull,
        );
      } else {
        expect(
            find.textContaining('Synthetic preview example'), findsOneWidget);
      }
      final caught = tester.takeException();
      expect(caught, isNull, reason: entry.$1);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}

Future<void> _scrollIntoView(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    220,
    scrollable: find
        .descendant(
            of: find.byType(ListView).last, matching: find.byType(Scrollable))
        .first,
  );
}
