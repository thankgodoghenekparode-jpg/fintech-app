// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small_preview/main.dart';

void main() {
  testWidgets('preview registers My Plans and opens its selected Vault Detail',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PayAmSmallPreviewApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-005 · My plans'));
    await tester.pumpAndSettle();
    expect(find.text('My Installment Plans'), findsOneWidget);
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(find.text('Synthetic · ₦705,000.00'), findsOneWidget);

    final openVault = find.byKey(
      const ValueKey('open-vault-synthetic-plan-001'),
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(openVault, findsOneWidget);
    await tester.tap(openVault);
    await tester.pumpAndSettle();
    expect(find.text('Haier 200L Freezer Vault'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Items in this Vault'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Items in this Vault'), findsOneWidget);
    expect(find.text('Haier Thermocool 200L Chest Freezer'), findsOneWidget);
    expect(find.textContaining('NON-PRODUCTION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview vault auto-debit switch is synthetic and theme switches',
      (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PayAmSmallPreviewApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Choose preview screen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S-PAS-006 · Vault detail'));
    await tester.pumpAndSettle();
    expect(find.text('Haier 200L Freezer Vault'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -1000));
    await tester.pumpAndSettle();
    expect(find.text('Haier 200L Freezer Vault'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('auto-debit-synthetic-plan-001')),
      findsOneWidget,
    );
    await tester
        .tap(find.byKey(const ValueKey('auto-debit-synthetic-plan-001')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('No account is linked'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('No account is linked'), findsOneWidget);
    await tester.tap(find.byTooltip('Use dark mode'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Haier 200L Freezer Vault')))
          .brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });
}
