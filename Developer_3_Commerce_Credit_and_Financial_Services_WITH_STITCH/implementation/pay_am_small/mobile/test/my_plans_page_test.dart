// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() {
  testWidgets('My Plans loads, filters groups, and opens selected vault',
      (tester) async {
    final adapter = _PlansAdapter();
    String? opened;
    await tester.pumpWidget(_app(
      MyPlansPage(
        adapter: adapter,
        copy: const PayAmSmallCopy(),
        onOpenVault: (id) => opened = id,
      ),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Synthetic total'), findsOneWidget);
    expect(find.text('Freezer'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Old plan'), findsOneWidget);
    expect(find.text('Freezer'), findsNothing);

    await tester.tap(find.text('Vaults'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-vault-plan-1')));
    expect(opened, 'plan-1');
    expect(adapter.calls, 1);
  });

  testWidgets('My Plans shows an empty group and retryable errors',
      (tester) async {
    final adapter = _PlansAdapter()..fail = true;
    await tester.pumpWidget(_app(
      MyPlansPage(
        adapter: adapter,
        copy: const PayAmSmallCopy(),
        onOpenVault: (_) {},
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('We couldn’t load your plans.'), findsOneWidget);
    adapter.fail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Credit'));
    await tester.pumpAndSettle();
    expect(find.text('No credit plans yet'), findsOneWidget);
  });

  for (final size in [const Size(390, 844), const Size(320, 720)]) {
    for (final brightness in Brightness.values) {
      testWidgets('My Plans fits $size in $brightness', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(_app(
          MyPlansPage(
            adapter: _PlansAdapter(),
            copy: const PayAmSmallCopy(),
            onOpenVault: (_) {},
          ),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        expect(find.text('My Installment Plans'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

Widget _app(Widget child, {Brightness brightness = Brightness.light}) =>
    MaterialApp(
      theme: ThemeData(
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8E1B4A),
          brightness: brightness,
        ),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      home: child,
    );

class _PlansAdapter implements PayAmSmallPlansAdapter {
  bool fail = false;
  int calls = 0;

  @override
  Future<PasPlanListData> loadPlans() async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (fail) throw StateError('Synthetic failure');
    return const PasPlanListData(
      totalValueLabel: 'Synthetic total',
      totalSavedLabel: 'Synthetic saved',
      activeVaultCountLabel: '1',
      creditCountLabel: '0',
      entries: [
        PasPlanListEntry(
          id: 'plan-1',
          group: PasPlanGroup.vault,
          title: 'Freezer',
          vendorName: 'Sample shop',
          status: 'Preview active',
          amountSummary: 'Synthetic amount labels',
          progress: .45,
          progressLabel: 'Synthetic progress',
          deadlineLabel: 'Synthetic deadline',
        ),
        PasPlanListEntry(
          id: 'plan-old',
          group: PasPlanGroup.completed,
          title: 'Old plan',
          vendorName: 'Sample shop',
          status: 'Preview completed',
          amountSummary: 'Synthetic completed labels',
          progress: 1,
          progressLabel: 'Synthetic complete',
          deadlineLabel: 'Synthetic deadline',
        ),
      ],
    );
  }
}
