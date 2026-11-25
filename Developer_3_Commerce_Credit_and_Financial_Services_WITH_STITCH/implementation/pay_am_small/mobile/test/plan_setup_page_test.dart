import 'dart:async';

// ignore: deprecated_member_use // Flutter's SDK replacement package is not shipped with this SDK.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixth_pay_am_small/pay_am_small.dart';

class _PlanAdapter implements PayAmSmallPlanAdapter {
  _PlanAdapter({
    this.quoteFailure,
    this.quoteCompleter,
  });

  final Object? quoteFailure;
  final Completer<PasPlanQuote>? quoteCompleter;
  final requests = <PasPlanQuoteRequest>[];

  @override
  Future<PasPlanQuote> quotePlan(PasPlanQuoteRequest request) {
    requests.add(request);
    if (quoteCompleter != null) return quoteCompleter!.future;
    if (quoteFailure != null) return Future.error(quoteFailure!);
    return Future.value(_quote);
  }

  @override
  Future<PasPlanCreationResult> createPlan(
          PasPlanCreateRequest request) async =>
      const PasPlanCreationResult(PasPlanCreationDisposition.created);
}

const _quote = PasPlanQuote(
  quoteId: 'quote-1',
  termsVersion: 'terms-v1',
  facts: [
    PasPlanQuoteFact(
      label: 'Quote total',
      value: 'Host-supplied quote value',
      emphasized: true,
    ),
    PasPlanQuoteFact(label: 'Fees', value: 'Host-supplied fee details'),
  ],
  terms: [
    PasPlanTermSection(
      title: 'Deadline terms',
      body: 'Host-supplied deadline terms.',
    ),
    PasPlanTermSection(
      title: 'Cancellation terms',
      body: 'Host-supplied cancellation terms.',
    ),
  ],
);

PasMarketplaceProduct _product() => const PasMarketplaceProduct(
      id: 'product-1',
      title: 'Sample product',
      vendorId: 'vendor-1',
      vendorName: 'Sample vendor',
      priceKobo: 10000,
      availableOptions: {PasPurchaseOption.priceLock},
    );

void main() {
  testWidgets('quotes documented fields and forwards quote to review',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _PlanAdapter();
    PasPlanQuote? openedQuote;

    await tester.pumpWidget(
      MaterialApp(
        home: PlanSetupPage(
          adapter: adapter,
          copy: const PayAmSmallCopy(),
          products: [_product()],
          onReview: (quote) => openedQuote = quote,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(adapter.requests, hasLength(1));
    expect(
      adapter.requests.single.toJson(),
      {
        'productIds': ['product-1'],
        'mode': 'PRICE_LOCK'
      },
    );
    expect(find.text('Host-supplied quote value'), findsOneWidget);
    expect(find.text('Host-supplied deadline terms.'), findsOneWidget);
    final automatedSegment = tester.widget<SegmentedButton<bool>>(
      find.byType(SegmentedButton<bool>),
    );
    expect(automatedSegment.segments.last.enabled, isFalse);

    await tester.tap(find.text('Review Plan Summary & Terms'));
    expect(openedQuote, same(_quote));
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports deadline selection and server validation errors',
      (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final adapter = _PlanAdapter();

    await tester.pumpWidget(
      MaterialApp(
        home: PlanSetupPage(
          adapter: adapter,
          copy: const PayAmSmallCopy(),
          products: [_product()],
          onReview: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose a deadline'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.last.deadline, isNotNull);
    expect(adapter.requests.last.toJson().keys,
        containsAll(['productIds', 'mode', 'deadline']));
    expect(adapter.requests.last.toJson().containsKey('autoSave'), isFalse);
    expect(tester.takeException(), isNull);

    final invalidAdapter = _PlanAdapter(
      quoteFailure: const PasPlanFailure(PasPlanFailureKind.invalidDeadline),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PlanSetupPage(
          adapter: invalidAdapter,
          copy: const PayAmSmallCopy(),
          products: [_product()],
          onReview: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Choose a deadline within the vendor’s committed lock window.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows quote loading and does not review without returned terms',
      (tester) async {
    final completer = Completer<PasPlanQuote>();
    await tester.pumpWidget(
      MaterialApp(
        home: PlanSetupPage(
          adapter: _PlanAdapter(quoteCompleter: completer),
          copy: const PayAmSmallCopy(),
          products: [_product()],
          onReview: (_) {},
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Loading quote…'), findsOneWidget);
    completer.complete(
      const PasPlanQuote(
        quoteId: 'quote-no-terms',
        termsVersion: 'terms-v1',
        facts: [],
        terms: [],
      ),
    );
    await tester.pumpAndSettle();
    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Review Plan Summary & Terms'),
    );
    expect(continueButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}
