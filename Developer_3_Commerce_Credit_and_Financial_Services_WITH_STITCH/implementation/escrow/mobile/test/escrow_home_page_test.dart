// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets('S-ESC-001 filters deal groups and opens a selected card',
      (tester) async {
    _useTallViewport(tester);
    EscrowDealCardData? opened;
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowHomePage(
          adapter: _HomeAdapter([
            _deal('a', EscrowDealGroup.active, 'Active · host'),
            _deal('b', EscrowDealGroup.disputes, 'Dispute · host'),
          ]),
          onNewDeal: () {},
          onOpenDeal: (deal) => opened = deal,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Active · host'), findsOneWidget);
    expect(find.text('Amount not supplied'), findsOneWidget);
    await tester.ensureVisible(find.text('Disputes'));
    await tester.tap(find.text('Disputes'));
    await tester.pumpAndSettle();
    expect(find.text('Dispute · host'), findsOneWidget);
    await tester.tap(find.text('Host deal b'));
    expect(opened?.id, 'b');
  });

  testWidgets('S-ESC-001 has empty, retryable error, and new-deal states',
      (tester) async {
    _useTallViewport(tester);
    final adapter = _RetryHomeAdapter();
    var newDeal = false;
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowHomePage(
          adapter: adapter,
          onNewDeal: () => newDeal = true,
          onOpenDeal: (_) {},
        ),
      ),
    );
    expect(find.text('Loading deals'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Could not load deals'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(adapter.calls, 2);
    expect(find.text('No deals in this section yet.'), findsOneWidget);
    await tester.tap(find.text('New deal'));
    expect(newDeal, isTrue);
  });
}

void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

EscrowDealCardData _deal(String id, EscrowDealGroup group, String status) =>
    EscrowDealCardData(
      id: id,
      title: 'Host deal $id',
      group: group,
      role: EscrowPartyRole.buyer,
      statusLabel: status,
    );

class _HomeAdapter implements EscrowHomeAdapter {
  _HomeAdapter(this.deals);
  final List<EscrowDealCardData> deals;

  @override
  Future<List<EscrowDealCardData>> loadDeals() async => deals;
}

class _RetryHomeAdapter implements EscrowHomeAdapter {
  var calls = 0;

  @override
  Future<List<EscrowDealCardData>> loadDeals() async {
    calls++;
    if (calls == 1) throw Exception('host unavailable');
    return const [];
  }
}
