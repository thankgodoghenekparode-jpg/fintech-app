import 'dart:async';

// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

class _PlanAdapter implements PayAmSmallPlanAdapter {
  _PlanAdapter({this.createFailure, this.createCompleter});

  final Object? createFailure;
  final Completer<PasPlanCreationResult>? createCompleter;
  PasPlanCreateRequest? receivedRequest;

  @override
  Future<PasPlanQuote> quotePlan(PasPlanQuoteRequest request) async => _quote;

  @override
  Future<PasPlanCreationResult> createPlan(PasPlanCreateRequest request) {
    receivedRequest = request;
    if (createCompleter != null) return createCompleter!.future;
    if (createFailure != null) return Future.error(createFailure!);
    return Future.value(
      const PasPlanCreationResult(PasPlanCreationDisposition.created),
    );
  }
}

const _quote = PasPlanQuote(
  quoteId: 'quote-123',
  termsVersion: 'terms-v7',
  facts: [
    PasPlanQuoteFact(
      label: 'Target amount',
      value: 'Host-supplied amount',
      emphasized: true,
    ),
    PasPlanQuoteFact(label: 'Deadline', value: 'Host-supplied date'),
    PasPlanQuoteFact(label: 'Fee', value: 'Host-supplied fee'),
  ],
  terms: [
    PasPlanTermSection(
      title: 'Price-lock promise',
      body: 'Host-supplied price-lock terms.',
    ),
    PasPlanTermSection(
      title: 'Deadline rules',
      body: 'Host-supplied deadline terms.',
    ),
  ],
);

const _product = PasMarketplaceProduct(
  id: 'product-123',
  title: 'Sample product',
  vendorId: 'vendor-123',
  vendorName: 'Sample vendor',
  priceKobo: 10000,
  availableOptions: {PasPurchaseOption.priceLock},
);

Widget _page({
  required PayAmSmallPlanAdapter adapter,
  required VoidCallback onRefresh,
}) =>
    MaterialApp(
      home: PlanReviewPage(
        adapter: adapter,
        copy: const PayAmSmallCopy(),
        quote: _quote,
        products: const [_product],
        onRefreshQuote: onRefresh,
      ),
    );

void main() {
  testWidgets(
      'requires consent, forwards quote credentials, then shows success',
      (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final completer = Completer<PasPlanCreationResult>();
    final adapter = _PlanAdapter(createCompleter: completer);

    await tester.pumpWidget(_page(adapter: adapter, onRefresh: () {}));
    await tester.pumpAndSettle();
    final accept =
        find.widgetWithText(FilledButton, 'Accept & continue to PIN');
    expect(tester.widget<FilledButton>(accept).onPressed, isNull);

    await tester.scrollUntilVisible(
      find.text('Terms & Merchant Agreement'),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();
    expect(find.text('Host-supplied deadline terms.'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -180));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(tester.widget<FilledButton>(accept).onPressed, isNotNull);
    await tester.tap(accept);
    await tester.pump();

    expect(find.text('Waiting for host authorization…'), findsOneWidget);
    expect(adapter.receivedRequest?.quoteId, 'quote-123');
    expect(adapter.receivedRequest?.termsVersion, 'terms-v7');
    completer.complete(
      const PasPlanCreationResult(PasPlanCreationDisposition.created),
    );
    await tester.pumpAndSettle();
    expect(find.text('Plan created'), findsOneWidget);
    expect(find.text('Your plan was created successfully.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'terms-changed failure offers refresh and generic error can retry',
      (tester) async {
    var refreshCount = 0;
    final adapter = _PlanAdapter(
      createFailure: const PasPlanFailure(PasPlanFailureKind.termsChanged),
    );
    await tester.pumpWidget(
      _page(adapter: adapter, onRefresh: () => refreshCount++),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(CheckboxListTile),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(
      find.widgetWithText(FilledButton, 'Accept & continue to PIN'),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('The plan terms changed. Refresh the quote before accepting.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Refresh quote'));
    expect(refreshCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports a host-mapped restricted/error response',
      (tester) async {
    final adapter = _PlanAdapter(
      createFailure: const PasPlanFailure(PasPlanFailureKind.restricted),
    );
    await tester.pumpWidget(_page(adapter: adapter, onRefresh: () {}));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(CheckboxListTile),
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(
      find.widgetWithText(FilledButton, 'Accept & continue to PIN'),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Plan setup is unavailable for this account.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
