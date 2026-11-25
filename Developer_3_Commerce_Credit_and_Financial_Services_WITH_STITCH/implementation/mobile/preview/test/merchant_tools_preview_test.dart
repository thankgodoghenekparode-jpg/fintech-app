import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_merchant_tools_preview/main.dart';

void main() {
  testWidgets('More directory lists all Merchant screens without a picker',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MerchantToolsPreviewApp());
    await tester.pumpAndSettle();

    expect(find.text('More'), findsWidgets);
    for (final screenId in [
      'S-MER-001',
      'S-MER-002',
      'S-MER-010',
      'S-MER-003',
      'S-MER-004',
      'S-MER-007',
      'S-MER-005',
      'S-MER-006',
      'S-MER-008',
      'S-MER-009',
    ]) {
      for (var attempt = 0;
          find.text(screenId).evaluate().isEmpty && attempt < 20;
          attempt++) {
        await tester.drag(
          find.byKey(const ValueKey('merchant-more-directory')),
          const Offset(0, -240),
        );
        await tester.pumpAndSettle();
      }
      expect(find.text(screenId), findsOneWidget);
    }
    expect(find.byType(DropdownButtonFormField<dynamic>), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bank tabs outside Developer 3 are marked host-owned',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MerchantToolsPreviewApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.compare_arrows_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Payments belongs to the host app'), findsOneWidget);
    expect(
      find.text(
          'This isolated Developer 3 preview contains Merchant tools only.'),
      findsOneWidget,
    );
    expect(find.textContaining('PREVIEW ONLY'), findsOneWidget);
  });

  testWidgets('bottom navigation labels fit narrow mobile widths',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in [const Size(390, 844), const Size(320, 720)]) {
      tester.view.physicalSize = viewport;
      await tester.pumpWidget(
        MerchantToolsPreviewApp(key: ValueKey(viewport.width)),
      );
      await tester.pumpAndSettle();

      for (final label in [
        'Home',
        'Payments',
        'Cards',
        'Save & Borrow',
        'More',
      ]) {
        final labelFinder = find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        );
        expect(labelFinder, findsOneWidget, reason: 'at ${viewport.width}px');
        final paragraph = tester.renderObject<RenderParagraph>(labelFinder);
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: '$label should not be clipped at ${viewport.width}px',
        );
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Business Home loading fits and can return to More',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in [const Size(390, 844), const Size(320, 720)]) {
      tester.view.physicalSize = viewport;
      await tester.pumpWidget(
        MerchantToolsPreviewApp(key: ValueKey(viewport.width)),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('preview-business-tools-entry')),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'loading at $viewport');
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('merchant-home-content')),
        findsOneWidget,
      );
      expect(find.byTooltip('Back to More'), findsOneWidget);
      final firstAction = find.byKey(
        const ValueKey('business-home-action-collect'),
      );
      for (var attempt = 0;
          firstAction.evaluate().isEmpty && attempt < 6;
          attempt++) {
        await tester.drag(
          find.byKey(const ValueKey('merchant-home-content')),
          const Offset(0, -220),
        );
        await tester.pumpAndSettle();
      }

      final actionHeights = [
        for (final action in ['collect', 'paymentLink', 'invoice', 'refund'])
          tester
              .getSize(find.byKey(ValueKey('business-home-action-$action')))
              .height,
      ];
      expect(actionHeights.toSet(), hasLength(1));
      expect(tester.takeException(), isNull, reason: 'content at $viewport');

      await tester.tap(find.byTooltip('Back to More'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('merchant-more-directory')),
        findsOneWidget,
      );
    }
  });
}
