// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

void main() {
  testWidgets(
      'Vault detail renders host data and updates auto-debit by adapter',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _VaultAdapter();
    await tester.pumpWidget(_app(VaultDetailPage(
      adapter: adapter,
      planId: 'plan-1',
    )));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Synthetic saved'), findsOneWidget);
    expect(find.textContaining('Synthetic target'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Synthetic item'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Synthetic item'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('auto-debit-plan-1')),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('auto-debit-plan-1')));
    await tester.pumpAndSettle();
    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.toJson(), {'enabled': false});
    expect(tester.takeException(), isNull);
  });

  testWidgets('Vault detail shows retry on load error and update error',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _VaultAdapter()..failLoad = true;
    await tester.pumpWidget(_app(VaultDetailPage(
      adapter: adapter,
      planId: 'plan-1',
    )));
    await tester.pumpAndSettle();
    expect(
        find.text('Vault details are unavailable right now.'), findsOneWidget);
    adapter.failLoad = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('auto-debit-plan-1')),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    adapter.failUpdate = true;
    await tester.tap(find.byKey(const ValueKey('auto-debit-plan-1')));
    await tester.pumpAndSettle();
    expect(find.text('Auto-debit could not be updated. Try again.'),
        findsOneWidget);
  });

  testWidgets('deadline action is available only with host authority',
      (tester) async {
    String? openedPlanId;
    await tester.pumpWidget(_app(VaultDetailPage(
      adapter: _VaultAdapter(deadlineAvailable: true),
      planId: 'plan-1',
      onDeadlineDecision: (planId) async => openedPlanId = planId,
    )));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review deadline options'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Review deadline options'));
    await tester.pumpAndSettle();
    expect(openedPlanId, 'plan-1');
  });

  for (final size in [const Size(390, 844), const Size(320, 720)]) {
    for (final brightness in Brightness.values) {
      testWidgets('Vault Detail fits $size in $brightness', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(_app(
          VaultDetailPage(adapter: _VaultAdapter(), planId: 'plan-1'),
          brightness: brightness,
        ));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Synthetic item'),
          180,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Synthetic item'), findsOneWidget);
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

class _VaultAdapter implements PayAmSmallVaultAdapter {
  _VaultAdapter({this.deadlineAvailable = false});

  final bool deadlineAvailable;
  bool failLoad = false;
  bool failUpdate = false;
  final requests = <PasAutoDebitRequest>[];

  @override
  Future<PasVaultDetail> loadVault(String planId) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (failLoad) throw StateError('Synthetic unavailable');
    return PasVaultDetail(
      id: 'plan-1',
      title: 'Synthetic vault',
      status: 'Preview status',
      progress: .45,
      progressLabel: 'Synthetic progress',
      savedLabel: 'Synthetic saved',
      targetLabel: 'Synthetic target',
      deadlineLabel: 'Synthetic deadline',
      remainingTimeLabel: 'Synthetic remaining time',
      remainingLabel: 'Synthetic remaining amount',
      deadlineDecisionAvailable: deadlineAvailable,
      items: const [
        PasVaultItem(
          title: 'Synthetic item',
          vendorLabel: 'Synthetic vendor',
          priceLabel: 'Synthetic price',
        ),
      ],
      autoDebit: const PasVaultAutoDebit(
        enabled: true,
        title: 'Synthetic auto-debit',
        amountLabel: 'Synthetic amount',
        nextRunLabel: 'Synthetic date',
        sourceAccountLabel: 'Synthetic account',
      ),
      contributions: const [
        PasVaultContribution(
          title: 'Synthetic contribution',
          dateLabel: 'Synthetic date',
          amountLabel: 'Synthetic amount',
          statusLabel: 'Synthetic status',
        ),
      ],
    );
  }

  @override
  Future<void> setAutoDebit(PasAutoDebitRequest request) async {
    requests.add(request);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (failUpdate) throw StateError('Synthetic update failure');
  }
}
