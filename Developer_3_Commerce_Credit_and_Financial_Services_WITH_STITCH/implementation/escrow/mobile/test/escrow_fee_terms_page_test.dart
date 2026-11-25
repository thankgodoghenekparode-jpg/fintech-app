// ignore: deprecated_member_use // The SDK replacement package is not shipped here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_escrow/escrow.dart';

void main() {
  testWidgets(
      'S-ESC-003 keeps fee-dependent continuation unavailable without host terms',
      (tester) async {
    _useTallViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowFeeTermsPage(
          adapter: _TermsAdapter(null),
          draft: _draft,
          dealId: null,
          onContinue: (_) async {},
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Fee options and fee amounts have not been supplied by the host.'),
        findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets(
      'S-ESC-003 loads host options, validates split and acceptance, then saves',
      (tester) async {
    _useTallViewport(tester);
    final adapter = _TermsAdapter(
      const EscrowFeeTermsPresentation(
        scenarios: [
          EscrowFeeScenario(
            key: 'host-scenario-key',
            label: 'Before funding',
            options: [
              EscrowFeeOption(
                  label: 'Host-supplied choice',
                  requestValue: 'host-option-value'),
            ],
          ),
        ],
        plainSummary: 'Host-supplied terms summary',
      ),
    );
    EscrowFeeTermsSelection? continued;
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowFeeTermsPage(
          adapter: adapter,
          draft: _draft,
          dealId: 'host-mapped-deal-id',
          onContinue: (selection) async => continued = selection,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Split'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '40');
    final scenarioPicker = tester.widget<DropdownButtonFormField<int>>(
      find.byType(DropdownButtonFormField<int>),
    );
    expect(scenarioPicker.onChanged, isNotNull);
    scenarioPicker.onChanged!(0);
    await tester.pumpAndSettle();

    var button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    await tester.tap(find.text('I have reviewed the supplied terms'));
    await tester.pumpAndSettle();
    button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(adapter.saved, isNotNull);
    expect(adapter.saved!.splitBuyerBps, 4000);
    expect(adapter.saved!.scenarioOptions,
        {'host-scenario-key': 'host-option-value'});
    expect(continued?.acceptedSummary, isTrue);
  });

  testWidgets('S-ESC-003 reports adapter errors and can retry loading',
      (tester) async {
    _useTallViewport(tester);
    final adapter = _TermsAdapter(null)..throwOnFirstLoad = true;
    await tester.pumpWidget(
      MaterialApp(
        home: EscrowFeeTermsPage(
          adapter: adapter,
          draft: _draft,
          dealId: 'host-deal',
          onContinue: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Could not load terms'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(adapter.loads, 2);
    expect(
        find.text(
            'Fee options and fee amounts have not been supplied by the host.'),
        findsOneWidget);
  });
}

void _useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

const _draft = EscrowCreateDealDraft(
  type: EscrowDealType.goods,
  role: EscrowPartyRole.buyer,
  title: 'Host-provided test draft',
  description: '',
  amount: '1.00',
  timelineDescription: '',
  milestones: [],
);

class _TermsAdapter implements EscrowFeeTermsAdapter {
  _TermsAdapter(this.presentation);
  final EscrowFeeTermsPresentation? presentation;
  bool throwOnFirstLoad = false;
  int loads = 0;
  EscrowFeeTermsSelection? saved;

  @override
  Future<EscrowFeeTermsPresentation?> loadTerms({
    required String? dealId,
    required EscrowCreateDealDraft draft,
  }) async {
    loads++;
    if (throwOnFirstLoad && loads == 1) throw Exception('host error');
    return presentation;
  }

  @override
  Future<void> saveTerms({
    required String dealId,
    required EscrowFeeTermsSelection selection,
  }) async {
    saved = selection;
  }
}
