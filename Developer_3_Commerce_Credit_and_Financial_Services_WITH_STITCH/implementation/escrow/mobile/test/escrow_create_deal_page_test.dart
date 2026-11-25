import 'dart:async';

// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('S-ESC-002 validates title, amount, and service milestone sum',
      (tester) async {
    _useTallViewport(tester);
    EscrowCreateDealDraft? continued;
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowCreateDealPage(
          onContinue: (draft) {
            continued = draft;
            return Future<void>.value();
          },
        ),
      ),
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a deal title.'), findsOneWidget);
    expect(continued, isNull);

    await tester.enterText(
        find.byType(TextFormField).at(0), 'Service agreement');
    await tester.enterText(find.byType(TextFormField).at(2), '100.00');
    await tester.tap(find.text('Service / milestones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Add at least one service milestone.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(4), 'First milestone');
    await tester.enterText(find.byType(TextFormField).at(5), '60.00');
    await tester.tap(find.text('Add milestone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Milestone amounts must equal the deal amount.'),
        findsOneWidget);
    expect(continued, isNull);

    await tester.tap(find.byTooltip('Remove milestone'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(4), 'First milestone');
    await tester.enterText(find.byType(TextFormField).at(5), '100.00');
    await tester.tap(find.text('Add milestone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(continued?.type, EscrowDealType.service);
    expect(continued?.milestones, hasLength(1));
  });

  testWidgets('S-ESC-002 keeps unprovided property checkpoints unavailable',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(home: EscrowCreateDealPage(onContinue: (_) async {})),
    );
    await tester.tap(find.text('Property / rent'));
    await tester.pumpAndSettle();
    expect(
      find.text('Property checkpoints require an approved host template.'),
      findsOneWidget,
    );
  });

  testWidgets('S-ESC-002 exposes loading and host submission errors',
      (tester) async {
    _useTallViewport(tester);
    final completer = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
          home: EscrowCreateDealPage(onContinue: (_) => completer.future)),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Goods deal');
    await tester.enterText(find.byType(TextFormField).at(2), '1');
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    completer.completeError(Exception('host error'));
    await tester.pumpAndSettle();
    expect(find.text('The deal could not be prepared. Try again.'),
        findsOneWidget);
  });
}

void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
